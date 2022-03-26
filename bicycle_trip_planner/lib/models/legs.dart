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

  const Legs.legsNotFound(
      {this.startLocation = const Location.locationNotFound(),
      this.endLocation = const Location.locationNotFound(),
      this.steps = const [],
      this.duration = 0,
      this.distance = 0});

  @override
  String toString() {
    return steps.toString();
  }

  @override
  bool operator ==(Object other) {
    return other is Legs &&
        other.steps == steps &&
        other.startLocation == startLocation &&
        other.duration == duration &&
        other.endLocation == endLocation &&
        other.distance == distance;
  }

  @override
  // TODO: implement hashCode
  int get hashCode =>
      Object.hash(steps, startLocation, endLocation, duration, distance);
}
