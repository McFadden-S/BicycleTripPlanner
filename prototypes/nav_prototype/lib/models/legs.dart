import 'location.dart';
import 'step.dart';

class Legs {
  final Location startLocation;
  final Location endLocation;
  final List<Step> steps;
  final int distance;
  final int duration;

  Legs({this.startLocation, this.endLocation, this.steps, this.distance, this.duration});

  factory Legs.fromJson(Map<dynamic, dynamic> parsedJson) {
    return Legs(
      startLocation: Location.fromJson(parsedJson['start_location']),
      endLocation: Location.fromJson(parsedJson['end_location']),
      steps: List<Step>.from(parsedJson["steps"].map((s) => Step.fromJson(s))),
      distance: parsedJson['distance']['value'],
      duration: parsedJson['duration']['value'],
    );
  }
}
