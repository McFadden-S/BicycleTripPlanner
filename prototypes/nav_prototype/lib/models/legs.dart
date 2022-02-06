import 'location.dart';
import 'steps.dart';

class Legs {
  final Location startLocation;
  final Location endLocation;
  final List<Steps> steps;
  final int distance;
  final int duration;

  Legs({this.startLocation, this.endLocation, this.steps, this.distance, this.duration});

  factory Legs.fromJson(Map<dynamic, dynamic> parsedJson) {
    return Legs(
      startLocation: Location.fromJson(parsedJson['start_location']),
      endLocation: Location.fromJson(parsedJson['end_location']),
      steps: List<Steps>.from(parsedJson["steps"].map((s) => Steps.fromJson(s))),
      distance: parsedJson['distance']['value'],
      duration: parsedJson['duration']['value'],
    );
  }
}
