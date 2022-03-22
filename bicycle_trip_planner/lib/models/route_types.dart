import 'package:flutter/material.dart';

enum RouteType {
  none,
  walk,
  bike,
}

extension RouteTypeExtension on RouteType {
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
