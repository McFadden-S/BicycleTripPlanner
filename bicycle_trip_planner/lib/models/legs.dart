import 'package:bicycle_trip_planner/models/location.dart';
import 'package:bicycle_trip_planner/models/steps.dart';

class Legs {
  final Location startLocation;
  final Location endLocation;
  final List<Steps> steps;
  final int distance;
  final int duration;

  /**
   * constructor with specified required inputs
   */
  Legs(
      {required this.startLocation,
      required this.endLocation,
      required this.steps,
      required this.distance,
      required this.duration});

  /**
   * factory constructor when data is passed from Json
   * @param Map<dynamic, dynamic> parsed Json
   * @return Legs
   */
  factory Legs.fromJson(Map<dynamic, dynamic> parsedJson) {
    return Legs(
      startLocation: Location.fromJson(parsedJson['start_location']),
      endLocation: Location.fromJson(parsedJson['end_location']),
      steps:
          List<Steps>.from(parsedJson["steps"].map((s) => Steps.fromJson(s))),
      distance: parsedJson['distance']['value'],
      duration: parsedJson['duration']['value'],
    );
  }

  /**
   * method override the toString method
   * @return String of the toString of the object
   */
  @override
  String toString() {
    return steps.toString();
  }

  /**
   * method override the == operator
   * @return bool of whether the object is same or not
   */
  @override
  bool operator ==(Object other) {
    return other is Legs &&
        other.steps == steps &&
        other.startLocation == startLocation &&
        other.duration == duration &&
        other.endLocation == endLocation &&
        other.distance == distance;
  }

  /**
   * method override the get hashCode method
   * @return int of the hashCode
   */
  @override
  // TODO: implement hashCode
  int get hashCode =>
      Object.hash(steps, startLocation, endLocation, duration, distance);
}
