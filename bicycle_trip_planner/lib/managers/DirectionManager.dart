import 'dart:async';

import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/managers/CameraManager.dart';
import 'package:bicycle_trip_planner/managers/PolylineManager.dart';
import 'package:bicycle_trip_planner/models/steps.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_trip_planner/models/route.dart' as R;

class DirectionManager {
  //********** Fields **********

  final CameraManager _cameraManager = CameraManager.instance;
  final PolylineManager _polylineManager = PolylineManager();

  R.Route _startWalkingRoute = R.Route.routeNotFound();
  R.Route _bikingRoute = R.Route.routeNotFound();
  R.Route _endWalkingRoute = R.Route.routeNotFound();

  bool _isCycling = false;
  bool _isNavigating = false;

  String _duration = "No data";
  String _distance = "No data";

  List<Steps> _directions = <Steps>[];

  Steps _currentDirection = Steps.stepsNotFound();

  //********** Singleton **********

  static final DirectionManager _directionManager =
      DirectionManager._internal();

  factory DirectionManager() {
    return _directionManager;
  }

  DirectionManager._internal();

  //********** Private **********

  //********** Public **********

  Steps popDirection() {
    _directions.removeAt(0);
    return _directions.first;
  }

  void showStartRoute([relocateMap = true]) {
    setCurrentRoute(_startWalkingRoute, relocateMap);
    _isCycling = false;
  }

  void showBikeRoute([relocateMap = true]) {
    setCurrentRoute(_bikingRoute, relocateMap);
    _isCycling = true;
  }

  void showEndRoute([relocateMap = true]) {
    setCurrentRoute(_endWalkingRoute, relocateMap);
    _isCycling = false;
  }

  void showCombinedRoute([relocateMap = true]){
    _polylineManager.clearPolyline();
    _polylineManager.addWalkingPolyline(_startWalkingRoute.polyline.points);
    _polylineManager.addBikingPolyline(_bikingRoute.polyline.points);
    _polylineManager.addWalkingPolyline(_endWalkingRoute.polyline.points);

    int duration = 0;
    int distance = 0;

    _startWalkingRoute.legs.forEach((leg) { duration += leg.duration; distance += leg.distance;});
    _bikingRoute.legs.forEach((leg) { duration += leg.duration; distance += leg.distance;});
    _endWalkingRoute.legs.forEach((leg) { duration += leg.duration; distance += leg.distance;});

    setDuration(duration);
    setDistance(distance);

    if (relocateMap) {
      _cameraManager.goToPlace(
          _bikingRoute.legs.first.startLocation.lat,
          _bikingRoute.legs.first.startLocation.lng,
          _bikingRoute.bounds.northeast,
          _bikingRoute.bounds.southwest);
    }
  }

  //********** Getting **********

  String getDuration() {
    return _duration;
  }

  String getDistance() {
    return _distance;
  }

  bool ifRouteSet() {
    return _startWalkingRoute != R.Route.routeNotFound() &&
        _endWalkingRoute != R.Route.routeNotFound() &&
        _bikingRoute != R.Route.routeNotFound();
  }

  bool ifNavigating() {
    return _isNavigating;
  }

  bool ifCycling() {
    return _isCycling;
  }

  Steps getDirection(int index) {
    if (index >= 0 && index <= _directions.length && _directions.isNotEmpty) {
      return _directions[index];
    }
    return Steps.stepsNotFound();
  }

  List<Steps> getDirections() {
    return _directions;
  }

  int getNumberOfDirections() {
    return _directions.length;
  }

  Steps getCurrentDirection() {
    return _currentDirection;
  }

  bool ifDirections() {
    return _directions.isNotEmpty;
  }

  Icon directionIcon(String direction) {
    late IconData icon;
    direction.toLowerCase().contains('left')
        ? icon = Icons.arrow_back
        : direction.toLowerCase().contains('right')
            ? icon = Icons.arrow_forward
            : direction.toLowerCase().contains('straight')
                ? icon = Icons.arrow_upward
                : direction.toLowerCase().contains('continue')
                    ? icon = Icons.arrow_upward
                    : direction.toLowerCase().contains('head')
                        ? icon = Icons.arrow_upward
                        : direction.toLowerCase().contains('roundabout')
                            ? icon = Icons.data_usage_outlined
                            : icon = Icons.circle;
    return Icon(icon, color: ThemeStyle.buttonPrimaryColor, size: 60);
  }

  //TODO: Useful for testing. Should no longer be here
  List<Steps> createDummyDirections() {
    List<Steps> steps = [];
    steps.add(Steps(instruction: "Turn right", distance: 50, duration: 16));
    steps.add(Steps(instruction: "Turn left", distance: 150, duration: 16));
    steps.add(Steps(instruction: "Roundabout", distance: 150, duration: 16));
    steps.add(
        Steps(instruction: "Continue straight", distance: 250, duration: 16));
    steps.add(Steps(instruction: "Turn left", distance: 150, duration: 16));
    return steps;
  }

  //********** Setting **********

  void setDuration(int seconds) {
    int minutes = (seconds / 60).ceil();
    _duration = "$minutes min";
  }

  void setDistance(int metre) {
    int miles = (metre / 1609.34).ceil();
    _distance = "$miles mi";
  }

  //TODO: Temporary fix, should be refactored
  void setNavigating(bool isNavigating) {
    _isNavigating = isNavigating;
  }

  void setRoutes(R.Route startWalk, R.Route bike, R.Route endWalk,
      [relocateMap = true]) {
    _startWalkingRoute = startWalk;
    _bikingRoute = bike;
    _endWalkingRoute = endWalk;

    if (_isNavigating) {
      if (_startWalkingRoute != R.Route.routeNotFound()) {
        showStartRoute(relocateMap);
      } else if (_bikingRoute != R.Route.routeNotFound()) {
        showBikeRoute(relocateMap);
      } else {
        showEndRoute(relocateMap);
      }
    } else {
      showCombinedRoute(relocateMap);
    }
  }

<<<<<<< HEAD
  void setCurrentRoute(R.Route route, [relocateMap = true]) {
=======
  int getRouteDuration(R.Route route){
    int duration = 0;
    for(var i =0; i < route.legs.length; i++){
      duration += route.legs[i].duration;
    }

    return duration;
  }

  void setCurrentRoute(R.Route route){

>>>>>>> 4367a46 (Add findCostEfficientRoute method to applicationBloc)
    int duration = 0;
    int distance = 0;
    _directions.clear();

    for (var i = 0; i < route.legs.length; i++) {
      _directions += route.legs[i].steps;
      duration += route.legs[i].duration;
      distance += route.legs[i].distance;
    }

    _currentDirection = _directions.isNotEmpty
        ? _directions.removeAt(0)
        : Steps.stepsNotFound();

    setDuration(duration);
    setDistance(distance);

    if (relocateMap) {
      _cameraManager.goToPlace(
          route.legs.first.startLocation.lat,
          route.legs.first.startLocation.lng,
          route.bounds.northeast,
          route.bounds.southwest);
    }

    Color polylineColor = Colors.red;

    if(route != _bikingRoute){
      polylineColor = Colors.grey;
    }

    _polylineManager.setPolyline(route.polyline.points, polylineColor);
  }

  void toggleCycling() {
    _isCycling = !_isCycling;

    if (_isCycling) {
      showBikeRoute();
    } else {
      if (_startWalkingRoute != R.Route.routeNotFound()) {
        showStartRoute();
      } else if (_endWalkingRoute != R.Route.routeNotFound()) {
        showEndRoute();
      }
    }
  }

  //********** Clearing **********

  void clear() {
    _polylineManager.clearPolyline();

    clearDuration();
    clearDistance();
    clearCurrentDirection();
    clearDirections();

    clearRoutes();

    _isNavigating = false;
  }

  void clearDuration() {
    _duration = "No data";
  }

  void clearDistance() {
    _distance = "No data";
  }

  void clearDirections() {
    _directions.clear();
  }

  void clearCurrentDirection() {
    _currentDirection = Steps.stepsNotFound();
  }

  void clearRoutes() {
    _startWalkingRoute = R.Route.routeNotFound();
    _bikingRoute = R.Route.routeNotFound();
    _endWalkingRoute = R.Route.routeNotFound();
  }
}
