class TripModel {
  final String name;
  final String location;
  final String image;
  final DateTime date;
  final String history;
  final double lat;
  final double lon;

  TripModel({
    required this.name,
    required this.location,
    required this.image,
    required this.date,
    required this.history,
    required this.lat,
    required this.lon,
  });
}

// GLOBAL LIST
List<TripModel> savedTrips = [];  
