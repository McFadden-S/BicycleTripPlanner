import 'location.dart';

class Legs {
  final Location startLocation;
  final Location endLocation;

  Legs({this.startLocation, this.endLocation});

  factory Legs.fromJson(Map<dynamic, dynamic> parsedJson) {
    return Legs(
      startLocation: Location.fromJson(parsedJson['start_location']),
      endLocation: Location.fromJson(parsedJson['end_location']),
    );
  }
}
