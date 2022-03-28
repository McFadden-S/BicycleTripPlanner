import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:test/test.dart';
import 'package:bicycle_trip_planner/managers/CameraManager.dart';
import 'package:bicycle_trip_planner/models/place.dart';
import 'package:bicycle_trip_planner/managers/LocationManager.dart';
import 'dart:async';
import 'package:flutter/material.dart';



@GenerateMocks([GoogleMapController])
void main(){
  final LocationManager locationManager = LocationManager();
  bool isInitPos = true;
  //final controller = MockGoogleMapController();
  //var cameraManager = CameraManager.forMock(controller);

  // GoogleMap(
  //   initialCameraPosition: CameraManager.initialCameraPosition,
  //     onMapCreated: (controller) {
  //       cameraManager = CameraManager(
  //           googleMapController: controller,
  //           locationManager: locationManager
  //       );
  //       cameraManager?.init();
  //     },
  //     onCameraMove: (value) {
  //       isInitPos = false;
  //     },
  // );


  // test('check if view place will move the camera position', (){
  //   Location location = Location(lat: 51.511448, lng: -0.116414);
  //   Geometry geometry = Geometry(location: location);
  //   Place place = Place(geometry: geometry, name: 'Bush House', description: '', placeId: '');
  //
  //   cameraManager.init();
  //
  // });


}