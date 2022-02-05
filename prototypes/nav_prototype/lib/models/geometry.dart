import 'package:nav_prototype_test/models/location.dart';

class Geometry {
  final Location locaiton;

  Geometry({this.locaiton});

  factory Geometry.fromJson(Map<dynamic,dynamic> parsedJson){
    return Geometry(
      locaiton: Location.fromJson(parsedJson['location'])
    );
  }
}