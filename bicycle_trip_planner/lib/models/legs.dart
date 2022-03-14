import 'package:bicycle_trip_planner/models/location.dart';
import 'package:bicycle_trip_planner/models/steps.dart';

class Legs {
  final Location startLocation;
  final Location endLocation;
  final List<Steps> steps;
  final int distance;
  final int duration;

  Legs(
      {required this.startLocation,
      required this.endLocation,
      required this.steps,
      required this.distance,
      required this.duration});

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

  @override
  String toString() {
    return steps.toString();
  }
}
