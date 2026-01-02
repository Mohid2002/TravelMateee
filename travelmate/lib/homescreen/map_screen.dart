import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _currentLocation;
  bool _isLoading = true;

  final PopupController _popupController = PopupController();
  final List<Marker> _markers = [];
  final List<MarkerData> _markerData = [];

  List<LatLng> _routePoints = []; // ✅ ROUTE LINE
  late Marker _userMarker; // ✅ Reference to user marker

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      setState(() => _isLoading = false);
      return;
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );

    _currentLocation = LatLng(position.latitude, position.longitude);
    await _fetchNearbyPlaces();
  }

  Future<void> _fetchNearbyPlaces() async {
    final url =
        "https://overpass-api.de/api/interpreter?data=[out:json];"
        "(node[\"amenity\"=\"restaurant\"](around:1200,${_currentLocation!.latitude},${_currentLocation!.longitude});"
        "node[\"amenity\"=\"hospital\"](around:1200,${_currentLocation!.latitude},${_currentLocation!.longitude});"
        "node[\"tourism\"=\"hotel\"](around:1200,${_currentLocation!.latitude},${_currentLocation!.longitude}););out;";

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);
    final elements = data["elements"] as List;

    for (var e in elements) {
      final lat = e["lat"];
      final lon = e["lon"];
      if (lat == null || lon == null) continue;

      final type = e["tags"]?["amenity"] ?? e["tags"]?["tourism"];
      final name = e["tags"]?["name"] ?? "Unknown";

      Color color = Colors.blue;
      if (type == "hospital") color = Colors.red;
      if (type == "hotel") color = Colors.green;

      // ✅ Fix for local variable closure issue
      late final Marker marker;
      marker = Marker(
        point: LatLng(lat, lon),
        width: 40,
        height: 40,
        child: GestureDetector(
          onTap: () {
            _drawRoute(LatLng(lat, lon)); // Draw route
            _popupController.togglePopup(marker); // Show popup
          },
          child: Icon(Icons.location_on, color: color, size: 36),
        ),
      );

      _markers.add(marker);
      _markerData.add(MarkerData(marker: marker, name: name, type: type));
    }

    // Add user location marker
    _userMarker = Marker(
      point: _currentLocation!,
      width: 45,
      height: 45,
      child: GestureDetector(
        onTap: () {
          _popupController.togglePopup(_userMarker); // Show user popup
        },
        child: const Icon(Icons.my_location, color: Colors.black, size: 36),
      ),
    );

    _markers.add(_userMarker);
    _markerData.add(MarkerData(marker: _userMarker, name: "My Location", type: ""));

    setState(() => _isLoading = false);
  }

  /// 🔥 DRAW ROUTE USING OSRM
  Future<void> _drawRoute(LatLng destination) async {
    final url =
        "https://router.project-osrm.org/route/v1/driving/"
        "${_currentLocation!.longitude},${_currentLocation!.latitude};"
        "${destination.longitude},${destination.latitude}"
        "?overview=full&geometries=geojson";

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    final coords = data["routes"][0]["geometry"]["coordinates"] as List;

    setState(() {
      _routePoints = coords
          .map((c) => LatLng(c[1] as double, c[0] as double))
          .toList();
    });
  }

  /// ✅ BUILD TOP-LEFT LEGEND BOX
  Widget _buildLegendBox() {
    return Positioned(
      top: 15,
      left: 15,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 6),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _LegendItem(icon: Icons.my_location, color: Colors.black, text: "My Location"),
            SizedBox(height: 6),
            _LegendItem(icon: Icons.location_on, color: Colors.blue, text: "Restaurant"),
            SizedBox(height: 6),
            _LegendItem(icon: Icons.location_on, color: Colors.green, text: "Hotel"),
            SizedBox(height: 6),
            _LegendItem(icon: Icons.location_on, color: Colors.red, text: "Hospital"),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Route Navigation")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                FlutterMap(
                  options: MapOptions(
                    center: _currentLocation!,
                    zoom: 15,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                      userAgentPackageName: "com.example.app",
                    ),

                    /// ✅ GREEN ROUTE LINE
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: _routePoints,
                          strokeWidth: 5,
                          color: Colors.green,
                        ),
                      ],
                    ),

                    PopupMarkerLayerWidget(
                      options: PopupMarkerLayerOptions(
                        markers: _markers,
                        popupController: _popupController,
                        popupDisplayOptions: PopupDisplayOptions(
                          builder: (_, marker) {
                            final data = _markerData.firstWhere(
                              (e) => e.marker.point == marker.point,
                              orElse: () => MarkerData(
                                marker: marker,
                                name: "Location",
                                type: "",
                              ),
                            );
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      data.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(data.type),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                /// ✅ LEGEND BOX
                _buildLegendBox(),
              ],
            ),
    );
  }
}

/// DATA MODEL
class MarkerData {
  final Marker marker;
  final String name;
  final String type;

  MarkerData({
    required this.marker,
    required this.name,
    required this.type,
  });
}

/// LEGEND ITEM WIDGET
class _LegendItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;

  const _LegendItem({
    required this.icon,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}
