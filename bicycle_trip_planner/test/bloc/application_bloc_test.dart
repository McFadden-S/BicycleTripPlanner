import 'dart:async';

import 'package:bicycle_trip_planner/managers/NavigationManager.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/managers/StationManager.dart';
import 'package:bicycle_trip_planner/models/geometry.dart';
import 'package:bicycle_trip_planner/models/location.dart' as loc;
import 'package:bicycle_trip_planner/models/pathway.dart';
import 'package:bicycle_trip_planner/models/place.dart';
import 'package:bicycle_trip_planner/models/route.dart';
import 'package:bicycle_trip_planner/models/route_types.dart';
import 'package:bicycle_trip_planner/models/search_types.dart';
import 'package:bicycle_trip_planner/models/station.dart';
import 'package:bicycle_trip_planner/models/stop.dart';
import 'package:bicycle_trip_planner/services/directions_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bicycle_trip_planner/services/places_service.dart';
import 'package:location/location.dart';

import 'package:mockito/annotations.dart';
import 'package:bicycle_trip_planner/managers/LocationManager.dart';
import 'package:mockito/mockito.dart';
import 'application_bloc_test.mocks.dart';

import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bicycle_trip_planner/models/route.dart' as r;
import 'dart:convert' as convert;

@GenerateMocks(
    [LocationManager, PlacesService, DirectionsService, StationManager])
void main() {
  var locationManager = MockLocationManager();
  var placesServices = MockPlacesService();
  var directionsService = MockDirectionsService();
  var stationManager = MockStationManager();

  final routeManager = RouteManager();
  final navigationManager =
      NavigationManager.forMock(stationManager, routeManager, locationManager);

  var currentLocationLatLng = LatLng(51.513206, -0.117373);
  var currentPlace = Place(
      geometry: Geometry(
          location: loc.Location(
              lat: currentLocationLatLng.latitude,
              lng: currentLocationLatLng.longitude)),
      name: "currentLocation",
      placeId: "placeId",
      description: SearchType.current.description);

  when(locationManager.locate()).thenAnswer((_) async => currentLocationLatLng);

  when(locationManager.getCurrentLocation()).thenAnswer((_) => Place(
      geometry: Geometry(
          location: loc.Location(
              lat: currentLocationLatLng.latitude,
              lng: currentLocationLatLng.longitude)),
      name: "currentLocation",
      placeId: "MyCurrentLocation",
      description: "myCurrentLocation"));

  when(placesServices.getPlaceFromCoordinates(currentLocationLatLng.latitude,
          currentLocationLatLng.longitude, SearchType.current.description))
      .thenAnswer((_) async => currentPlace);

  when(stationManager.getPickupStationNear(LatLng(
          routeManager.getStart().getStop().geometry.location.lat,
          routeManager.getStart().getStop().geometry.location.lng)))
      .thenAnswer((_) async => Station(
          lat: routeManager.getStart().getStop().geometry.location.lat,
          lng: routeManager.getStart().getStop().geometry.location.lng,
          id: 10,
          name: 'firstStation',
          totalDocks: 10,
          emptyDocks: 0,
          bikes: 10));

  when(stationManager.getDropoffStationNear(LatLng(51.512856, -0.118404), 1))
      .thenAnswer((_) async => Station(
          lat: 51.512856,
          lng: -0.118404,
          id: 10,
          name: 'lastStation',
          totalDocks: 10,
          emptyDocks: 0,
          bikes: 10));

  when(stationManager.getDropoffStationNear(
          LatLng(routeManager.getDestination().getStop().geometry.location.lat,
              routeManager.getDestination().getStop().geometry.location.lng),
          1))
      .thenAnswer((_) async => Station(
          lat: routeManager.getDestination().getStop().geometry.location.lat,
          lng: routeManager.getDestination().getStop().geometry.location.lng,
          id: 10,
          name: 'lastStation',
          totalDocks: 10,
          emptyDocks: 0,
          bikes: 10));

  when(directionsService.getWalkingRoutes(
          routeManager.getStart().getStop().placeId,
          routeManager.getDestination().getStop().placeId))
      .thenAnswer(
          (realInvocation) async => Route.fromJson(convert.jsonDecode(r"""
  {
   "geocoded_waypoints" : [
      {
         "geocoder_status" : "OK",
         "place_id" : "ChIJUfP9ZLUEdkgRCMRrCxwl304",
         "types" : [ "street_address" ]
      },
      {
         "geocoder_status" : "OK",
         "place_id" : "ChIJL35SicoEdkgR-h_NBk0cMQA",
         "types" : [ "establishment", "point_of_interest", "transit_station" ]
      }
   ],
   "routes" : [
      {
         "bounds" : {
            "northeast" : {
               "lat" : 51.5131179,
               "lng" : -0.1172801
            },
            "southwest" : {
               "lat" : 51.5115989,
               "lng" : -0.1191371
            }
         },
         "copyrights" : "Map data ©2022 Google",
         "legs" : [
            {
               "distance" : {
                  "text" : "0.4 km",
                  "value" : 419
               },
               "duration" : {
                  "text" : "5 mins",
                  "value" : 325
               },
               "end_address" : "Aldwych / Drury Lane, London WC2B 4NA, UK",
               "end_location" : {
                  "lat" : 51.5128715,
                  "lng" : -0.1184306
               },
               "start_address" : "40 Aldwych, London WC2B 4BG, UK",
               "start_location" : {
                  "lat" : 51.5131179,
                  "lng" : -0.1172801
               },
               "steps" : [
                  {
                     "distance" : {
                        "text" : "0.2 km",
                        "value" : 206
                     },
                     "duration" : {
                        "text" : "2 mins",
                        "value" : 142
                     },
                     "end_location" : {
                        "lat" : 51.5117335,
                        "lng" : -0.1189128
                     },
                     "html_instructions" : "Head \u003cb\u003esouthwest\u003c/b\u003e on \u003cb\u003eAldwych\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eA4\u003c/b\u003e toward \u003cb\u003eKingsway\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eA4200\u003c/b\u003e",
                     "polyline" : {
                        "points" : "_dlyH~{UNt@F\\Nh@BFJf@LRV`@LNDD^VHFHDNHNDHBB@J@LBJ?B?VH"
                     },
                     "start_location" : {
                        "lat" : 51.5131179,
                        "lng" : -0.1172801
                     },
                     "travel_mode" : "WALKING"
                  },
                  {
                     "distance" : {
                        "text" : "22 m",
                        "value" : 22
                     },
                     "duration" : {
                        "text" : "1 min",
                        "value" : 15
                     },
                     "end_location" : {
                        "lat" : 51.511612,
                        "lng" : -0.1189349
                     },
                     "html_instructions" : "Slight \u003cb\u003eleft\u003c/b\u003e onto \u003cb\u003eAldwych\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eStrand\u003c/b\u003e",
                     "maneuver" : "turn-slight-left",
                     "polyline" : {
                        "points" : "i{kyHdfVHCLF"
                     },
                     "start_location" : {
                        "lat" : 51.5117335,
                        "lng" : -0.1189128
                     },
                     "travel_mode" : "WALKING"
                  },
                  {
                     "distance" : {
                        "text" : "67 m",
                        "value" : 67
                     },
                     "duration" : {
                        "text" : "1 min",
                        "value" : 72
                     },
                     "end_location" : {
                        "lat" : 51.512083,
                        "lng" : -0.1190444
                     },
                     "html_instructions" : "Take the crosswalk",
                     "polyline" : {
                        "points" : "qzkyHhfV@H?\\IAKAICEAG?I?K?MCMC"
                     },
                     "start_location" : {
                        "lat" : 51.511612,
                        "lng" : -0.1189349
                     },
                     "travel_mode" : "WALKING"
                  },
                  {
                     "distance" : {
                        "text" : "16 m",
                        "value" : 16
                     },
                     "duration" : {
                        "text" : "1 min",
                        "value" : 12
                     },
                     "end_location" : {
                        "lat" : 51.512194,
                        "lng" : -0.1190991
                     },
                     "html_instructions" : "Turn \u003cb\u003eleft\u003c/b\u003e onto \u003cb\u003eCatherine St\u003c/b\u003e",
                     "maneuver" : "turn-left",
                     "polyline" : {
                        "points" : "o}kyH~fVCRQG"
                     },
                     "start_location" : {
                        "lat" : 51.512083,
                        "lng" : -0.1190444
                     },
                     "travel_mode" : "WALKING"
                  },
                  {
                     "distance" : {
                        "text" : "16 m",
                        "value" : 16
                     },
                     "duration" : {
                        "text" : "1 min",
                        "value" : 13
                     },
                     "end_location" : {
                        "lat" : 51.5121856,
                        "lng" : -0.1190441
                     },
                     "html_instructions" : "Cross the road",
                     "polyline" : {
                        "points" : "e~kyHjgV?K"
                     },
                     "start_location" : {
                        "lat" : 51.512194,
                        "lng" : -0.1190991
                     },
                     "travel_mode" : "WALKING"
                  },
                  {
                     "distance" : {
                        "text" : "92 m",
                        "value" : 92
                     },
                     "duration" : {
                        "text" : "1 min",
                        "value" : 71
                     },
                     "end_location" : {
                        "lat" : 51.5128715,
                        "lng" : -0.1184306
                     },
                     "html_instructions" : "Turn \u003cb\u003eleft\u003c/b\u003e onto \u003cb\u003eAldwych\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eA4\u003c/b\u003e\u003cdiv style=\"font-size:0.9em\"\u003eDestination will be on the left\u003c/div\u003e",
                     "maneuver" : "turn-left",
                     "polyline" : {
                        "points" : "e~kyH~fVMEQIIGKGSMSUOQYc@"
                     },
                     "start_location" : {
                        "lat" : 51.5121856,
                        "lng" : -0.1190441
                     },
                     "travel_mode" : "WALKING"
                  }
               ],
               "traffic_speed_entry" : [],
               "via_waypoint" : []
            }
         ],
         "overview_polyline" : {
            "points" : "_dlyH~{UVrARp@Jf@LRd@p@x@j@l@Th@DVHHCLF@H?\\IAUEc@A[GCRQG?KME[Q_@Uc@g@Yc@"
         },
         "summary" : "Aldwych and Aldwych/A4",
         "warnings" : [
            "Walking directions are in beta. Use caution – This route may be missing sidewalks or pedestrian paths."
         ],
         "waypoint_order" : []
      }
   ],
   "status" : "OK"
}

  
  """)['routes'][0] as Map<String, dynamic>, RouteType.walk));

  var appBloc = ApplicationBloc.forMock(locationManager, placesServices,
      routeManager, navigationManager, directionsService, stationManager);

  test("Application bloc is initialized", () async {
    await untilCalled(locationManager.setCurrentLocation(currentPlace));
    verify(locationManager.setCurrentLocation(currentPlace)).called(1);
  });

  test("Start navigation", () async {
    StreamController<LocationData> controller =
        StreamController<LocationData>();
    Stream stream = controller.stream;
    when(locationManager.onUserLocationChange(5.0))
        .thenAnswer((_) => stream as Stream<LocationData>);

    routeManager.changeStart(Place(
        geometry:
            Geometry(location: loc.Location(lat: 51.513160, lng: -0.117254)),
        name: "Start",
        placeId: "start",
        description: "start"));

    routeManager.changeDestination(Place(
        geometry:
            Geometry(location: loc.Location(lat: 51.512856, lng: -0.118404)),
        name: "Destination",
        placeId: "destination",
        description: "destination"));

    for (Stop stop in routeManager.getStops()) {
      print(stop.getStop().getLatLng());
    }

    appBloc.startNavigation();

    // for (Stop stop in routeManager.getStops()) {
    //   print(stop.getStop().getLatLng());
    // }

    //routeManager.setRoutes(route_1, route_2, route_3);

    await untilCalled(locationManager.onUserLocationChange(5.0));
    verify(locationManager.onUserLocationChange(5.0)).called(1);

    await untilCalled(
        stationManager.getPickupStationNear(LatLng(51.513160, -0.117254)));
    verify(stationManager.getPickupStationNear(LatLng(51.513160, -0.117254)))
        .called(1);

    print("hi");

    //appBloc.updateDirections();

    //
    // verify(locationManager.locate());
  });

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
