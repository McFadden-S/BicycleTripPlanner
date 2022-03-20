class Location {
  final double lat;
  final double lng;

  Location({required this.lat, required this.lng});

  const Location.locationNotFound({this.lat = 0, this.lng = 0});

  factory Location.fromJson(Map<dynamic, dynamic> parsedJson) {
    return Location(lat: parsedJson['lat'], lng: parsedJson['lng']);
  }
}
