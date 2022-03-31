import 'package:bicycle_trip_planner/managers/MarkerManager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:bicycle_trip_planner/managers/CameraManager.dart';
import 'package:bicycle_trip_planner/models/place.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bicycle_trip_planner/managers/CameraManager.dart';

import 'camera_manager_test.mocks.dart';

@GenerateMocks([GoogleMapController, MarkerManager])
void main() {
  final controller = MockGoogleMapController();
  final markerManager = MockMarkerManager();
  final cameraManager = CameraManager.forMock(markerManager, controller);
  final style = r'''"featureType": "administrative"''';

  Map<String, dynamic> boundsSw = {};
  Map<String, dynamic> boundsNe = {};
  boundsSw["lat"] = 10.0;
  boundsSw["lng"] = 10.0;

  boundsNe["lat"] = 20.0;
  boundsNe["lng"] = 20.0;



  final place = Place(
      latlng: LatLng(10.0,10.0),
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

   verify(controller.animateCamera(captureAny));

  });

  test("Set camera position", () async{
    cameraManager.setCameraPosition(const LatLng(20, 10));
    await untilCalled(controller.animateCamera(any));
    verify(controller.animateCamera(any));
  });

  test("Set route camera",(){
    cameraManager.setRouteCamera(place.latlng, boundsSw, boundsNe);
    expect(cameraManager.getRouteOriginCamera(), LatLng(10.0, 10.0));
  });

  test("Go to place",(){
    cameraManager.goToPlace(place.latlng, boundsNe, boundsSw);
    expect(cameraManager.getRouteOriginCamera(), LatLng(10.0, 10.0));
  });

  test("View place",() async {
    cameraManager.viewPlace(place);

    await untilCalled(controller.animateCamera(any));
    verify(controller.animateCamera(any));
  });

  test("View route",() async {
    cameraManager.viewRoute();

    await untilCalled(controller.animateCamera(any));
    verify(controller.animateCamera(any));
  });

  test("View user",() async {
    when(markerManager.getUserMarker()).thenAnswer((realInvocation) => Marker(markerId: MarkerId("id"), position: LatLng(20.0,30.0)));
    cameraManager.viewUser();

    await untilCalled(controller.animateCamera(any));
    verify(controller.animateCamera(any));
    cameraManager.dispose();
  });

}