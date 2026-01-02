
class SavedPlacesManager {
  static final SavedPlacesManager _instance = SavedPlacesManager._internal();
  factory SavedPlacesManager() => _instance;

  SavedPlacesManager._internal();

  final List<Map<String, dynamic>> _savedPlaces = [];

  // ✅ Add a place to saved list
  void addPlace(Map<String, dynamic> place) {
    if (!_savedPlaces.any((p) => p['title'] == place['title'])) {
      _savedPlaces.add(place);
    }
  }

  // ✅ Remove a place from saved list
  void removePlace(String title) {
    _savedPlaces.removeWhere((p) => p['title'] == title);
  }

  // ✅ Check if a place is already saved
  bool isSaved(String title) {
    return _savedPlaces.any((p) => p['title'] == title);
  }

  // ✅ Toggle save/remove (fixes your onPressed error)
  void togglePlace(Map<String, dynamic> place) {
    if (isSaved(place['title'])) {
      removePlace(place['title']);
    } else {
      addPlace(place);
    }
  }

  // ✅ Get all saved places
  List<Map<String, dynamic>> getSavedPlaces() {
    return List.unmodifiable(_savedPlaces);
  }
}
