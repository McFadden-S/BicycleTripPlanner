import 'location.dart';

class Legs {
  final Location startLocation;
  final Location endLocation;
  final int distance;
  final int duration;

  Legs({this.startLocation, this.endLocation, this.distance, this.duration});

  factory Legs.fromJson(Map<dynamic, dynamic> parsedJson) {
    return Legs(
      startLocation: Location.fromJson(parsedJson['start_location']),
      endLocation: Location.fromJson(parsedJson['end_location']),
      distance: parsedJson['distance']['value'],
      duration: parsedJson['duration']['value'],
    );
  }
}
