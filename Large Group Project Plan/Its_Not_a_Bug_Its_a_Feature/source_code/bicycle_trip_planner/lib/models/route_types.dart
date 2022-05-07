import 'package:flutter/material.dart';

enum RouteType {
  none,
  walk,
  bike,
}

extension RouteTypeExtension on RouteType {
  /// method returns the mode of travel as a string based on enum specified
  /// @return String mode of travel
  String get mode {
    switch (this) {
      case RouteType.none:
        return "";
      case RouteType.walk:
        return "walking";
      case RouteType.bike:
        return "bicycling";
    }
  }

  /// method returns a polyline color depending on the enum RouteType specified
  /// @return Color polyline color
  Color get polylineColor {
    switch (this) {
      case RouteType.walk:
        return Colors.lightBlue;
      case RouteType.bike:
        return Colors.red;
      default:
        return Colors.transparent;
    }
  }
}
