import 'dart:async';

import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/managers/CameraManager.dart';
import 'package:bicycle_trip_planner/managers/PolylineManager.dart';
import 'package:bicycle_trip_planner/models/steps.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_trip_planner/models/route.dart' as R;

class DirectionManager{

  //********** Fields **********

  final CameraManager _cameraManager = CameraManager.instance;
  final PolylineManager _polylineManager = PolylineManager();

  R.Route _startWalkingRoute = R.Route.routeNotFound();
  R.Route _bikingRoute = R.Route.routeNotFound();
  R.Route _endWalkingRoute = R.Route.routeNotFound();

  bool _isCycling = false;

  String _duration = "No data";
  String _distance = "No data";

  List<Steps> _directions = <Steps>[];

  Steps _currentDirection = Steps.stepsNotFound();

  //********** Singleton **********

  static final DirectionManager _directionManager = DirectionManager._internal();

  factory DirectionManager(){return _directionManager;}

  DirectionManager._internal();

  //********** Private **********

  //********** Public **********

  Steps popDirection() {
    _directions.removeAt(0);
    return _directions.first;
  }

  void showStartRoute(){
    setCurrentRoute(_startWalkingRoute);
    _isCycling = false;
  }

  void showBikeRoute(){
    setCurrentRoute(_bikingRoute);
    _isCycling = true;
  }

  void showEndRoute(){
    setCurrentRoute(_endWalkingRoute);
    _isCycling = false;
  }

  //********** Getting **********

  String getDuration(){
    return _duration;
  }

  String getDistance(){
    return _distance;
  }

  bool ifCycling(){
    return _isCycling;
  }

  Steps getDirection(int index){
    if(index >= 0 && index <= _directions.length && _directions.isNotEmpty){
      return _directions[index];
    }
    return Steps.stepsNotFound();
  }

  List<Steps> getDirections(){
    return _directions;
  }

  int getNumberOfDirections(){
    return _directions.length;
  }

  Steps getCurrentDirection(){
    return _currentDirection;
  }

  bool ifDirections(){
    return _directions.isNotEmpty;
  }

  Icon directionIcon(String direction) {
    late IconData icon;
    direction.toLowerCase().contains('left') ? icon = Icons.arrow_back :
    direction.toLowerCase().contains('right') ? icon = Icons.arrow_forward :
    direction.toLowerCase().contains('straight') ? icon = Icons.arrow_upward :
    direction.toLowerCase().contains('continue') ? icon = Icons.arrow_upward :
    direction.toLowerCase().contains('head') ? icon = Icons.arrow_upward :
    direction.toLowerCase().contains('roundabout') ? icon = Icons.data_usage_outlined:
    icon = Icons.circle;
    return Icon(icon, color: ThemeStyle.buttonPrimaryColor, size: 60);
  }

  List<Steps> createDummyDirections() {
    List<Steps> steps = [];
    steps.add(Steps(
        instruction: "Turn right", distance: 50, duration: 16));
    steps.add(Steps(
        instruction: "Turn left", distance: 150, duration: 16));
    steps.add(Steps(
        instruction: "Roundabout", distance: 150, duration: 16));
    steps.add(Steps(
        instruction: "Continue straight", distance: 250, duration: 16));
    steps.add(Steps(
        instruction: "Turn left", distance: 150, duration: 16));
    return steps;
  }

  //********** Setting **********

  void setDuration(int seconds) {
    int minutes = (seconds / 60).ceil();
    _duration = "$minutes min";
  }

  void setDistance(int metre) {
    int km = (metre / 1000).ceil();
    _distance = "$km km";
  }

  void setRoutes(R.Route startWalk, R.Route bike, R.Route endWalk){
    _startWalkingRoute = startWalk;
    _bikingRoute = bike;
    _endWalkingRoute = endWalk;

    //Set as biking route to show general route user will take
    showBikeRoute();
  }

  void setCurrentRoute(R.Route route){

    int duration = 0;
    int distance = 0;
    _directions.clear();

    for(var i =0; i < route.legs.length; i++){
      _directions += route.legs[i].steps;
      duration += route.legs[i].duration;
      distance += route.legs[i].distance;
    }

    _currentDirection = _directions.removeAt(0);

    setDuration(duration);
    setDistance(distance);

    _cameraManager.goToPlace(
        route.legs.first.startLocation.lat,
        route.legs.first.startLocation.lng,
        route.bounds.northeast,
        route.bounds.southwest);

    _polylineManager.setPolyline(route.polyline.points);
  }

  void toggleCycling() {
    _isCycling = !_isCycling;

    if(_isCycling){
      showBikeRoute();
    }else {
      //TODO handle whether to display start or end walking route
     showEndRoute();
    }

  }

  //********** Clearing **********

  void clear(){
    _polylineManager.clearPolyline();

    clearDuration();
    clearDistance();
    clearCurrentDirection();
    clearDirections();

    clearRoutes();
  }

  void clearDuration(){
    _duration = "No data";
  }

  void clearDistance(){
    _distance = "No data";
  }

  void clearDirections(){
    _directions.clear();
  }

  void clearCurrentDirection(){
    _currentDirection = Steps.stepsNotFound();
  }

  void clearRoutes(){
    _startWalkingRoute = R.Route.routeNotFound();
    _bikingRoute = R.Route.routeNotFound();
    _endWalkingRoute = R.Route.routeNotFound();
  }

}
