import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/models/place.dart';
import 'package:bicycle_trip_planner/models/station.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerManager {
  //********** Fields **********

  final Set<Marker> _markers = <Marker>{};

  final _mapMarkerSC = StreamController<Set<Marker>>.broadcast();
  int _markerIdCounter = 1;
  final String _startMarkerID = "Start";
  final String _finalDestinationMarkerID = "Final Destination";
  BitmapDescriptor? userMarkerIcon;

  //********** Singleton **********

  static final MarkerManager _markerManager = MarkerManager._internal();

  factory MarkerManager() {
    return _markerManager;
  }

  MarkerManager._internal();

  //********** Private **********

  StreamSink<Set<Marker>> get _mapMarkerSink => _mapMarkerSC.sink;

  Stream<Set<Marker>> get mapMarkerStream => _mapMarkerSC.stream;

  String _generateMarkerID(int id, [String name = ""]) {
    if (name != "") {
      return "Marker_$name";
    }
    return "Marker_$id";
  }

  bool _markerExists(String markerID) {
    MarkerId falseMarker = const MarkerId("false");
    Marker marker = _markers.firstWhere(
        (marker) => marker.markerId == MarkerId(markerID),
        orElse: () => Marker(markerId: falseMarker));
    return marker.markerId != falseMarker;
  }

  Marker _getMarker(String markerID) {
    Marker marker = const Marker(markerId: MarkerId("false"));
    if (_markerExists(markerID)) {
      return _markers
          .firstWhere((marker) => marker.markerId == MarkerId(markerID));
    }
    return marker;
  }

  void _removeMarker(String markerID) {
    if (_markerExists(markerID)) {
      _markers.remove(_markers
          .firstWhere((marker) => marker.markerId == MarkerId(markerID)));
    }
  }

  Future<void> _initUserMarkerIcon(double radius) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Colors.blue;
    canvas.drawCircle(Offset(radius, radius), radius, paint);
    int diamater = (radius * 2).ceil();
    final img =
        await pictureRecorder.endRecording().toImage(diamater, diamater);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List markerIcon = data!.buffer.asUint8List();
    userMarkerIcon = BitmapDescriptor.fromBytes(markerIcon);
  }

  @visibleForTesting
  void setMarker(LatLng point, String markerID) {
    //Removes marker before re-adding it, avoids issue of re-setting marker to previous location
    _removeMarker(markerID);

    _markers.add(Marker(
      markerId: MarkerId(markerID),
      position: point,
    ));
  }

  //********** Public **********

  Set<Marker> getMarkers() {
    return _markers;
  }

  void removeMarker(String markerID) {
    _removeMarker(markerID);
  }

  void clearMarker(int uid) {
    _removeMarker(_generateMarkerID(uid));
  }

  void setPlaceMarker(Place place, [int uid = -1]) {
    final double lat = place.geometry.location.lat;
    final double lng = place.geometry.location.lng;
    setMarker(LatLng(lat, lng), _generateMarkerID(uid));
  }

  Future<Marker> setUserMarker(LatLng point) async {
    // Wait for this to load
    if (userMarkerIcon == null) {
      await _initUserMarkerIcon(25);
    }

    String userID = 'user';

    _removeMarker(userID);

    Marker userMarker = Marker(
      icon: userMarkerIcon!,
      markerId: MarkerId(userID),
      position: point,
      draggable: false,
      zIndex: 2,
      flat: true,
      anchor: const Offset(0.5, 0.5),
    );
    _markers.add(userMarker);
    return userMarker;
  }

  void setStationMarkers(List<Station> stations, ApplicationBloc appBloc) {
    for (var station in stations) {
      LatLng pos = LatLng(station.lat, station.lng);
      _markers.add(Marker(
        markerId: MarkerId(station.name),
        infoWindow: InfoWindow(title: station.name),
        icon: BitmapDescriptor.defaultMarkerWithHue(
            ThemeStyle.stationMarkerColor),
        position: pos,
        onTap: () {
          appBloc.searchSelectedStation(station);
          appBloc.setSelectedScreen('routePlanning');
        },
      ));
    }
  }

  void clearStationMarkers(List<Station> stations) {
    for (var station in stations) {
      _removeMarker(station.name);
    }
  }

  void hideStationMarkers(List<Station> stations) {
    for (var station in stations) {
      Marker marker = _getMarker(station.name).copyWith(visibleParam: false);
      if (marker.markerId != const MarkerId("false")) _markers.add(marker);
    }
  }

  void showStationMarkers(List<Station> stations) {
    for (var station in stations) {
      Marker marker = _getMarker(station.name).copyWith(visibleParam: true);
      if (marker.markerId != const MarkerId("false")) _markers.add(marker);
    }
  }
}
