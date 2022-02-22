import 'package:http/http.dart' as http;
import 'package:bicycle_trip_planner/models/route.dart';
import 'dart:convert' as convert;

class DirectionsService {
  Future<Route> getRoutes(String origin, String destination, [List<String> intermediates = const <String>[]]) async {
    const key = 'AIzaSyBcUJrLd8uIYR2HFTNa6mj-7lVRyUIJXs0';

    // NOTE: Directions for waypoints potentially result in partway directions 
    // Google recommends to use 'via' when querying url to avoid directions stopping at the waypoint. 
    var waypoints = _generateWaypoints(intermediates);
    var url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination$waypoints&mode=bicycling&key=$key';

    var response = await http.get(Uri.parse(url));

    var json = convert.jsonDecode(response.body);
    var jsonResults = json['routes'][0] as Map<String, dynamic>;

    return Route.fromJson(jsonResults);
  }

  String _generateWaypoints(List<String> intermediates, [bool optimized = true]){
    String waypoints = "";
    if(intermediates.isNotEmpty){
      waypoints += "&waypoints=optimize:$optimized";
      for(var intermediate in intermediates){
        waypoints += "|$intermediate";
      }
    }
    return waypoints;
  }
}