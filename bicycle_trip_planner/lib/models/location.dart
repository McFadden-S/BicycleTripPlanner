class Location {
  final double lat;
  final double lng;

  /**
   * constructor with specified required inputs
   */
  Location({required this.lat, required this.lng});

  /**
   * constructor default assignments when location is not found
   */
  const Location.locationNotFound({this.lat = 0, this.lng = 0});

  /**
   * factory constructor when data is passed from Json
   * @param Map<dynamic, dynamic> parsed Json
   */
  factory Location.fromJson(Map<dynamic, dynamic> parsedJson) {
    return Location(lat: parsedJson['lat'], lng: parsedJson['lng']);
  }
}
