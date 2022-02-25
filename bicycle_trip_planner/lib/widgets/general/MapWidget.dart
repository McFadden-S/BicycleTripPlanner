import 'dart:async';

import 'package:bicycle_trip_planner/managers/StationManager.dart';
import 'package:bicycle_trip_planner/managers/LocationManager.dart';
import 'package:bicycle_trip_planner/managers/MarkerManager.dart';
import 'package:bicycle_trip_planner/managers/PolylineManager.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:provider/provider.dart';

import 'package:bicycle_trip_planner/managers/CameraManager.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({Key? key}) : super(key: key);

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {

  //********** Providers **********

  late StreamSubscription locationSubscription;
  late StreamSubscription directionSubscription;
  late StreamSubscription locatorSubscription;
  late StreamSubscription curLocationSubscription;

  //********** Markers **********

  final MarkerManager markerManager = MarkerManager();
  late final Set<Marker> _markers = markerManager.getMarkers();

  //********** Polylines **********

  final PolylineManager polylineManager = PolylineManager();
  late final Set<Polyline> _polylines = polylineManager.getPolyLines();

  //********** Camera **********

  // TODO: CHANGE THIS BACK WHEN POSSIBLE
  // WAS TEMPORARILY REVERTED TO ALLOW TESTS TO PASS
  CameraManager? cameraManager; 

  //********** User Position **********

  final LocationManager locationManager = LocationManager();

  //********** Stations ***********

  final StationManager stationManager = StationManager();

  //********** Widget **********

  @override
  void initState() {
    super.initState();

    // Requires permission for the locator to work
    LocationPermission perm;
    locationManager.requestPermission().then((permission) => perm = permission);

    final applicationBloc = Provider.of<ApplicationBloc>(context, listen: false);

    locationSubscription =
        applicationBloc.selectedLocation.stream.listen((place) {
          setState(() {
            cameraManager?.viewPlace(place);
          });
        });

    directionSubscription =
        applicationBloc.currentRoute.stream.listen((direction) {
          setState(() {
            cameraManager?.goToPlace(
                direction.legs.startLocation.lat,
                direction.legs.startLocation.lng,
                direction.bounds.northeast,
                direction.bounds.southwest);
            polylineManager.setPolyline(direction.polyline.points);
          });
        });

    applicationBloc.setupStations();

    // Initialise the marker with his current position
    locationManager.locate().then((pos) => setState((){
      markerManager.setUserMarker(pos);
    }));

    locatorSubscription =
        Geolocator.getPositionStream(locationSettings: locationManager.locationSettings())
            .listen((Position position) {
            setState(() {
              markerManager.setUserMarker(LatLng(position.latitude, position.longitude));
            });
        });

    // Get the initial update for the markers
    applicationBloc.updateStations();

    //Use a periodic timer to update the TFL Santander bike stations 
    //(Once every 30 seconds) 
    applicationBloc.updateStationsPeriodically(const Duration(seconds: 30)); 
  }

  @override
  void dispose() {
    try{
      final applicationBloc = Provider.of<ApplicationBloc>(context, listen: false);
      applicationBloc.cancelStationTimer();
    }
    catch(e){}; 

    if(cameraManager != null) {cameraManager?.dispose();} 
    locationSubscription.cancel();
    directionSubscription.cancel();
    locatorSubscription.cancel();

    super.dispose();
  }

  @override
  void setState(fn) {
    try {
      super.setState(fn);
    } catch (e) {};
  }

  @override
  Widget build(BuildContext context) {

    final applicationBloc = Provider.of<ApplicationBloc>(context);

    return GoogleMap(
      mapType: MapType.normal,
      markers: _markers,
      polylines: _polylines,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      initialCameraPosition: CameraManager.initialCameraPosition,
      onMapCreated: (controller) {
        cameraManager = CameraManager(
            googleMapController: controller,
        );
        cameraManager?.init();
      }
    );
  }

}
