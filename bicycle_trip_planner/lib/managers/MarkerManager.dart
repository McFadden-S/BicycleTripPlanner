import 'dart:ui';

import 'package:bicycle_trip_planner/models/place.dart';
import 'package:bicycle_trip_planner/models/station.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerManager {

  //********** Fields **********

  final Set<Marker> _markers = <Marker>{};

  int _markerIdCounter = 1;
  final String _startMarkerID = "Start";
  final String _finalDestinationMarkerID = "Final Destination";

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
    _markerIdCounter++;

    _markers.add(Marker(
      markerId: MarkerId('marker_$_markerIdCounter'),
      position: point,
    ));
  }

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

  void setStationMarkers(List<Station> stations){
    for(var station in stations){
      LatLng pos = LatLng(station.lat, station.lng);
      _markers.add(Marker(
        markerId: MarkerId(station.name),
        infoWindow: InfoWindow(title: station.name),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: pos,
      ));
    }
  }

}