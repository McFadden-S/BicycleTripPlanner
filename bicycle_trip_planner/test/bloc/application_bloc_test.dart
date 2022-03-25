import 'package:bicycle_trip_planner/managers/StationManager.dart';
import 'package:bicycle_trip_planner/models/geometry.dart';
import 'package:bicycle_trip_planner/models/location.dart';
import 'package:bicycle_trip_planner/models/place.dart';
import 'package:bicycle_trip_planner/models/search_types.dart';
import 'package:bicycle_trip_planner/models/station.dart';
import 'package:bicycle_trip_planner/widgets/general/other/Search.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:bicycle_trip_planner/services/places_service.dart';

import 'package:mockito/annotations.dart';
import 'package:bicycle_trip_planner/managers/LocationManager.dart';
import 'package:mockito/mockito.dart';
import 'application_bloc_test.mocks.dart';

import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/managers/DialogManager.dart';
import 'package:flutter_test/flutter_test.dart';

@GenerateMocks([LocationManager, PlacesService])
void main() {

  test("Fetch location", () async {
    var locationManager = MockLocationManager();
    var locationManagerReal = LocationManager();
    var placesServices = MockPlacesService();
    var currentLocationLatLng = LatLng(50.526523, -0.4151);
    var currentPlace = Place(
        geometry: Geometry(
            location: Location(
                lat: currentLocationLatLng.latitude,
                lng: currentLocationLatLng.longitude)),
        name: "currentLocation",
        placeId: "placeId",
        description: SearchType.current.description);

    when(locationManager.locate())
        .thenAnswer((_) async => currentLocationLatLng);

    when(placesServices.getPlaceFromCoordinates(currentLocationLatLng.latitude,
        currentLocationLatLng.longitude, SearchType.current.description))
        .thenAnswer((_) async => currentPlace);

    var appBloc = ApplicationBloc.forMock(locationManager, placesServices);

    await untilCalled(locationManager.setCurrentLocation(currentPlace));
    verify(locationManager.setCurrentLocation(currentPlace)).called(1);
  });
//
//   group("Dialogue tests", () {
//     test("Is the dialog showing", () {
//       DialogManager manager = DialogManager();
//       expect(manager.ifShowingBinaryChoice(), false);
//
//       final appBloc = MockApplicationBloc();
//       appBloc.showBinaryDialog(manager);
//       expect(manager.ifShowingBinaryChoice(), true);
//
//       appBloc.clearBinaryDialog(manager);
//       expect(manager.ifShowingBinaryChoice(), false);
//     });
//
//     test("Is showing selected station", () {
//       DialogManager dialogManager = DialogManager();
//       expect(dialogManager.ifShowingSelectStation(), false);
//       expect(dialogManager.getSelectedStation().place,
//           const Place.placeNotFound());
//
//       final appBloc = MockApplicationBloc();
//       final station = Station(
//           id: 1,
//           name: "station",
//           lat: 0,
//           lng: 0,
//           bikes: 10,
//           emptyDocks: 0,
//           totalDocks: 10,
//           distanceTo: 10,
//           place: const Place.placeNotFound());
//
//       appBloc.showSelectedStationDialog(station, dialogManager);
//       expect(dialogManager.ifShowingSelectStation(), true);
//       expect(dialogManager.getSelectedStation().id, 1);
//
//       appBloc.clearSelectedStationDialog(dialogManager);
//       expect(dialogManager.getSelectedStation().place,
//           const Place.placeNotFound());
//     });
//   });
//
//   group("Search tests", () {
//     test("If search result", () async {
//       final appBloc = MockApplicationBloc();
//       expect(appBloc.ifSearchResult(), false);
//
//       final client = MockClient();
//
//       const key = 'AIzaSyBcUJrLd8uIYR2HFTNa6mj-7lVRyUIJXs0';
//       const search = "waterloo";
//
//       when(client.get(Uri.parse(
//               'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&components=country:gb&location=51.495830%2C-0.145607&radius=35000&strictbounds=true&key=$key')))
//           .thenAnswer((_) async => http.Response("""
//                       {
//    "predictions" : [
//       {
//          "description" : "Waterloo Station, London, UK",
//          "matched_substrings" : [
//             {
//                "length" : 8,
//                "offset" : 0
//             }
//          ],
//          "place_id" : "ChIJHVKfwLkEdkgRyojcJB0Aejk",
//          "reference" : "ChIJHVKfwLkEdkgRyojcJB0Aejk",
//          "structured_formatting" : {
//             "main_text" : "Waterloo Station",
//             "main_text_matched_substrings" : [
//                {
//                   "length" : 8,
//                   "offset" : 0
//                }
//             ],
//             "secondary_text" : "London, UK"
//          },
//          "terms" : [
//             {
//                "offset" : 0,
//                "value" : "Waterloo Station"
//             },
//             {
//                "offset" : 18,
//                "value" : "London"
//             },
//             {
//                "offset" : 26,
//                "value" : "UK"
//             }
//          ],
//          "types" : [ "premise", "geocode" ]
//       },
//       {
//          "description" : "Waterloo Station, Waterloo Road, London, UK",
//          "matched_substrings" : [
//             {
//                "length" : 8,
//                "offset" : 0
//             }
//          ],
//          "place_id" : "ChIJHVKfwLkEdkgRugNQexmYBR0",
//          "reference" : "ChIJHVKfwLkEdkgRugNQexmYBR0",
//          "structured_formatting" : {
//             "main_text" : "Waterloo Station",
//             "main_text_matched_substrings" : [
//                {
//                   "length" : 8,
//                   "offset" : 0
//                }
//             ],
//             "secondary_text" : "Waterloo Road, London, UK"
//          },
//          "terms" : [
//             {
//                "offset" : 0,
//                "value" : "Waterloo Station"
//             },
//             {
//                "offset" : 18,
//                "value" : "Waterloo Road"
//             },
//             {
//                "offset" : 33,
//                "value" : "London"
//             },
//             {
//                "offset" : 41,
//                "value" : "UK"
//             }
//          ],
//          "types" : [
//             "train_station",
//             "transit_station",
//             "point_of_interest",
//             "establishment"
//          ]
//       },
//       {
//          "description" : "Waterloo, London, UK",
//          "matched_substrings" : [
//             {
//                "length" : 8,
//                "offset" : 0
//             }
//          ],
//          "place_id" : "ChIJMQDcTLgEdkgRsvTavMaFESY",
//          "reference" : "ChIJMQDcTLgEdkgRsvTavMaFESY",
//          "structured_formatting" : {
//             "main_text" : "Waterloo",
//             "main_text_matched_substrings" : [
//                {
//                   "length" : 8,
//                   "offset" : 0
//                }
//             ],
//             "secondary_text" : "London, UK"
//          },
//          "terms" : [
//             {
//                "offset" : 0,
//                "value" : "Waterloo"
//             },
//             {
//                "offset" : 10,
//                "value" : "London"
//             },
//             {
//                "offset" : 18,
//                "value" : "UK"
//             }
//          ],
//          "types" : [ "sublocality_level_1", "sublocality", "political", "geocode" ]
//       },
//       {
//          "description" : "Waterloo Station, York Road, London, UK",
//          "matched_substrings" : [
//             {
//                "length" : 8,
//                "offset" : 0
//             }
//          ],
//          "place_id" : "ChIJ7610ozIFdkgRPmlBq4XXP3Q",
//          "reference" : "ChIJ7610ozIFdkgRPmlBq4XXP3Q",
//          "structured_formatting" : {
//             "main_text" : "Waterloo Station",
//             "main_text_matched_substrings" : [
//                {
//                   "length" : 8,
//                   "offset" : 0
//                }
//             ],
//             "secondary_text" : "York Road, London, UK"
//          },
//          "terms" : [
//             {
//                "offset" : 0,
//                "value" : "Waterloo Station"
//             },
//             {
//                "offset" : 18,
//                "value" : "York Road"
//             },
//             {
//                "offset" : 29,
//                "value" : "London"
//             },
//             {
//                "offset" : 37,
//                "value" : "UK"
//             }
//          ],
//          "types" : [ "point_of_interest", "establishment" ]
//       },
//       {
//          "description" : "Waterloo Road, South Bank, London, UK",
//          "matched_substrings" : [
//             {
//                "length" : 8,
//                "offset" : 0
//             }
//          ],
//          "place_id" : "EiVXYXRlcmxvbyBSb2FkLCBTb3V0aCBCYW5rLCBMb25kb24sIFVLIi4qLAoUChIJM2CpN7oEdkgRU_bO_OaBff4SFAoSCT8nlUy2BHZIEVhi1ra5_xcJ",
//          "reference" : "EiVXYXRlcmxvbyBSb2FkLCBTb3V0aCBCYW5rLCBMb25kb24sIFVLIi4qLAoUChIJM2CpN7oEdkgRU_bO_OaBff4SFAoSCT8nlUy2BHZIEVhi1ra5_xcJ",
//          "structured_formatting" : {
//             "main_text" : "Waterloo Road",
//             "main_text_matched_substrings" : [
//                {
//                   "length" : 8,
//                   "offset" : 0
//                }
//             ],
//             "secondary_text" : "South Bank, London, UK"
//          },
//          "terms" : [
//             {
//                "offset" : 0,
//                "value" : "Waterloo Road"
//             },
//             {
//                "offset" : 15,
//                "value" : "South Bank"
//             },
//             {
//                "offset" : 27,
//                "value" : "London"
//             },
//             {
//                "offset" : 35,
//                "value" : "UK"
//             }
//          ],
//          "types" : [ "route", "geocode" ]
//       }
//    ],
//    "status" : "OK"
// }
//                     """, 200));
//       final placesService = PlacesService();
//       final x = await placesService.getAutocomplete(search, client);
//
//       expect(x.first.description, "Waterloo Station, London, UK");
//     });
//   });
//
//   group("Navigation tests", () {
//     test("Start navigation", () {
//
//
//
//     });
//
//     test("Is waypoints passed", () {
//       final appBloc = MockApplicationBloc();
//
//       LatLng waypoint = const LatLng(51.511589, -0.118960);
//       LatLng currentLocation = const LatLng(51.5118, -0.118960);
//       final locationManager = LocationManager();
//
//       expect(
//           appBloc.isWaypointPassed(waypoint, currentLocation, locationManager),
//           true);
//     });

  //  Future<void> startNavigation() async {
  //   await fetchCurrentLocation();
  //   setSelectedScreen('navigation');
  //   await _navigationManager.start();
  //   _updateDirections();
  //   updateLocationLive();
  //   _routeManager.showCurrentRoute();
  //   Wakelock.enable();
  //   notifyListeners();
  // }

  // _updateDirections() async {
  //   // End subscription if not navigating?
  //   if (!_navigationManager.ifNavigating()) return;

  //   await fetchCurrentLocation();
  //   if (await _navigationManager.checkWaypointPassed()) {
  //     endRoute();
  //     return;
  //   }

  //   if (_routeManager.ifWalkToFirstWaypoint() &&
  //       _routeManager.ifFirstWaypointSet()) {
  //     await _navigationManager.updateRouteWithWalking();
  //     setPartialRoutes(
  //         [_routeManager.getFirstWaypoint().getStop().placeId],
  //         _routeManager
  //             .getWaypoints()
  //             .sublist(1)
  //             .map((waypoint) => waypoint.getStop().placeId)
  //             .toList());
  //   } else {
  //     await _navigationManager.updateRoute();
  //     setPartialRoutes(
  //         [],
  //         _routeManager
  //             .getWaypoints()
  //             .map((waypoint) => waypoint.getStop().placeId)
  //             .toList());
  //   }
  //   clearStationMarkersNotInRoute();
  // }

  // Future<void> setPartialRoutes(
  //     [List<String> first = const <String>[],
  //     List<String> intermediates = const <String>[]]) async {
  //   String originId = _routeManager.getStart().getStop().placeId;
  //   String destinationId = _routeManager.getDestination().getStop().placeId;

  //   String startStationId = _navigationManager.getPickupStation().place.placeId;
  //   String endStationId = _navigationManager.getDropoffStation().place.placeId;

  //   Rou.Route startWalkRoute = _navigationManager.ifBeginning()
  //       ? await _directionsService.getWalkingRoutes(
  //           originId, startStationId, first, false)
  //       : Rou.Route.routeNotFound();

  //   Rou.Route bikeRoute = _navigationManager.ifBeginning()
  //       ? await _directionsService.getRoutes(startStationId, endStationId,
  //           intermediates, _routeManager.ifOptimised())
  //       : _navigationManager.ifCycling()
  //           ? await _directionsService.getRoutes(originId, endStationId,
  //               intermediates, _routeManager.ifOptimised())
  //           : Rou.Route.routeNotFound();

  //   Rou.Route endWalkRoute = _navigationManager.ifEndWalking()
  //       ? await _directionsService.getWalkingRoutes(originId, destinationId)
  //       : await _directionsService.getWalkingRoutes(
  //           endStationId, destinationId);

  //   _routeManager.setRoutes(startWalkRoute, bikeRoute, endWalkRoute);
  //   _routeManager.showCurrentRoute(false);
  // }
}
