import 'dart:async';
import 'package:flutter/material.dart';

import 'package:bicycle_trip_planner/models/station.dart';
import 'package:bicycle_trip_planner/models/route.dart' as Rou;
import 'package:bicycle_trip_planner/models/place.dart';
import 'package:bicycle_trip_planner/models/place_search.dart';
import 'package:bicycle_trip_planner/services/directions_service.dart';
import 'package:bicycle_trip_planner/services/places_service.dart';
import 'package:bicycle_trip_planner/services/stations_service.dart';

class ApplicationBloc with ChangeNotifier {
  
  final placesService = PlacesService();
  final directionsService = DirectionsService();
  final stationsService = StationsService();
  
  List<PlaceSearch> searchResults = List.empty(); 
  List<PlaceSearch>? searchDestinationsResults;
  List<PlaceSearch>? searchOriginsResults;
  StreamController<Rou.Route> currentRoute = StreamController<Rou.Route>();
  StreamController<Place> selectedLocation = StreamController<Place>();
  StreamController<List<Station>> stations = StreamController<List<Station>>();

  updateStations() async {
    stations.add(await stationsService.getStations());
    notifyListeners(); 
  }

  searchOrigins(String searchTerm) async {
    searchOriginsResults = await placesService.getAutocomplete(searchTerm);
    searchDestinationsResults = null;
    notifyListeners();
  }

  bool ifSearchResult(){
    return searchResults.isNotEmpty;
  }

  searchPlaces(String searchTerm) async {
    searchResults = await placesService.getAutocomplete(searchTerm);
    notifyListeners();
  }

  setSelectedLocation(String placeId) async {
    selectedLocation.add(await placesService.getPlace(placeId));
    searchResults.clear();
    notifyListeners();
  }

  findRoute(String origin, String destination) async {
    currentRoute
        .add(await directionsService.getRoutes(origin, destination));
    notifyListeners();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    selectedLocation.close();
    super.dispose();
  }
}
