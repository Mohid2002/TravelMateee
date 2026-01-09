import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  final double destLat;
  final double destLon;
  final String destName;

  const MapScreen({
    super.key,
    required this.destLat,
    required this.destLon,
    required this.destName,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _currentLocation;
  bool _isLoading = true;

  final PopupController _popupController = PopupController();
  final List<Marker> _markers = [];
  final List<MarkerData> _markerData = [];

  List<LatLng> _routePoints = [];

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        // Permission denied, use default location (Islamabad)
        _currentLocation = LatLng(33.6844, 73.0479);
        setState(() => _isLoading = false);
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      _currentLocation = LatLng(position.latitude, position.longitude);
      await _fetchNearbyPlaces();
    } catch (e) {
      // On error, fallback to default location
      _currentLocation = LatLng(33.6844, 73.0479);
      setState(() => _isLoading = false);
      print("Error fetching location: $e");
    }
  }

  Marker _createMarker({
    required double lat,
    required double lon,
    required String name,
    required String type,
    bool isBest = false,
  }) {
    IconData icon = Icons.location_on;
    Color color = Colors.blue;
    double size = 34;

    if (type == "hospital") {
      icon = Icons.local_hospital;
      color = Colors.red;
    } else if (type == "restaurant") {
      icon = Icons.restaurant;
      color = isBest ? Colors.deepOrange : Colors.orange;
      size = isBest ? 42 : 34;
    } else if (type == "hotel") {
      icon = Icons.apartment;
      color = Colors.green;
    } else if (type == "destination") {
      icon = Icons.place;
      color = Colors.purple;
    } else if (type == "user") {
      icon = Icons.my_location;
      color = Colors.black;
    }

    final point = LatLng(lat, lon);

    final marker = Marker(
      point: point,
      width: 45,
      height: 45,
      child: GestureDetector(
        onTap: () {
          _drawRoute(point);
          _popupController.hideAllPopups();
          final found = _markers.firstWhere((m) => m.point == point);
          _popupController.togglePopup(found);
        },
        child: Icon(icon, color: color, size: size),
      ),
    );

    _markerData.add(
      MarkerData(
        marker: marker,
        name: name,
        type: type,
        isBest: isBest,
      ),
    );

    return marker;
  }

  Future<void> _fetchNearbyPlaces() async {
    try {
      final url =
          "https://overpass-api.de/api/interpreter?data=[out:json];"
          "(node[\"amenity\"=\"restaurant\"](around:1200,${_currentLocation!.latitude},${_currentLocation!.longitude});"
          "node[\"amenity\"=\"hospital\"](around:1200,${_currentLocation!.latitude},${_currentLocation!.longitude});"
          "node[\"tourism\"=\"hotel\"](around:1200,${_currentLocation!.latitude},${_currentLocation!.longitude}););out;";

      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) throw Exception("API failed");

      final data = json.decode(response.body);
      final elements = data["elements"] as List? ?? [];

      List<Map<String, dynamic>> restaurants = [];

      for (var e in elements) {
        final lat = e["lat"];
        final lon = e["lon"];
        if (lat == null || lon == null) continue;

        final type = e["tags"]?["amenity"] ?? e["tags"]?["tourism"];
        final name = e["tags"]?["name"] ?? "Unknown";

        if (type == "restaurant") {
          restaurants.add({"lat": lat, "lon": lon, "name": name});
        } else {
          _markers.add(
            _createMarker(lat: lat, lon: lon, name: name, type: type),
          );
        }
      }

      if (restaurants.isNotEmpty) {
        final randomIndex = Random().nextInt(restaurants.length);
        final best = restaurants[randomIndex];

        _markers.add(
          _createMarker(
            lat: best["lat"],
            lon: best["lon"],
            name: "⭐ Best Restaurant\n${best["name"]}",
            type: "restaurant",
            isBest: true,
          ),
        );

        for (int i = 0; i < restaurants.length; i++) {
          if (i == randomIndex) continue;
          final r = restaurants[i];
          _markers.add(
            _createMarker(
              lat: r["lat"],
              lon: r["lon"],
              name: r["name"],
              type: "restaurant",
            ),
          );
        }
      }

      // Add user & destination markers
      _markers.add(_createMarker(
        lat: _currentLocation!.latitude,
        lon: _currentLocation!.longitude,
        name: "My Location",
        type: "user",
      ));

      _markers.add(_createMarker(
        lat: widget.destLat,
        lon: widget.destLon,
        name: widget.destName,
        type: "destination",
      ));

      _drawRoute(LatLng(widget.destLat, widget.destLon));
    } catch (e) {
      print("Error fetching nearby places: $e");
      // fallback: just show user & destination
      _markers.add(_createMarker(
        lat: _currentLocation!.latitude,
        lon: _currentLocation!.longitude,
        name: "My Location",
        type: "user",
      ));
      _markers.add(_createMarker(
        lat: widget.destLat,
        lon: widget.destLon,
        name: widget.destName,
        type: "destination",
      ));
      _drawRoute(LatLng(widget.destLat, widget.destLon));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _drawRoute(LatLng destination) async {
    if (_currentLocation == null) return;

    try {
      final url =
          "https://router.project-osrm.org/route/v1/driving/"
          "${_currentLocation!.longitude},${_currentLocation!.latitude};"
          "${destination.longitude},${destination.latitude}"
          "?overview=full&geometries=geojson";

      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) throw Exception("Route API failed");

      final data = json.decode(response.body);
      final coords = data["routes"][0]["geometry"]["coordinates"] as List;

      setState(() {
        _routePoints =
            coords.map((c) => LatLng(c[1].toDouble(), c[0].toDouble())).toList();
      });
    } catch (e) {
      print("Error fetching route: $e");
      setState(() => _routePoints = []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Map & Route")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                FlutterMap(
                  options: MapOptions(
                    center: _currentLocation,
                    zoom: 15,
                    onTap: (_, __) => _popupController.hideAllPopups(),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                      userAgentPackageName: "com.example.app",
                    ),
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: _routePoints,
                          strokeWidth: 5,
                          color: Colors.red,
                        ),
                      ],
                    ),
                    PopupMarkerLayerWidget(
                      options: PopupMarkerLayerOptions(
                        markers: _markers,
                        popupController: _popupController,
                        popupDisplayOptions: PopupDisplayOptions(
                          builder: (_, marker) {
                            final data = _markerData
                                .firstWhere((e) => e.marker.point == marker.point);

                            return Card(
                              color:
                                  data.isBest ? Colors.orange.shade50 : Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      data.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: data.isBest
                                            ? Colors.deepOrange
                                            : Colors.black,
                                      ),
                                    ),
                                    if (data.isBest)
                                      const Text(
                                        "Recommended for you ⭐",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.deepOrange),
                                      ),
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
                Positioned(
                  top: 12,
                  left: 12,
                  child: _buildLegendBox(),
                ),
              ],
            ),
    );
  }

  Widget _buildLegendBox() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: const [
            _LegendItem(
              icon: Icons.my_location,
              color: Colors.black,
              text: "My Location",
            ),
            _LegendItem(
              icon: Icons.place,
              color: Colors.purple,
              text: "Destination",
            ),
            _LegendItem(
              icon: Icons.restaurant,
              color: Colors.orange,
              text: "Restaurant",
            ),
            _LegendItem(
              icon: Icons.restaurant,
              color: Colors.deepOrange,
              text: "Best Restaurant",
            ),
            _LegendItem(
              icon: Icons.local_hospital,
              color: Colors.red,
              text: "Hospital",
            ),
            _LegendItem(
              icon: Icons.apartment,
              color: Colors.green,
              text: "Hotel",
            ),
          ],
        ),
      ),
    );
  }
}

class MarkerData {
  final Marker marker;
  final String name;
  final String type;
  final bool isBest;

  MarkerData({
    required this.marker,
    required this.name,
    required this.type,
    this.isBest = false,
  });
}

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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
