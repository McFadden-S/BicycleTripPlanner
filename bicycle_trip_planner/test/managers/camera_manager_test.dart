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

  Map<String, dynamic> boundsSw = {};
  Map<String, dynamic> boundsNe = {};
  final place = Place(
      geometry: Geometry.geometryNotFound(),
      name: "name",
      placeId: "placeId",
      description: "description");

  test("Initialise google map controller", () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    cameraManager.init();
    await untilCalled(controller.setMapStyle(any));
    verify(controller.setMapStyle(captureAny));
  });

  test("Set camera bounds", () async {
    const sw = LatLng(10.0, 10.0);
    const ne = LatLng(20.0, 20.0);

    cameraManager.setCameraBounds(sw, ne);
    untilCalled(controller.animateCamera(any));

    verify(controller.animateCamera(captureAny)).captured.single.toString();
  });

  test("Set camera position", () {
    cameraManager.setCameraPosition(const LatLng(20, 10));
  });

  test("Set route camera", () {
    cameraManager.setRouteCamera(const LatLng(10, 20), boundsSw, boundsNe);
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
//   final LocationManager locationManager = LocationManager();
//   bool isInitPos = true;
//   CameraManager? cameraManager;
//   GoogleMap(
//     initialCameraPosition: CameraManager.initialCameraPosition,
//       onMapCreated: (controller) {
//         cameraManager = CameraManager(
//             googleMapController: controller,
//             locationManager: locationManager
//         );
//         cameraManager?.init();
//       },
//       onCameraMove: (value) {
//         isInitPos = false;
//       },
//   );

  // test('check if view place will move the camera position', (){
  //   Location location = Location(lat: 51.511448, lng: -0.116414);
  //   Geometry geometry = Geometry(location: location);
  //   Place place = Place(geometry: geometry, name: 'Bush House');
  //
  //   // double middleX = 100;
  //   // double middleY = 100;
  //   //
  //   // ScreenCoordinate screenCoordinate = ScreenCoordinate(x: middleX.round(), y: middleY.round());
  //   //
  //   // Future<LatLng>? initPos = cameraManager?.googleMapController.getLatLng(screenCoordinate);
  //   cameraManager?.viewPlace(place);
  //   // Future<LatLng>? finalPos = cameraManager?.googleMapController.getLatLng(screenCoordinate);
  //   expect(isInitPos, false);
  // });
}
