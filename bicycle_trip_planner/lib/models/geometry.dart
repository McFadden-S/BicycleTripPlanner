import 'package:bicycle_trip_planner/models/location.dart';

class Geometry {
  final Location location;

  /**
   * constructor with specified required inputs
   */
  Geometry({required this.location});

  /**
   * constructor default assignments when geometry is not found
   */
  const Geometry.geometryNotFound({this.location = const Location.locationNotFound()});

  /**
   * factory constructor when data is passed from Json
   * @param Map<dynamic, dynamic> parsed Json
   */
  factory Geometry.fromJson(Map<dynamic, dynamic> parsedJson) {
    return Geometry(location: Location.fromJson(parsedJson['location']));
  }
}
