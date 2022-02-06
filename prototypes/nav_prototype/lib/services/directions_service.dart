import 'package:http/http.dart' as http;
import 'package:nav_prototype/models/direction.dart';
import 'dart:convert' as convert;

class DirectionsService {
  Future<Direction> getDirections(String origin, String destination) async {
    final key = 'AIzaSyBcUJrLd8uIYR2HFTNa6mj-7lVRyUIJXs0';
    var url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&mode=bicycling&key=$key';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['routes'][0] as Map<String, dynamic>;
    print(jsonResults);
    print(Direction.fromJson(jsonResults).legs.steps.first.instruction);
    return Direction.fromJson(jsonResults);
    // PlaceSearch.fromJson(data)).toList();
  }
}