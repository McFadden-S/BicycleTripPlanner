import 'package:bicycle_trip_planner/constants.dart';
import 'package:flutter/material.dart';

class NavigationManager{

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

}