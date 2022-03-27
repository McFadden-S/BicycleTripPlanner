import 'package:bicycle_trip_planner/models/route_types.dart';
import 'package:http/http.dart' as http;
import 'package:bicycle_trip_planner/models/route.dart';
import 'dart:convert' as convert;

import '../auth/Keys.dart';

class DirectionsService {
  final String key = Keys.getApiKey();
  Future<Route> getRoutes(String origin, String destination,
      [List<String> intermediates = const <String>[],
      bool optimised = true]) async {

    var waypoints = _generateWaypoints(intermediates, optimised);
    var url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=place_id:$origin&destination=place_id:$destination$waypoints&mode=bicycling&key=$key';

    var response = await http.get(Uri.parse(url));

    var json = convert.jsonDecode(response.body);
    var jsonResults = json['routes'][0] as Map<String, dynamic>;

    return Route.fromJson(jsonResults, RouteType.bike);
  }

  Future<Route> getWalkingRoutes(String origin, String destination,
      [List<String> intermediates = const <String>[],
      bool optimised = true]) async {
    var waypoints = _generateWaypoints(intermediates, optimised);
    var url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=place_id:$origin&destination=place_id:$destination$waypoints&mode=walking&key=$key';

    var response = await http.get(Uri.parse(url));

    var json = convert.jsonDecode(response.body);
    var jsonResults = json['routes'][0] as Map<String, dynamic>;

    return Route.fromJson(jsonResults, RouteType.walk);
  }

  String _generateWaypoints(List<String> intermediates,
      [bool optimised = true]) {
    String waypoints = "";
    // Only look at intermediates that aren't empty
    intermediates = List.from(intermediates);
    intermediates.removeWhere((stop) => stop == "");
    if (intermediates.isNotEmpty) {
      waypoints += "&waypoints=optimize:$optimised";
      for (var intermediate in intermediates) {
        waypoints += "|place_id:$intermediate";
      }
    }
    return waypoints;
  }
}
