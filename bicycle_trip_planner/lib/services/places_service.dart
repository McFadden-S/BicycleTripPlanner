import 'package:http/http.dart' as http;
import 'package:bicycle_trip_planner/models/place.dart';
import 'package:bicycle_trip_planner/models/place_search.dart';
import 'dart:convert' as convert;

import '../auth/Keys.dart';

class PlacesService {
  String key = Keys.getApiKey();
  final String prefixUrl = 'https://maps.googleapis.com/maps/api';
  Future<List<PlaceSearch>> getAutocomplete(String search) async {
    var url =
        '$prefixUrl/place/autocomplete/json?input=$search&components=country:gb&location=51.495830%2C-0.145607&radius=35000&strictbounds=true&key=$key';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['predictions'] as List;
    return jsonResults.map((place) => PlaceSearch.fromJson(place)).toList();
  }

  Future<Place> getPlace(String placeId, String description) async {
    var url = '$prefixUrl/place/details/json?key=$key&place_id=$placeId';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    if (json.containsKey('result')) {
      var jsonResults = json['result'] as Map<String, dynamic>;
      return Place.fromJson(jsonResults, description);
    } else {
      return const Place.placeNotFound();
    }
  }

  Future<Place> getPlaceFromCoordinates(
      double lat, double lng, String description) async {
    var url = '$prefixUrl/geocode/json?key=$key&latlng=$lat,$lng';
    var response = await http.get(Uri.parse(url));
    return _getPlaceFromJson(response, description);
  }

  Future<Place> getPlaceFromAddress(String address, String description) async {
    var url = '$prefixUrl/geocode/json?key=$key&address=$address';
    var response = await http.get(Uri.parse(url));
    return _getPlaceFromJson(response, description);
  }

  Place _getPlaceFromJson(var response, String description) {
    var json = convert.jsonDecode(response.body);
    if (json.containsKey('results') && json['results'].length > 0) {
      var jsonResults = json['results'][0] as Map<String, dynamic>;
      return Place.fromJson(jsonResults, description);
    } else {
      return const Place.placeNotFound();
    }
  }
}
