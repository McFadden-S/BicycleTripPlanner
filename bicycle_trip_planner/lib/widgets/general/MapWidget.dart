import 'dart:async';

import 'package:bicycle_trip_planner/models/station.dart';
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

  late final applicationBloc;

  //********** Providers **********

  late StreamSubscription locationSubscription;
  late StreamSubscription directionSubscription;
  late StreamSubscription locatorSubscription;
  late StreamSubscription stationSubscription;

  //********** Markers **********

  final Set<Marker> _markers = <Marker>{};

  late MarkerManager markerManager = MarkerManager(markers: _markers);

  //********** Polylines **********

  final Set<Polyline> _polylines = <Polyline>{};

  late PolylineManager polylineManager = PolylineManager(polylines: _polylines);

  //********** Camera **********

  late CameraManager cameraManager;

  //********** User Position **********

  final LocationManager locationManager = LocationManager();

  //********** Widget **********

  @override
  void initState() {
    super.initState();

    // Requires permission for the locator to work
    LocationPermission perm;
    locationManager.requestPermission().then((permission) => perm = permission);

    applicationBloc = Provider.of<ApplicationBloc>(context, listen: false);

    locationSubscription =
        applicationBloc.selectedLocation.stream.listen((place) {
          setState(() {
            cameraManager.viewPlace(place);
            markerManager.setPlaceMarker(place);
          });
        });

    directionSubscription =
        applicationBloc.currentRoute.stream.listen((direction) {
          setState(() {
            cameraManager.goToPlace(
                direction.legs.startLocation.lat,
                direction.legs.startLocation.lng,
                direction.bounds.northeast,
                direction.bounds.southwest);
            polylineManager.setPolyline(direction.polyline.points);
          });
        });

    stationSubscription =
        applicationBloc.allStations.stream.listen((stations){
          setState((){
            for(Station station in stations){
                _markers.add(markerManager.getStationMarker(station));
            }
          });
        });

    locatorSubscription =
        Geolocator.getPositionStream(locationSettings: locationManager.locationSettings)
            .listen((Position position) {
          setState(() {
            markerManager.setUserMarker(position);
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
      applicationBloc.cancelStationTimer();
    }
    catch(e){}; 

    cameraManager.dispose();
    locationSubscription.cancel();
    directionSubscription.cancel();
    locatorSubscription.cancel(); 
    stationSubscription.cancel();

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
            locationManager: locationManager
        );
        cameraManager.init();
      }
    );
  }

}
