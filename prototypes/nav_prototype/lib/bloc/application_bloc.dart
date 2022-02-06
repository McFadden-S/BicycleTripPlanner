import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nav_prototype/models/direction.dart';
import 'package:nav_prototype/models/place.dart';
import 'package:nav_prototype/models/place_search.dart';
import 'package:nav_prototype/services/directions_service.dart';
import 'package:nav_prototype/services/places_service.dart';

class ApplicationBloc with ChangeNotifier {
  final placesService = PlacesService();
  final directionsService = DirectionsService();

  List<PlaceSearch> searchDestinationsResults;
  List<PlaceSearch> searchOriginsResults;
  StreamController<Direction> currentDirection = StreamController<Direction>();
  StreamController<Place> selectedLocation = StreamController<Place>();

  searchOrigins(String searchTerm) async {
    searchOriginsResults = await placesService.getAutocomplete(searchTerm);
    searchDestinationsResults = null;
    notifyListeners();
  }

  searchDestinations(String searchTerm) async {
    searchDestinationsResults = await placesService.getAutocomplete(searchTerm);
    searchOriginsResults = null;
    notifyListeners();
  }

  setSelectedLocation(String placeId) async {
    selectedLocation.add(await placesService.getPlace(placeId));
    searchOriginsResults = null;
    searchDestinationsResults = null;
    notifyListeners();
  }

  findRouteDirection(String origin, String destination) async {
    currentDirection.add(await directionsService.getDirections(origin, destination));
    notifyListeners();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    selectedLocation.close();
    super.dispose();
  }
}
