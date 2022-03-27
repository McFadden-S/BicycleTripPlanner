import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/managers/LocationManager.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/models/distance_types.dart';
import 'package:bicycle_trip_planner/models/steps.dart';
import 'package:flutter/material.dart';

/// Class Comment:
/// DirectionManager is a manager class that manages the directions for a planned
/// route and is used in the display of navigation

class DirectionManager {

  //********** Fields **********

  final LocationManager _locationManager = LocationManager();

  //holds duration in seconds
  int _duration = 0;

  //Holds the distance in Metres
  double _distance = 0;

  List<Steps> _directions = <Steps>[];

  Steps _currentDirection = Steps.stepsNotFound();

  //********** Singleton **********

  /// Holds the singleton instance
  static final DirectionManager _directionManager =
      DirectionManager._internal();

  /// Singleton Constructor Override
  factory DirectionManager() {
    return _directionManager;
  }

  DirectionManager._internal();

  //********** Private **********

  //********** Public **********

  /// Removes and Returns the first direction
  Steps popDirection() {
    _directions.removeAt(0);
    return _directions.first;
  }

  //********** Getting **********

  /// Returns Direction Duration in Minutes as an Int
  int getDurationValue() {
    return (_duration / 60).ceil();
  }

  /// Returns Direction Duration in Minutes as formatted text
  String getDuration() {
    int minutes = (_duration / 60).ceil();
    return "$minutes min";
  }

  /// Returns Direction Distance in the set Unit
  String getDistance() {
    DistanceType units = _locationManager.getUnits();
    int distance = units.convert(_distance).ceil();
    return "$distance ${units.units}";
  }

  /// @param - index the index of direction
  /// @return - Steps object of the direction looked for or Steps not found if invalid index
  /// @effects - none
  Steps getDirection(int index) {
    if (index >= 0 && index <= _directions.length && _directions.isNotEmpty) {
      return _directions[index];
    }
    return Steps.stepsNotFound();
  }

  /// Returns list of Steps as the direction
  List<Steps> getDirections() {
    return _directions;
  }

  /// Returns Int number of directions stored
  int getNumberOfDirections() {
    return _directions.length;
  }

  ///Returns the current displayed direction
  Steps getCurrentDirection() {
    return _currentDirection;
  }

  /// Returns true if there are directions
  bool ifDirections() {
    return _directions.isNotEmpty;
  }

  /// Returns Icon for a direction string based on its text
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

  /// Sets the durations in seconds
  void setDuration(int seconds) {
    _duration = seconds;
  }

  /// Sets the distance in metres
  void setDistance(double metre) {
    _distance = metre;
  }

  /// Sets the directions and sets the first direction as the current direction
  void setDirections(List<Steps> directions) {
    _directions = directions;
    _currentDirection =
        directions.isNotEmpty ? directions.removeAt(0) : Steps.stepsNotFound();
  }

  //********** Clearing **********

  /// Clears all direction information to default information
  void clear() {
    clearDuration();
    clearDistance();
    clearCurrentDirection();
    clearDirections();
  }

  /// Sets Duration to default value
  void clearDuration() {
    _duration = 0;
  }

  /// Sets Distance to default value
  void clearDistance() {
    _distance = 0;
  }

  /// Clears Stored Directions
  void clearDirections() {
    _directions.clear();
  }

  /// Sets Current Direction to default value
  void clearCurrentDirection() {
    _currentDirection = Steps.stepsNotFound();
  }
}
