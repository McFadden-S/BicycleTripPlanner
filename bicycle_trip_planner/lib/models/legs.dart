
import 'package:bicycle_trip_planner/models/steps.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Legs {
  final LatLng startLocation;
  final LatLng endLocation;
  final List<Steps> steps;
  final int distance;
  final int duration;

  /// constructor with specified required inputs
  Legs(
      {required this.startLocation,
      required this.endLocation,
      required this.steps,
      required this.distance,
      required this.duration});

  /// factory constructor when data is passed from Json
  /// @param Map<dynamic, dynamic> parsed Json
  /// @return Legs
  factory Legs.fromJson(Map<dynamic, dynamic> parsedJson) {
    return Legs(
      startLocation: LatLng(parsedJson['start_location']['lat'], parsedJson['start_location']['lng']),
      endLocation: LatLng(parsedJson['end_location']['lat'], parsedJson['end_location']['lng']),
      steps:
          List<Steps>.from(parsedJson["steps"].map((s) => Steps.fromJson(s))),
      distance: parsedJson['distance']['value'],
      duration: parsedJson['duration']['value'],
    );
  }

  /// Default Legs object
  const Legs.legsNotFound(
      {this.startLocation = const LatLng(0, 0),
      this.endLocation = const LatLng(0, 0),
      this.steps = const [],
      this.duration = 0,
      this.distance = 0});

  /// method override the toString method
  /// @return String of the toString of the object
  @override
  String toString() {
    return steps.toString();
  }

  /// method override the == operator
  /// @return bool of whether the object is same or not
  @override
  bool operator ==(Object other) {
    return other is Legs &&
        other.steps == steps &&
        other.startLocation == startLocation &&
        other.duration == duration &&
        other.endLocation == endLocation &&
        other.distance == distance;
  }

  /// method override the get hashCode method
  /// @return int of the hashCode
  @override
  int get hashCode =>
      Object.hash(steps, startLocation, endLocation, duration, distance);
}
