import 'package:http/http.dart' as http;
import 'package:bicycle_trip_planner/models/route.dart';
import 'dart:convert' as convert;

class DirectionsService {
  Future<Route> getRoutes(String origin, String destination) async {
    const key = 'AIzaSyBcUJrLd8uIYR2HFTNa6mj-7lVRyUIJXs0';
    var url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&mode=bicycling&key=$key';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['routes'][0] as Map<String, dynamic>;
    print(jsonResults);
    return Route.fromJson(jsonResults);
    // PlaceSearch.fromJson(data)).toList();
  }
}
