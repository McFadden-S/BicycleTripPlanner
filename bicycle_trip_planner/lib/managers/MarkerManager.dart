import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/managers/CameraManager.dart';
import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/models/place.dart';
import 'package:bicycle_trip_planner/models/station.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vector_math/vector_math.dart' as vector;

class MarkerManager{

  //********** Fields **********

  final Set<Marker> _markers = <Marker>{};

  Animation<double>? _animation;
  final _mapMarkerSC = StreamController<Set<Marker>>.broadcast();
  int _markerIdCounter = 1;
  final String _startMarkerID = "Start";
  final String _finalDestinationMarkerID = "Final Destination";
  BitmapDescriptor? userMarkerIcon; 

  //********** Singleton **********

  static final MarkerManager _markerManager = MarkerManager._internal();

  factory MarkerManager() {return _markerManager;}

  MarkerManager._internal();

  //********** Private **********

  StreamSink<Set<Marker>> get _mapMarkerSink => _mapMarkerSC.sink;

  Stream<Set<Marker>> get mapMarkerStream => _mapMarkerSC.stream;

  String _generateMarkerID(int id, [String name = ""]){
    if(name != ""){return "Marker_$name";}
    return "Marker_$id"; 
  }

  bool _markerExists(String markerID){
    MarkerId falseMarker = const MarkerId("false");
    Marker marker = _markers.firstWhere((marker) =>
      marker.markerId == MarkerId(markerID), orElse: () => Marker(markerId: falseMarker));
    return marker.markerId != falseMarker;
  }

  void _removeMarker(String markerID){
    if(_markerExists(markerID)){
      _markers.remove(_markers.firstWhere((marker) =>
      marker.markerId == MarkerId(markerID)));
    }
  }

  Future<void> _initUserMarkerIcon(double radius) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Colors.blue;
    canvas.drawCircle(Offset(radius, radius), radius, paint);
    int diamater = (radius * 2).ceil();  
    final img = await pictureRecorder.endRecording().toImage(diamater, diamater);
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

  Set<Marker> getMarkers(){
    return _markers;
  }

  void removeMarker(String markerID){
    _removeMarker(markerID); 
  }

  void clearMarker(int uid){
    _removeMarker(_generateMarkerID(uid));
  }

  void setPlaceMarker(Place place, [int uid = -1]) {
    final double lat = place.geometry.location.lat;
    final double lng = place.geometry.location.lng;
    setMarker(LatLng(lat, lng), _generateMarkerID(uid));
  }


  Future<Marker> setUserMarker(LatLng point) async {
    // Wait for this to load
    if(userMarkerIcon == null){await _initUserMarkerIcon(25);} 

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

  animateMarker(
    // double fromLat, //Starting latitude
    // double fromLong, //Starting longitude
    double toLat, //Ending latitude
    double toLong, //Ending longitude
    TickerProvider
        provider, //Ticker provider of the widget. This is used for animation
  ) async {
    Position? position = await Geolocator.getLastKnownPosition();
    double fromLat = position!.latitude;
    double fromLong = position!.longitude;
    final double bearing =
    getBearing(LatLng(fromLat, fromLong), LatLng(toLat, toLong));

    _markers.clear();

    Marker userMarker = await setUserMarker(LatLng(fromLat, fromLong));
    //Adding initial marker to the start location.
    _mapMarkerSink.add(_markers);

    final animationController = AnimationController(
      duration: const Duration(seconds: 10), //Animation duration of marker
      vsync: provider, //From the widget
    );

    print(animationController); 

    Tween<double> tween = Tween(begin: 0, end: 1);

    print(tween); 

    _animation = tween.animate(animationController)
      ..addListener(() async {
        //We are calculating new latitude and logitude for our marker
        final v = _animation!.value;
        double lng = v * toLong + (1 - v) * fromLong;
        double lat = v * toLat + (1 - v) * fromLat;
        LatLng newPos = LatLng(lat, lng);

        //Removing old marker if present in the marker array
        if (_markers.contains(userMarker)) _markers.remove(userMarker);

        //New marker location
      userMarker = await setUserMarker(newPos);

        //Adding new marker to our list and updating the google map UI.
        _markers.add(userMarker);
        _mapMarkerSink.add(_markers);

        // TODO: HERE TO TEST
        CameraManager.instance.setCameraPosition(newPos);
      });

    //Starting the animation
    animationController.forward();
  }

  double getBearing(LatLng begin, LatLng end) {
    double lat = (begin.latitude - end.latitude).abs();
    double lng = (begin.longitude - end.longitude).abs();

    if (begin.latitude < end.latitude && begin.longitude < end.longitude) {
      return vector.degrees(atan(lng / lat));
    } else if (begin.latitude >= end.latitude &&
        begin.longitude < end.longitude) {
      return (90 - vector.degrees(atan(lng / lat))) + 90;
    } else if (begin.latitude >= end.latitude &&
        begin.longitude >= end.longitude) {
      return vector.degrees(atan(lng / lat)) + 180;
    } else if (begin.latitude < end.latitude &&
        begin.longitude >= end.longitude) {
      return (90 - vector.degrees(atan(lng / lat))) + 270;
    }
    return -1;
  }

  void setStationMarkers(List<Station> stations, ApplicationBloc appBloc){
    for(var station in stations){
      LatLng pos = LatLng(station.lat, station.lng);
      _markers.add(Marker(
        markerId: MarkerId(station.name),
        infoWindow: InfoWindow(title: station.name),
        icon: BitmapDescriptor.defaultMarkerWithHue(ThemeStyle.stationMarkerColor),
        position: pos,
        onTap: (){
          appBloc.searchSelectedStation(station);
          appBloc.setSelectedScreen('routePlanning');
          },
      ));
    }
  }
}