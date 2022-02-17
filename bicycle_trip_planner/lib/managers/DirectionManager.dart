import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/models/steps.dart';
import 'package:flutter/material.dart';

class DirectionManager{
  
  bool isCycling = false; 
  List<Steps> directions = <Steps>[];

  // TODO: DirectManager should take/obtain directions/steps
  DirectionManager();

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
    return directions.first; 
  }

}