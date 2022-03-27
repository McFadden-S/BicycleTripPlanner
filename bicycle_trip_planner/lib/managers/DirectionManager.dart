import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/managers/LocationManager.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/models/distance_types.dart';
import 'package:bicycle_trip_planner/models/steps.dart';
import 'package:flutter/material.dart';

class DirectionManager {
  //********** Fields **********

  final LocationManager _locationManager = LocationManager();

  int _durationValue = 0;

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

  int getDurationValue() {
    return _durationValue;
  }

  String getDuration() {
    return _duration;
  }

  String getDistance() {
    return _distance;
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

  //********** Setting **********

  void setDuration(int seconds) {
    int minutes = (seconds / 60).ceil();
    _durationValue = minutes;
    _duration = "$minutes min";
  }

  void setDistance(double metre) {
    DistanceType units = _locationManager.getUnits();
    int distance = units.convert(metre).ceil();
    _distance = "$distance ${units.units}";
  }

  void setDirections(List<Steps> directions) {
    _directions = directions;
    _currentDirection =
        directions.isNotEmpty ? directions.removeAt(0) : Steps.stepsNotFound();
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
