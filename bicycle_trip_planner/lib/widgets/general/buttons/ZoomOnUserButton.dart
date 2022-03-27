import 'dart:async';

import 'package:bicycle_trip_planner/managers/CameraManager.dart';
import 'package:bicycle_trip_planner/widgets/general/buttons/CircleButton.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../../../managers/LocationManager.dart';

class ZoomOnUserButton extends StatefulWidget {
  const ZoomOnUserButton({
    Key? key,
  }) : super(key: key);

  @override
  _ZoomOnUserButtonState createState() => _ZoomOnUserButtonState();
}

class _ZoomOnUserButtonState extends State<ZoomOnUserButton> {
  final LocationManager locationManager = LocationManager();
  final CameraManager cameraManager = CameraManager.instance;
  late StreamSubscription<LocationData> navigationSubscription;
  bool focusOnUser = true;

  @override
  void initState() {
    super.initState();
    zoomOnUser();
  }

  @override
  Widget build(BuildContext context) {
    return CircleButton(
        iconIn: focusOnUser ? Icons.zoom_out_map : Icons.zoom_in_map,
        onButtonClicked: () => toggleZoom());
  }

  toggleZoom() {
    setState(() {
      focusOnUser = !focusOnUser;
    });

    if (focusOnUser) {
      zoomOnUser();
    } else {
      navigationSubscription.cancel();
      cameraManager.viewRoute();
    }
  }

  void zoomOnUser() {
    navigationSubscription = locationManager
        .onUserLocationChange(5)
        .listen((LocationData currentLocation) {
      cameraManager.viewUser(zoomIn: 20.0);
    });
  }
}
