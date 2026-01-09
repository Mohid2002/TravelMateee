// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'trip_model.dart';

// class TripDetailScreen extends StatelessWidget {
//   final TripModel trip;

//   const TripDetailScreen({super.key, required this.trip});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(trip.name),
//         backgroundColor: Colors.blue,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // IMAGE
//             Image.asset(
//               trip.image,
//               height: 220,
//               width: double.infinity,
//               fit: BoxFit.cover,
//             ),

//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     trip.name,
//                     style: const TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),

//                   const SizedBox(height: 8),

//                   Row(
//                     children: [
//                       const Icon(Icons.location_on, color: Colors.red),
//                       const SizedBox(width: 5),
//                       Expanded(
//                         child: Text(
//                           trip.location,
//                           style: const TextStyle(fontSize: 16),
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 10),

//                   Row(
//                     children: [
//                       const Icon(Icons.calendar_month, color: Colors.blue),
//                       const SizedBox(width: 5),
//                       Text(
//                         DateFormat('dd MMM yyyy').format(trip.date),
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 20),

//                   const Text(
//                     "About this trip",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),

//                   const SizedBox(height: 8),

//                   Text(
//                     trip.history,
//                     style: const TextStyle(
//                       fontSize: 15,
//                       color: Colors.grey,
//                       height: 1.4,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
