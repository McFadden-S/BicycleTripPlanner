import 'package:bicycle_trip_planner/managers/MarkerManager.dart';
import 'package:bicycle_trip_planner/models/place.dart';
import 'package:bicycle_trip_planner/managers/LocationManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../constants.dart';
import 'TimeManager.dart';

/// Class Comment:
/// CameraManager is a manager class that holds the data and functions for
/// the Camera position and display on the Map

class CameraManager {

  //********** Fields **********

  static const initialCameraPosition = CameraPosition(
    target: LatLng(51.509865, -0.118092),
    zoom: 12.5,
  );

  late GoogleMapController googleMapController;
  final LocationManager locationManager = LocationManager();
  MarkerManager markerManager = MarkerManager();
  bool locationViewed = false;

  //The fields hold the info required to view the route
  late LatLng _routeOriginCamera;
  late LatLng _routeBoundsSW;
  late LatLng _routeBoundsNE;

  //********** Singleton **********

  static final CameraManager _cameraManager = CameraManager._internal();
  static CameraManager get instance => _cameraManager;

  factory CameraManager({required GoogleMapController googleMapController}) {
    _cameraManager.googleMapController = googleMapController;
    return _cameraManager;
  }

  CameraManager._internal();

  CameraManager.forMock(MarkerManager manager, GoogleMapController controller){
    markerManager = manager;
    googleMapController = controller;
  }
  //********** Setup/Teardown **********

  void init() {
    rootBundle.loadString(ThemeStyle.mapStyle).then((style) {
      googleMapController.setMapStyle(style);
    });

  }

  void dispose() {
    googleMapController.dispose();
  }

  //********** Private **********



  ///Sets the bounds of the map's camera
  @visibleForTesting
  void setCameraBounds(LatLng southwest, LatLng northeast) {
    googleMapController.animateCamera(
      CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: southwest,
            northeast: northeast,
          ),
          25),
    );
  }

  //********** Public **********

  ///Sets the position of the camera on the map
  void setCameraPosition(LatLng position, {double zoomIn = 16}) {
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(
        target: position,
        zoom: zoomIn,
      )),
    );
  }

  /// Sets the necessary fields to allow the camera to view the route
  /// Does Not Change Camera Position
  void setRouteCamera(LatLng origin, Map<String, dynamic> boundsSw,
      Map<String, dynamic> boundsNe) {
    _routeBoundsNE = LatLng(boundsNe['lat'], boundsNe['lng']);
    _routeBoundsSW = LatLng(boundsSw['lat'], boundsSw['lng']);
    _routeOriginCamera = origin;
  }

  /// @return routeOriginCamera
  @visibleForTesting
  getRouteOriginCamera(){
    return _routeOriginCamera;
  }

  /// Views the route to a location
  Future<void> goToPlace(LatLng latLng, Map<String, dynamic> boundsNe,
      Map<String, dynamic> boundsSw) async {
    setRouteCamera(latLng, boundsSw, boundsNe);
    viewRoute();
  }

  /// Views a Place on the Map
  Future<void> viewPlace(Place place) async {
    setCameraPosition(place.latlng);
  }

  /// Views the Route
  /// Set the route via setRouteCamera
  Future<void> viewRoute() async {
    setCameraPosition(_routeOriginCamera);
    setCameraBounds(_routeBoundsSW, _routeBoundsNE);
  }

  /// Sets the camera to the user's location
  void viewUser({double zoomIn = 16}) {
    setCameraPosition(markerManager.getUserMarker().position, zoomIn: zoomIn);
  }

  /// sets the boolean flag to true when the user clicks the location button
  void userLocated() {
    locationViewed = true;
  }

  /// returns whether or not locationViewed is true
  bool isLocated() {
    return locationViewed;
  }
}
