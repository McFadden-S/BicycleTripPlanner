import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test/test.dart';
import 'package:bicycle_trip_planner/managers/CameraManager.dart';
import 'package:bicycle_trip_planner/models/place.dart';
import 'package:bicycle_trip_planner/models/geometry.dart';
import 'package:bicycle_trip_planner/models/location.dart';
import 'package:bicycle_trip_planner/managers/LocationManager.dart';
import 'dart:async';
import 'package:flutter/material.dart';

void main(){
  final LocationManager locationManager = LocationManager();
  bool isInitPos = true;
  CameraManager? cameraManager;
  GoogleMap(
    initialCameraPosition: CameraManager.initialCameraPosition,
      onMapCreated: (controller) {
        cameraManager = CameraManager(
            googleMapController: controller,
            locationManager: locationManager
        );
        cameraManager?.init();
      },
      onCameraMove: (value) {
        isInitPos = false;
      },
  );


  // test('check if view place will move the camera position', (){
  //   Location location = Location(lat: 51.511448, lng: -0.116414);
  //   Geometry geometry = Geometry(location: location);
  //   Place place = Place(geometry: geometry, name: 'Bush House');
  //
  //   // double middleX = 100;
  //   // double middleY = 100;
  //   //
  //   // ScreenCoordinate screenCoordinate = ScreenCoordinate(x: middleX.round(), y: middleY.round());
  //   //
  //   // Future<LatLng>? initPos = cameraManager?.googleMapController.getLatLng(screenCoordinate);
  //   cameraManager?.viewPlace(place);
  //   // Future<LatLng>? finalPos = cameraManager?.googleMapController.getLatLng(screenCoordinate);
  //   expect(isInitPos, false);
  // });


}