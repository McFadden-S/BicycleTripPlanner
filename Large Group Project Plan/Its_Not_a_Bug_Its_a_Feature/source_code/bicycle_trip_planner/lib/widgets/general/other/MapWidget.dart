import 'dart:async';

import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/managers/CameraManager.dart';
import 'package:bicycle_trip_planner/managers/LocationManager.dart';
import 'package:bicycle_trip_planner/managers/MarkerManager.dart';
import 'package:bicycle_trip_planner/managers/PolylineManager.dart';
import 'package:bicycle_trip_planner/managers/StationManager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({Key? key}) : super(key: key);

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> with TickerProviderStateMixin {
  //********** Providers **********

  late StreamSubscription locatorSubscription;

  //********** Markers **********

  final MarkerManager markerManager = MarkerManager();
  late final Set<Marker> _markers = markerManager.getMarkers();

  //********** Polylines **********

  final PolylineManager polylineManager = PolylineManager();
  late final Set<Polyline> _polylines = polylineManager.getPolyLines();

  //********** Camera **********

  CameraManager? cameraManager;

  //********** User Position **********

  final LocationManager locationManager = LocationManager();

  //********** Stations ***********

  final StationManager stationManager = StationManager();

  //********** Widget **********

  @override
  void initState() {
    super.initState();

    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);

    applicationBloc.setupStations();

    // Initialise the marker with his current position
    locationManager.locate().then((pos) => setState(() {
          markerManager.setUserMarker(pos);
        }));

    locatorSubscription = locationManager
        .onUserLocationChange()
        .listen((LocationData currentLocation) {
      setState(() {
        markerManager.setUserMarker(
            LatLng(currentLocation.latitude!, currentLocation.longitude!));
      });
    });

    // Get the initial update for the markers
    applicationBloc.updateStations();
  }

  @override
  void dispose() {
    try {
      final applicationBloc =
          Provider.of<ApplicationBloc>(context, listen: false);
      applicationBloc.cancelStationTimer();
    } catch (e) {}
    ;

    if (cameraManager != null) {
      cameraManager?.dispose();
    }
    locatorSubscription.cancel();

    super.dispose();
  }

  @override
  void setState(fn) {
    try {
      super.setState(fn);
    } catch (e) {}
    ;
  }

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);
    if (defaultTargetPlatform == TargetPlatform.android) {
      AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
    }
    final googleMap = StreamBuilder<Set<Marker>>(
        stream: markerManager.mapMarkerStream,
        builder: (context, snapshot) {
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
              });
        });

    return Scaffold(
      body: Stack(
        children: [
          googleMap,
        ],
      ),
    );
  }
}
