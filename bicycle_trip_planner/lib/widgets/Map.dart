import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/models/place.dart';
import 'package:bicycle_trip_planner/models/steps.dart';
import 'package:provider/provider.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({Key? key}) : super(key: key);

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {

  //********** Providers **********

  late StreamSubscription locationSubscription;
  late StreamSubscription directionSubscription;

  //********** Camera **********

  late GoogleMapController _googleMapController;

  late LatLng routeOriginCamera;
  late LatLng routeBoundsSW;
  late LatLng routeBoundsNE;

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(37.773972, -122.431297),
    zoom: 12.5,
  );

  void _setCameraPosition(LatLng position){
    _googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(
        target: position,
        zoom: 14.0,
      )),
    );
  }

  void _setCameraBounds(LatLng southwest, LatLng northeast){
    _googleMapController.animateCamera(
      CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: southwest,
            northeast: northeast,
          ),
          25),
    );
  }

  void _setRouteCamera(LatLng origin, Map<String, dynamic> boundsSw,
      Map<String, dynamic> boundsNe) {
    routeBoundsNE = LatLng(boundsNe['lat'], boundsNe['lng']);
    routeBoundsSW = LatLng(boundsSw['lat'], boundsSw['lng']);
    routeOriginCamera = origin;
  }

  Future<void> _goToPlace(double lat, double lng, Map<String, dynamic> boundsNe,
      Map<String, dynamic> boundsSw) async {
    _setRouteCamera(LatLng(lat, lng), boundsSw, boundsNe);
    viewRoute();

    _setMarker(LatLng(lat, lng));
  }

  Future<void> viewPlace(Place place) async {
    final double lat = place.geometry.location.lat;
    final double lng = place.geometry.location.lng;

    _setCameraPosition(LatLng(lat, lng));
    _setMarker(LatLng(lat, lng));
  }

  Future<void> viewRoute() async {
    _setCameraPosition(routeOriginCamera);
    _setCameraBounds(routeBoundsSW, routeBoundsNE);
  }

  //********** Markers **********

  final Set<Marker> _markers = <Marker>{};
  int _markerIdCounter = 1;
  final String _finalDestinationMarkerID = "Final Destination";
  final String _originMarkerID = "Origin";

  void _setMarker(LatLng point) {
    _markerIdCounter++;

    _markers.add(Marker(
      markerId: MarkerId('marker_$_markerIdCounter'),
      position: point,
    ));
  }

  //********** Polylines **********

  final Set<Polyline> _polylines = <Polyline>{};
  int _polylineIdCounter = 1;

  void _setPolyline(List<PointLatLng> points) {
    final String polylineIdVal = 'polyline_$_polylineIdCounter';
    _polylineIdCounter++;
    _polylines.clear();

    _polylines.add(Polyline(
      polylineId: PolylineId(polylineIdVal),
      width: 2,
      color: Colors.blue,
      points: points
          .map(
            (point) => LatLng(point.latitude, point.longitude),
      )
          .toList(),
    ));
  }

  //********** Widget **********

  @override
  void initState() {
    super.initState();

    final applicationBloc = Provider.of<ApplicationBloc>(context, listen: false);

    locationSubscription =
        applicationBloc.selectedLocation.stream.listen((place) {
          viewPlace(place);
        });

    directionSubscription =
        applicationBloc.currentDirection.stream.listen((direction) {
          _goToPlace(
              direction.legs.startLocation.lat,
              direction.legs.startLocation.lng,
              direction.bounds.northeast,
              direction.bounds.southwest);
          _setPolyline(direction.polyline.points);
        });

  }

  @override
  void dispose() {
    _googleMapController.dispose();

    final applicationBloc = Provider.of<ApplicationBloc>(context, listen: false);
    applicationBloc.dispose();

    locationSubscription.cancel();
    directionSubscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      markers: _markers,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      initialCameraPosition: _initialCameraPosition,
      onMapCreated: (controller) => _googleMapController = controller,
    );
  }

  //********** Accessors **********


}
