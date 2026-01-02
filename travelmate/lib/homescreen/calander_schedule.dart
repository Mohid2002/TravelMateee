import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travelmate/homescreen/trip_model.dart';
import 'trip_detail_screen.dart';

class CalendarSchedule extends StatefulWidget {
  const CalendarSchedule({super.key});

  @override
  State<CalendarSchedule> createState() => _CalendarScheduleState();
}

class _CalendarScheduleState extends State<CalendarSchedule> {

  void deleteTrip(int index) {
    setState(() {
      savedTrips.removeAt(index);
    });
  }

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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TripDetailScreen(trip: trip),
                      ),
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
                                    DateFormat('dd MMM yyyy')
                                        .format(trip.date),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        IconButton(
                          onPressed: () => deleteTrip(index),
                          icon: const Icon(Icons.delete,
                              color: Colors.red, size: 26),
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
