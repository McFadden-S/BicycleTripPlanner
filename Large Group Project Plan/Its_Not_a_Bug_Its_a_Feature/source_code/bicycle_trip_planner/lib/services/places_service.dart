import 'package:http/http.dart' as http;
import 'package:bicycle_trip_planner/models/place.dart';
import 'package:bicycle_trip_planner/models/place_search.dart';
import 'dart:convert' as convert;

import '../auth/Keys.dart';

/// Class Comment:
/// PlaceService is a service class that returns Place according to
/// response from maps.googleapis.com website

class PlacesService {

  String key = Keys.API_KEY;
  final String prefixUrl = 'https://maps.googleapis.com/maps/api';

  /// @param search - String; actual search
  /// @return List<PlaceSearch> - list of all possible Places searched by @param search
  Future<List<PlaceSearch>> getAutocomplete(String search) async {
    var url =
        '$prefixUrl/place/autocomplete/json?input=$search&components=country:gb&location=51.495830%2C-0.145607&radius=35000&strictbounds=true&key=$key';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['predictions'] as List;
    return jsonResults.map((place) => PlaceSearch.fromJson(place)).toList();
  }

  /// @param placeId - String;
  /// @param description - String; description of the place
  /// @return Place - Place that was found from the placeId
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

  /// @param lat - double; latitude
  /// @param lng - double; longitude
  /// @param description - String; description of the place
  /// @return Place - Place that was found from the lat and lng
  Future<Place> getPlaceFromCoordinates(
      double lat, double lng, String description) async {
    var url = '$prefixUrl/geocode/json?key=$key&latlng=$lat,$lng';
    var response = await http.get(Uri.parse(url));
    return _getPlaceFromJson(response, description);
  }

  /// @param address - String; address of a place
  /// @param description - String; description of the place
  /// @return Place - Place that was found from the address
  Future<Place> getPlaceFromAddress(String address, String description) async {
    var url = '$prefixUrl/geocode/json?key=$key&address=$address';
    var response = await http.get(Uri.parse(url));
    return _getPlaceFromJson(response, description);
  }

  /// @param response - response from google maps search for a place
  /// @param description - String; description of the place
  /// @return Place - Place that was created from the response
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
