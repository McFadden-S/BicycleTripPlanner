import 'package:flutter/material.dart';

enum RouteType {
  none,
  walk,
  bike,
}

extension RouteTypeExtension on RouteType {

  /**
   * method returns a polyline color depending on the enum RouteType specified
   * @return Color polyline color
   */
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
