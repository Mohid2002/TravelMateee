class TripModel {
  final String image;
  final String name;
  final String location;
  final DateTime date;

  TripModel({
    required this.image,
    required this.name,
    required this.location,
    required this.date,
  });
}

List<TripModel> savedTrips = [];
