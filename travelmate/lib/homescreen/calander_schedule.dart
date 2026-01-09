import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travelmate/homescreen/place_detailed_home_Screen.dart';
import 'package:travelmate/homescreen/trip_model.dart';
import 'package:travelmate/service/weather_notification_service.dart';

class CalendarSchedule extends StatefulWidget {
  final int? tripIndexFromNotification; // optional: trip index from notification

  const CalendarSchedule({super.key, this.tripIndexFromNotification});

  @override
  State<CalendarSchedule> createState() => _CalendarScheduleState();
}

class _CalendarScheduleState extends State<CalendarSchedule> {
  @override
  void initState() {
    super.initState();

    // Show reschedule dialog if navigated from notification
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.tripIndexFromNotification != null &&
          widget.tripIndexFromNotification! < savedTrips.length) {
        _showRescheduleDialog(widget.tripIndexFromNotification!);
      }
    });
  }

  // ------------------- RESCHEDULE DIALOG -------------------
  void _showRescheduleDialog(int tripIndex) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Would you like to reschedule your trip?"),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx), // Ignore
            child: const Text("Ignore"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx); // Close dialog
              await _updateTripDate(tripIndex); // Open date picker
            },
            child: const Text("Update Dates"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx), // Close
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  // ------------------- UPDATE TRIP DATE -------------------
  Future<void> _updateTripDate(int tripIndex) async {
    final trip = savedTrips[tripIndex];
    final newDate = await showDatePicker(
      context: context,
      initialDate: trip.date,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );

    if (newDate != null) {
      setState(() {
        savedTrips[tripIndex].date = newDate; // ✅ works now
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Trip date updated successfully!")),
      );
    }
  }

  // ------------------- DELETE TRIP -------------------
  void deleteTrip(int index) async {
    setState(() {
      savedTrips.removeAt(index);
    });

    /// Stop weather notifications when trip deleted
    await WeatherNotificationService.cancelAll();
  }

  // ------------------- BUILD -------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scheduled Trips"),
        backgroundColor: Colors.blue,
      ),
      body: savedTrips.isEmpty
          ? const Center(
              child: Text(
                "No trips scheduled yet!",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: savedTrips.length,
              itemBuilder: (context, index) {
                final trip = savedTrips[index];

                return GestureDetector(
                  onTap: () {
                    // Navigate to place details
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PlaceDetailScreen(
                          place: {
                            "imageUrl": trip.image,
                            "name": trip.name,
                            "location": trip.location,
                            "history": trip.history,
                            "lat": trip.lat,
                            "lon": trip.lon,
                          },
                        ),
                      ),
                    );

                    // Start hourly weather notifications
                    WeatherNotificationService.scheduleHourlyWeather(
                      placeName: trip.name,
                      lat: trip.lat,
                      lon: trip.lon,
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            trip.image,
                            height: 70,
                            width: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                trip.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Icon(Icons.location_on,
                                      size: 16, color: Colors.red),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      trip.location,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_month,
                                      size: 16, color: Colors.blue),
                                  const SizedBox(width: 4),
                                  Text(
                                    DateFormat('dd MMM yyyy').format(trip.date),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => deleteTrip(index),
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 26,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
