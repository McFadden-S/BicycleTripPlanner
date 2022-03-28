import 'package:bicycle_trip_planner/models/geometry.dart';
import 'package:bicycle_trip_planner/models/place.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bicycle_trip_planner/managers/CameraManager.dart';

import 'camera_manager_test.mocks.dart';

@GenerateMocks([GoogleMapController])
void main() {
  final controller = MockGoogleMapController();
  final cameraManager = CameraManager(googleMapController: controller);
  final style = r'''"featureType": "administrative"''';

  Map<String, dynamic> boundsSw = {};
  Map<String, dynamic> boundsNe = {};
  boundsSw["lat"] = 10.0;
  boundsSw["lng"] = 10.0;

  boundsNe["lat"] = 20.0;
  boundsNe["lng"] = 20.0;

  final place = Place(
      geometry: Geometry.geometryNotFound(),
      name: "name",
      placeId: "placeId",
      description: "description");

  test("Initialise google map controller", () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    cameraManager.init();
    await untilCalled(controller.setMapStyle(any));
    verify(controller.setMapStyle(captureThat(contains(style))));
  });

  test("Set camera bounds", () async {
    const sw = LatLng(10.0, 10.0);
    const ne = LatLng(20.0, 20.0);

    cameraManager.setCameraBounds(sw, ne);
    await untilCalled(controller.animateCamera(any));

   (verify(controller.animateCamera(captureAny)));

  });

  test("Set camera position", () async{
    cameraManager.setCameraPosition(const LatLng(20, 10));
    await untilCalled(controller.animateCamera(any));

    verify(controller.animateCamera(any));
  });

  test("Set route camera", () {
    cameraManager.setRouteCamera(const LatLng(10, 20), boundsSw, boundsNe);
    expect(cameraManager.getRouteOriginCamera(),LatLng(10.0, 20.0));
  });

  test("Go to place", () {
    cameraManager.goToPlace(10.0, 20.0, boundsNe, boundsSw);
  });

  test("View place", () {
    cameraManager.viewPlace(place);
  });

  test("View route", () {
    cameraManager.viewRoute();
  });

  test("View user", () {
    cameraManager.viewUser();
  });
}
