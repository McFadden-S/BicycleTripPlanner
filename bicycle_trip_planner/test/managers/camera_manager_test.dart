import 'package:bicycle_trip_planner/models/geometry.dart';
import 'package:bicycle_trip_planner/models/place.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bicycle_trip_planner/managers/CameraManager.dart';

import 'camera_manager_test.mocks.dart';

@GenerateMocks([GoogleMapController])
void main(){
  final controller = MockGoogleMapController();
  final cameraManager = CameraManager(googleMapController: controller);

  final style = """[
    {
        "featureType": "administrative",
        "elementType": "labels.text.fill",
        "stylers": [
            {
                "color": "#444444"
            }
        ]
    },
    {
        "featureType": "administrative.locality",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#6c3131"
            }
        ]
    },
    {
        "featureType": "administrative.locality",
        "elementType": "labels.text.fill",
        "stylers": [
            {
                "saturation": "-1"
            },
            {
                "lightness": "47"
            },
            {
                "color": "#0b0303"
            },
            {
                "visibility": "on"
            },
            {
                "weight": "0.33"
            },
            {
                "gamma": "0.00"
            }
        ]
    },
    {
        "featureType": "landscape",
        "elementType": "all",
        "stylers": [
            {
                "color": "#f2f2f2"
            }
        ]
    },
    {
        "featureType": "landscape.man_made",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#d6d6d6"
            }
        ]
    },
    {
        "featureType": "landscape.man_made",
        "elementType": "labels.text.fill",
        "stylers": [
            {
                "color": "#4d1010"
            }
        ]
    },
    {
        "featureType": "landscape.natural.landcover",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#cacaca"
            }
        ]
    },
    {
        "featureType": "landscape.natural.terrain",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#3c2403"
            }
        ]
    },
    {
        "featureType": "poi",
        "elementType": "all",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "poi.attraction",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "visibility": "on"
            },
            {
                "color": "#c72020"
            }
        ]
    },
    {
        "featureType": "poi.park",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#6fc46b"
            },
            {
                "visibility": "on"
            }
        ]
    },
    {
        "featureType": "poi.park",
        "elementType": "labels.text.fill",
        "stylers": [
            {
                "visibility": "on"
            },
            {
                "color": "#4d9c3c"
            }
        ]
    },
    {
        "featureType": "road",
        "elementType": "all",
        "stylers": [
            {
                "saturation": -100
            },
            {
                "lightness": 45
            }
        ]
    },
    {
        "featureType": "road.highway",
        "elementType": "all",
        "stylers": [
            {
                "visibility": "simplified"
            },
            {
                "color": "#ffffff"
            }
        ]
    },
    {
        "featureType": "road.highway",
        "elementType": "labels.text.fill",
        "stylers": [
            {
                "visibility": "off"
            },
            {
                "color": "#c5acac"
            }
        ]
    },
    {
        "featureType": "road.arterial",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#f2f2f2"
            }
        ]
    },
    {
        "featureType": "road.arterial",
        "elementType": "labels.text.fill",
        "stylers": [
            {
                "color": "#b0b0b0"
            }
        ]
    },
    {
        "featureType": "road.arterial",
        "elementType": "labels.icon",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "road.local",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#bdbdbd"
            }
        ]
    },
    {
        "featureType": "road.local",
        "elementType": "labels.text.fill",
        "stylers": [
            {
                "color": "#b2b2b2"
            }
        ]
    },
    {
        "featureType": "transit",
        "elementType": "all",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "water",
        "elementType": "all",
        "stylers": [
            {
                "color": "#456b99"
            },
            {
                "visibility": "on"
            }
        ]
    },
    {
        "featureType": "water",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#5c8cd4"
            }
        ]
    },
    {
        "featureType": "water",
        "elementType": "labels.text.fill",
        "stylers": [
            {
                "color": "#0e2951"
            }
        ]
    }
]
 """;

  Map<String, dynamic> boundsSw ={};
  Map<String, dynamic> boundsNe ={};
  final place = Place(geometry: Geometry.geometryNotFound(), name: "name", placeId: "placeId", description: "description");

  test("Initialise google map controller",() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    cameraManager.init();
    await untilCalled(controller.setMapStyle(style));
    verify(controller.setMapStyle(style));
  });

  test("Set camera bounds",() async {
    const sw = LatLng(10, 10);
    const ne =  LatLng(20, 20);

    cameraManager.setCameraBounds(sw,ne);
    print("hi");
    await untilCalled(controller.animateCamera(
      CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: sw,
            northeast: ne,
          ),
          25),
    ));

    print("hi2");
    verify(controller.animateCamera(
      CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest:sw,
            northeast:ne,
          ),
          25),
      )
    );
  });

  test("Set camera position",(){
    cameraManager.setCameraPosition(const LatLng(20,10));
  });

  test("Set route camera",(){

    cameraManager.setRouteCamera(const LatLng(10,20), boundsSw, boundsNe);
  });

  test("Go to place",(){
    cameraManager.goToPlace(10.0, 20.0, boundsNe, boundsSw);
  });

  test("View place",(){
    cameraManager.viewPlace(place);
  });

  test("View route",(){
    cameraManager.viewRoute();
  });

  test("View user",(){
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