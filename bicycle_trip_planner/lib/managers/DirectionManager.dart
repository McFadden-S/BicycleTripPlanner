import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/models/steps.dart';
import 'package:flutter/material.dart';

class DirectionManager {
  //********** Fields **********

  bool _isCycling = false;

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

  //********** Getting **********

  String getDuration() {
    return _duration;
  }

  String getDistance() {
    return _distance;
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

  void setDirections(List<Steps> directions) {
    _directions = directions;
    _currentDirection =
        directions.isNotEmpty ? directions.removeAt(0) : Steps.stepsNotFound();
  }

  void toggleCycling() {
    _isCycling = !_isCycling;
    print("Toggle cycling called");
    if (_isCycling) {
      print("Showing bike route...");
      RouteManager();
    } else {
      RouteManager().showCurrentWalkingRoute();
    }
  }

  //********** Clearing **********

  void clear() {
    clearDuration();
    clearDistance();
    clearCurrentDirection();
    clearDirections();
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
}
