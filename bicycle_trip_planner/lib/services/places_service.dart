import 'package:bicycle_trip_planner/models/geometry.dart';
import 'package:http/http.dart' as http;
import 'package:bicycle_trip_planner/models/place.dart';
import 'package:bicycle_trip_planner/models/place_search.dart';
import 'dart:convert' as convert;

class PlacesService {
  Future<List<PlaceSearch>> getAutocomplete(String search, http.Client client) async {
    const key = 'AIzaSyBcUJrLd8uIYR2HFTNa6mj-7lVRyUIJXs0';
    var url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&components=country:gb&location=51.495830%2C-0.145607&radius=35000&strictbounds=true&key=$key';
    var response = await client.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['predictions'] as List;
    return jsonResults.map((place) => PlaceSearch.fromJson(place)).toList();
  }

  Future<Place> getPlace(String placeId, String description) async {
    const key = 'AIzaSyBcUJrLd8uIYR2HFTNa6mj-7lVRyUIJXs0';
    var url =
        'https://maps.googleapis.com/maps/api/place/details/json?key=$key&place_id=$placeId';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['result'] as Map<String, dynamic>;
    return Place.fromJson(jsonResults, description);
  }

  Future<Place> getPlaceFromCoordinates(double lat, double lng, String description, http.Client client) async {
    const key = 'AIzaSyBcUJrLd8uIYR2HFTNa6mj-7lVRyUIJXs0';
    var url =
        'https://maps.googleapis.com/maps/api/geocode/json?key=$key&latlng=$lat,$lng';
    var response = await client.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['results'][0] as Map<String, dynamic>;
    return Place.fromJson(jsonResults, description);
  }

  Future<Place> getPlaceFromAddress(String address, String description) async {
    const key = 'AIzaSyBcUJrLd8uIYR2HFTNa6mj-7lVRyUIJXs0';
    var url =
        'https://maps.googleapis.com/maps/api/geocode/json?key=$key&address=$address';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['results'][0] as Map<String, dynamic>;
    return Place.fromJson(jsonResults, description);
  }
}
