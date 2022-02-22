import 'dart:ui';

import 'package:bicycle_trip_planner/models/place.dart';
import 'package:bicycle_trip_planner/models/station.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerManager {

  //********** Fields **********

  final Set<Marker> _markers = <Marker>{};

  // int _markerIdCounter = 1;
  final String _startMarkerID = "Start";
  final String _finalDestinationMarkerID = "Final Destination";

  final List<Station> _stations = List.empty();

  //********** Singleton **********

  static final MarkerManager _markerManager = MarkerManager._internal();

  factory MarkerManager() {return _markerManager;}

  MarkerManager._internal();

  //********** Private **********

  //********** Public **********

  Set<Marker> getMarkers(){
    return _markers;
  }

  //TODO Fix marker duplication bug but setting marker id
  void setMarker(LatLng point) {
    // _markerIdCounter++;

    _markers.add(Marker(
      markerId: MarkerId('marker_Search'),//$_markerIdCounter'),
      position: point,
    ));
  }

  /* TODO Create setMarker() functions for the different types of markers
       i.e marker_Origin, marker_Destination, marker_Intermediate_1, etc.
  */

  void setPlaceMarker(Place place) {
    final double lat = place.geometry.location.lat;
    final double lng = place.geometry.location.lng;
    setMarker(LatLng(lat, lng));
  }

  //TODO Refactor to use setMarker to set the marker
  // Same as set marker with hardcoded ID and other variables
  void setUserMarker(Position point) {
    LatLng latlng = LatLng(point.latitude, point.longitude);
    _markers.add(Marker(
      markerId: const MarkerId('user'),
      position: latlng,
      rotation: point.heading,
      draggable: false,
      zIndex: 2,
      flat: true,
      anchor: const Offset(0.5, 0.5),
    ));
  }

  //TODO Refactor to use setMarker to set the marker
  Marker getStationMarker(Station station) {
    LatLng pos = LatLng(station.lat, station.long);
    Marker marker = Marker(
      markerId: MarkerId(station.name),
      infoWindow: InfoWindow(title: station.name),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      position: pos,
    );
    return marker;
  }



}