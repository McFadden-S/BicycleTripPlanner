import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/models/place.dart';
import 'package:bicycle_trip_planner/models/station.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../widgets/home/Home.dart';

class MarkerManager {
  //********** Fields **********

  Widget home = Home();

  final Set<Marker> _markers = <Marker>{};

  final _mapMarkerSC = StreamController<Set<Marker>>.broadcast();
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

  /// @param -
  ///   station - Station; a station
  ///   appBloc - ApplicationBloc; the application bloc
  ///   markerID - String; unique marker id
  /// @return Marker - new marker with an id
  Marker _createStationMarker(Station station, ApplicationBloc appBloc,
      [String markerID = ""]) {
    if (markerID == "") {
      markerID = station.name;
    }

    return Marker(
      markerId: MarkerId(markerID),
      infoWindow: InfoWindow(title: station.name),
      icon:
          BitmapDescriptor.defaultMarkerWithHue(ThemeStyle.stationMarkerColor),
      position: LatLng(station.lat, station.lng),
      onTap: () async {
        appBloc.showSelectedStationDialog(station);
      },
    );
  }

  /// @param -
  ///   id - int; marker id
  ///   name - String; used as marker id if one isnt assigned
  /// @return String - markerID
  String _generateMarkerID(int id, [String name = ""]) {
    if (name != "") {
      return "Marker_$name";
    }
    return "Marker_$id";
  }

  /// @param - String; markerID in question
  /// @return bool - returns whether the marker exists
  bool _markerExists(String markerID) {
    MarkerId falseMarker = const MarkerId("false");
    Marker marker = _markers.firstWhere(
        (marker) => marker.markerId == MarkerId(markerID),
        orElse: () => Marker(markerId: falseMarker));
    return marker.markerId != falseMarker;
  }

  /// @param - String; markerID in question
  /// @return Marker - returns marker object from the markerID given
  Marker _getMarker(String markerID) {
    Marker marker = const Marker(markerId: MarkerId("false"));
    if (_markerExists(markerID)) {
      return _markers
          .firstWhere((marker) => marker.markerId == MarkerId(markerID));
    }
    return marker;
  }

  /// @param - String; markerID in question
  /// @affect - removes marker using markerID given
  void _removeMarker(String markerID) {
    if (_markerExists(markerID)) {
      _markers.remove(_markers
          .firstWhere((marker) => marker.markerId == MarkerId(markerID)));
    }
  }

  /// @param - double; radius of marker
  /// @affect - creates format of marker icon
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

  /// @param void
  /// @return Set<Marker> - returns set of markers and removes duplicates if any
  Set<Marker> getMarkers() {
    return _markers;
  }

  /// @param - String; markerID wanted to be removed
  /// @return void
  /// @affects - removes marker using markerID given
  void removeMarker(String markerID) {
    _removeMarker(markerID);
  }

  /// @param - int; UID of marker
  /// @return void
  /// @affects - removes marker using UID given
  void clearMarker(int uid) {
    _removeMarker(_generateMarkerID(uid));
  }

  /// @param -
  ///  place - Place; a place
  /// @return void
  /// @affects - sets a marker for a given place object
  void setPlaceMarker(Place place, [int uid = -1]) {
    final double lat = place.geometry.location.lat;
    final double lng = place.geometry.location.lng;
    setMarker(LatLng(lat, lng), _generateMarkerID(uid));
  }

  /// @param -
  ///  place - Station; a bike station
  ///  appBloc - ApplicationBloc; given application bloc
  /// @return void
  /// @affects - set a marker for a given station using UID
  void setStationMarkerWithUID(Station station, ApplicationBloc appBloc,
      [int uid = -1]) {
    if (station == Station.stationNotFound()) {
      return;
    }
    _markers
        .add(_createStationMarker(station, appBloc, _generateMarkerID(uid)));
  }

  /// @param - LatLng; a location point
  /// @return Future<Marker> - a Marker to be set for the user
  /// @affects - sets a special marker to identify the user
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

  /// @param -
  ///   station - Station; a station
  ///   appBloc - ApplictionBloc; the application bloc
  /// @return void
  /// @affects - sets a marker for a bike station
  void setStationMarker(Station station, ApplicationBloc appBloc) {
    if (_markerExists(station.name) || station == Station.stationNotFound()) {
      return;
    }

    _markers.add(_createStationMarker(station, appBloc));
  }

  /// @param -
  ///   stations - List<Station>; a list of bike stations
  ///   appBloc - ApplictionBloc; the application bloc
  /// @return void
  /// @affects - sets a marker for a list of bike stations
  void setStationMarkers(List<Station> stations, ApplicationBloc appBloc) {
    for (var station in stations) {
      setStationMarker(station, appBloc);
    }
  }

  /// @param - List<Station>; a list of bike stations
  /// @return void
  /// @affects - removes station markers from a given list of stations
  void clearStationMarkers(List<Station> stations) {
    for (var station in stations) {
      _removeMarker(station.name);
    }
  }
}
