import 'legs.dart';
import 'location.dart';
import 'overview_polyline.dart';

class Bounds {
  final Map<String, dynamic>? northeast;
  final Map<String, dynamic>? southwest;

  Bounds({this.northeast, this.southwest});

  factory Bounds.fromJson(Map<dynamic, dynamic> parsedJson) {
    return Bounds(
      northeast: parsedJson['northeast'],
      southwest: parsedJson['southwest'],
    );
  }
}
