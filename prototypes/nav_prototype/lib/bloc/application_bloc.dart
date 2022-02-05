import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nav_prototype_test/models/place.dart';
import 'package:nav_prototype_test/models/place_search.dart';
import 'package:nav_prototype_test/services/places_service.dart';

class ApplicationBloc with ChangeNotifier {

  final placesService = PlacesService();

  List<PlaceSearch> searchResults;
  Set<Place> markers;
  StreamController<Place> selectedLocation = StreamController<Place>();

  searchPlaces(String searchTerm) async {
    searchResults = await placesService.getAutocomplete(searchTerm);
    notifyListeners();
  }

  setSelectedLocation(String placeId) async{
    selectedLocation.add(await placesService.getPlace(placeId));
    searchResults = null;
    notifyListeners();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    selectedLocation.close();
    super.dispose();
  }
}