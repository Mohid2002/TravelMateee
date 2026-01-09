class TripModel {
  final String name;
  final String location;
  final String image;
  DateTime date; // <- remove final
  final String history;
  final double lat;
  final double lon;

  TripModel({
    required this.name,
    required this.location,
    required this.image,
    required this.date, // now mutable
    required this.history,
    required this.lat,
    required this.lon,
  });
}


// GLOBAL LIST
List<TripModel> savedTrips = [];  
