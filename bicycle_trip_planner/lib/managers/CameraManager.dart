import 'package:bicycle_trip_planner/models/place.dart';
import 'package:bicycle_trip_planner/managers/LocationManager.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CameraManager{

  static const initialCameraPosition = CameraPosition(
    target: LatLng(37.773972, -122.431297),
    zoom: 12.5,
  );

  late GoogleMapController googleMapController;
  final LocationManager locationManager;

  late LatLng _routeOriginCamera;
  late LatLng _routeBoundsSW;
  late LatLng _routeBoundsNE;

  CameraManager({
    required this.googleMapController,
    required this.locationManager,
  });

  //********** Setup/Teardown **********

  void init(){
    rootBundle.loadString('assets/map_style.txt').then((style) {
      googleMapController.setMapStyle(style);
    });
  }

  void dispose(){
    googleMapController.dispose();
  }

  //********** Private **********

  void _setCameraPosition(LatLng position){
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(
        target: position,
        zoom: 14.0,
      )),
    );
  }

  void _setCameraBounds(LatLng southwest, LatLng northeast){
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

  void setRouteCamera(LatLng origin, Map<String, dynamic> boundsSw,
      Map<String, dynamic> boundsNe) {
    _routeBoundsNE = LatLng(boundsNe['lat'], boundsNe['lng']);
    _routeBoundsSW = LatLng(boundsSw['lat'], boundsSw['lng']);
    _routeOriginCamera = origin;
  }

  Future<void> goToPlace(double lat, double lng, Map<String, dynamic> boundsNe,
      Map<String, dynamic> boundsSw) async {
    setRouteCamera(LatLng(lat, lng), boundsSw, boundsNe);
    viewRoute();
  }

  Future<void> viewPlace(Place place) async {
    final double lat = place.geometry.location.lat;
    final double lng = place.geometry.location.lng;

    _setCameraPosition(LatLng(lat, lng));
  }

  Future<void> viewRoute() async {
    _setCameraPosition(_routeOriginCamera);
    _setCameraBounds(_routeBoundsSW, _routeBoundsNE);
  }

  // Sets the camera to the user's location
  Future<void> viewUser() async {
    LatLng userLocation = await locationManager.locate();
    _setCameraPosition(userLocation);
  }

}