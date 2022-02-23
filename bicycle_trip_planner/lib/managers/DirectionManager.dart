import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/models/steps.dart';
import 'package:flutter/material.dart';

class DirectionManager{
  
  //********** Fields **********

  // TODO: Change these distance and duration to late when possible
  bool isCycling = false; 
  String duration = "No data";
  String distance = "No data";
  List<Steps> directions = <Steps>[];
  Steps currentDirection = Steps(instruction: "", distance: 0, duration: 0);

  //********** Singleton **********

  static final DirectionManager _directionManager = DirectionManager._internal(); 

  factory DirectionManager(){return _directionManager;} 

  DirectionManager._internal(); 

  //********** Private **********

  //********** Public *********

  void setDuration(int seconds) {
    int minutes = (seconds / 60).ceil();
    duration = "$minutes min";
  }

  void setDistance(int metre) {
    int km = (metre / 1000).ceil();
    distance = "$km km";
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
    return Icon(icon, color: buttonPrimaryColor, size: 60); 
  }

  // TODO: Keep until actual data is passed into Nav
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
  
  // TODO: Remove the first direction from the list and return it
  Steps popDirection() {
    directions.removeAt(0);
    return directions.first; 
  }

}