import 'dart:async';
import 'package:bicycle_trip_planner/managers/NavigationManager.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/managers/StationManager.dart';
import 'package:bicycle_trip_planner/models/geometry.dart';
import 'package:bicycle_trip_planner/models/location.dart' as loc;
import 'package:bicycle_trip_planner/models/place.dart';
import 'package:bicycle_trip_planner/models/route.dart' as r;
import 'package:bicycle_trip_planner/models/route_types.dart';
import 'package:bicycle_trip_planner/models/search_types.dart';
import 'package:bicycle_trip_planner/models/station.dart';
import 'package:bicycle_trip_planner/models/stop.dart';
import 'package:bicycle_trip_planner/services/directions_service.dart';
import 'package:bicycle_trip_planner/widgets/general/other/Search.dart';
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

  //Might not be needed
  when(stationManager.getPickupStationNear(LatLng(51.513206, -0.117373)))
      .thenAnswer((_) async => Station(
          lat: 51.514148,
          lng: -0.119647,
          id: 10,
          name: 'firstStation',
          totalDocks: 10,
          emptyDocks: 0,
          bikes: 10,
          place: Place(
              geometry: Geometry(
                  location: loc.Location(lat: 51.514148, lng: -0.119647)),
              name: "firstStation",
              placeId: "firstStation",
              description: "firstStation")));

  when(stationManager.getDropoffStationNear(LatLng(51.508384, -0.125724), 1))
      .thenAnswer((_) async => Station(
          lat: 51.50984,
          lng: -0.126851,
          id: 10,
          name: 'lastStation',
          totalDocks: 10,
          emptyDocks: 0,
          bikes: 10,
          place: Place(
              geometry: Geometry(
                  location: loc.Location(lat: 51.50984, lng: -0.126851)),
              name: "lastStation",
              placeId: "lastStation",
              description: "lastStation")));

  when(locationManager.distanceFromToInMeters(
          LatLng(51.513206, -0.117373), LatLng(51.51316, -0.117254)))
      .thenAnswer((_) => 31);

  when(locationManager.distanceFromToInMeters(
          LatLng(51.513206, -0.117373), LatLng(51.50984, -0.126851)))
      .thenAnswer((_) => 16000);

  when(locationManager.distanceFromToInMeters(
          LatLng(51.513206, -0.117373), LatLng(0, 0)))
      .thenAnswer((_) => 10000);

  when(directionsService.getWalkingRoutes(
          routeManager.getStart().getStop().placeId,
          routeManager.getDestination().getStop().placeId))
      .thenAnswer(
          (realInvocation) async => r.Route.fromJson(convert.jsonDecode(r"""
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

  when(locationManager.distanceFromToInMeters(
          LatLng(51.513206, -0.117373), LatLng(51.514148, -0.119647)))
      .thenAnswer((_) => 189);

  when(locationManager.distanceFromToInMeters(
          LatLng(51.513206, -0.117373), LatLng(51.516244, -0.124454)))
      .thenAnswer((_) => 595.2);

  when(locationManager.distanceFromToInMeters(
          LatLng(51.513206, -0.117373), LatLng(51.515403, -0.118820)))
      .thenAnswer((_) => 264);

  when(directionsService.getWalkingRoutes(
          'MyCurrentLocation', 'firstStation', [], false))
      .thenAnswer(
          (realInvocation) async => r.Route.fromJson(convert.jsonDecode(r"""
        {
        "geocoded_waypoints" : [
        {
        "geocoder_status" : "OK",
        "place_id" : "ChIJE3OFmcoEdkgRnz0Tz2Tq_BI",
        "types" : [ "street_address" ]
        },
        {
        "geocoder_status" : "OK",
        "place_id" : "GhIJ46YGms_BSUAR24MQkC-hvr8",
        "types" : [ "plus_code" ]
        }
        ],
        "routes" : [
        {
        "bounds" : {
        "northeast" : {
        "lat" : 51.5146612,
        "lng" : -0.1172754
        },
        "southwest" : {
        "lat" : 51.5132611,
        "lng" : -0.119563
        }
        },
        "copyrights" : "Map data ©2022 Google",
        "legs" : [
        {
        "distance" : {
        "text" : "0.3 km",
        "value" : 306
        },
        "duration" : {
        "text" : "4 mins",
        "value" : 249
        },
        "end_address" : "GV7J+M4 London, UK",
        "end_location" : {
        "lat" : 51.5141127,
        "lng" : -0.119563
        },
        "start_address" : "Cafe Amici, 1 Kingsway, London WC2B 4DS, UK",
        "start_location" : {
        "lat" : 51.5132611,
        "lng" : -0.1172754
        },
        "steps" : [
        {
        "distance" : {
        "text" : "17 m",
        "value" : 17
        },
        "duration" : {
        "text" : "1 min",
        "value" : 12
        },
        "end_location" : {
        "lat" : 51.51333400000001,
        "lng" : -0.1175496
        },
        "html_instructions" : "Head \u003cb\u003enorthwest\u003c/b\u003e on \u003cb\u003eKingsway\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eA4200\u003c/b\u003e",
        "polyline" : {
        "points" : "{dlyH~{UOPGBH^"
        },
        "start_location" : {
        "lat" : 51.5132611,
        "lng" : -0.1172754
        },
        "travel_mode" : "WALKING"
        },
        {
        "distance" : {
        "text" : "14 m",
        "value" : 14
        },
        "duration" : {
        "text" : "1 min",
        "value" : 20
        },
        "end_location" : {
        "lat" : 51.5134637,
        "lng" : -0.1178556
        },
        "html_instructions" : "Turn \u003cb\u003eleft\u003c/b\u003e toward \u003cb\u003eKingsway\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eA4200\u003c/b\u003e",
        "maneuver" : "turn-left",
        "polyline" : {
        "points" : "ielyHt}UBN]l@"
        },
        "start_location" : {
        "lat" : 51.51333400000001,
        "lng" : -0.1175496
        },
        "travel_mode" : "WALKING"
        },
        {
        "distance" : {
        "text" : "0.2 km",
        "value" : 173
        },
        "duration" : {
        "text" : "2 mins",
        "value" : 139
        },
        "end_location" : {
        "lat" : 51.5146612,
        "lng" : -0.1186375
        },
        "html_instructions" : "Turn \u003cb\u003eright\u003c/b\u003e onto \u003cb\u003eKingsway\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eA4200\u003c/b\u003e",
        "maneuver" : "turn-right",
        "polyline" : {
        "points" : "cflyHr_VOBYP]RC@YP]R]R]REBi@\\"
        },
        "start_location" : {
        "lat" : 51.5134637,
        "lng" : -0.1178556
        },
        "travel_mode" : "WALKING"
        },
        {
        "distance" : {
        "text" : "0.1 km",
        "value" : 102
        },
        "duration" : {
        "text" : "1 min",
        "value" : 78
        },
        "end_location" : {
        "lat" : 51.5141127,
        "lng" : -0.119563
        },
        "html_instructions" : "Turn \u003cb\u003eleft\u003c/b\u003e onto \u003cb\u003eKemble St\u003c/b\u003e",
        "maneuver" : "turn-left",
        "polyline" : {
        "points" : "smlyHndVJp@DTFXFLB@HDDDNLLPXX"
        },
        "start_location" : {
        "lat" : 51.5146612,
        "lng" : -0.1186375
        },
        "travel_mode" : "WALKING"
        }
        ],
        "traffic_speed_entry" : [],
        "via_waypoint" : []
        }
        ],
        "overview_polyline" : {
        "points" : "{dlyH~{UWTLn@]l@OBw@d@yAz@c@Vi@\\Jp@Ln@JNNJ\\^XX"
        },
        "summary" : "Kingsway/A4200 and Kemble St",
        "warnings" : [
        "Walking directions are in beta. Use caution – This route may be missing sidewalks or pedestrian paths."
        ],
        "waypoint_order" : []
        }
        ],
        "status" : "OK"
        }
        """)['routes'][0] as Map<String, dynamic>, RouteType.walk));

  when(directionsService.getRoutes('firstStation', 'lastStation')).thenAnswer(
      (realInvocation) async => r.Route.fromJson(convert.jsonDecode(r"""
          {
   "geocoded_waypoints" : [
      {
         "geocoder_status" : "OK",
         "place_id" : "ChIJN3Fl28oEdkgR9tQolEhAm0o",
         "types" : [ "route" ]
      },
      {
         "geocoder_status" : "OK",
         "place_id" : "GhIJqBjnb0LBSUARtoE7UKc8wL8",
         "types" : [ "plus_code" ]
      }
   ],
   "routes" : [
      {
         "bounds" : {
            "northeast" : {
               "lat" : 51.51418150000001,
               "lng" : -0.1197267
            },
            "southwest" : {
               "lat" : 51.5098402,
               "lng" : -0.1269801
            }
         },
         "copyrights" : "Map data ©2022 Google",
         "legs" : [
            {
               "distance" : {
                  "text" : "0.8 km",
                  "value" : 824
               },
               "duration" : {
                  "text" : "10 mins",
                  "value" : 591
               },
               "end_address" : "GV5F+W7 London, UK",
               "end_location" : {
                  "lat" : 51.5098402,
                  "lng" : -0.1268298
               },
               "start_address" : "17 Kemble St, London WC2B, UK",
               "start_location" : {
                  "lat" : 51.51418150000001,
                  "lng" : -0.1197267
               },
               "steps" : [
                  {
                     "distance" : {
                        "text" : "55 m",
                        "value" : 55
                     },
                     "duration" : {
                        "text" : "1 min",
                        "value" : 42
                     },
                     "end_location" : {
                        "lat" : 51.5137323,
                        "lng" : -0.1202242
                     },
                     "html_instructions" : "Head \u003cb\u003esouthwest\u003c/b\u003e on \u003cb\u003eKemble St\u003c/b\u003e toward \u003cb\u003eDrury Ln\u003c/b\u003e",
                     "polyline" : {
                        "points" : "sjlyHhkVhAnANP"
                     },
                     "start_location" : {
                        "lat" : 51.51418150000001,
                        "lng" : -0.1197267
                     },
                     "travel_mode" : "WALKING"
                  },
                  {
                     "distance" : {
                        "text" : "4 m",
                        "value" : 4
                     },
                     "duration" : {
                        "text" : "1 min",
                        "value" : 5
                     },
                     "end_location" : {
                        "lat" : 51.5137121,
                        "lng" : -0.120161
                     },
                     "html_instructions" : "Turn \u003cb\u003eleft\u003c/b\u003e onto \u003cb\u003eDrury Ln\u003c/b\u003e",
                     "maneuver" : "turn-left",
                     "polyline" : {
                        "points" : "yglyHjnVBK"
                     },
                     "start_location" : {
                        "lat" : 51.5137323,
                        "lng" : -0.1202242
                     },
                     "travel_mode" : "WALKING"
                  },
                  {
                     "distance" : {
                        "text" : "0.1 km",
                        "value" : 143
                     },
                     "duration" : {
                        "text" : "2 mins",
                        "value" : 100
                     },
                     "end_location" : {
                        "lat" : 51.5126877,
                        "lng" : -0.121336
                     },
                     "html_instructions" : "Turn \u003cb\u003eright\u003c/b\u003e onto \u003cb\u003eRussell St\u003c/b\u003e",
                     "maneuver" : "turn-right",
                     "polyline" : {
                        "points" : "uglyH~mV~@z@NL~@v@HFFHDFHTL\\JZ"
                     },
                     "start_location" : {
                        "lat" : 51.5137121,
                        "lng" : -0.120161
                     },
                     "travel_mode" : "WALKING"
                  },
                  {
                     "distance" : {
                        "text" : "2 m",
                        "value" : 2
                     },
                     "duration" : {
                        "text" : "1 min",
                        "value" : 4
                     },
                     "end_location" : {
                        "lat" : 51.5126695,
                        "lng" : -0.1213162
                     },
                     "html_instructions" : "Turn \u003cb\u003eleft\u003c/b\u003e onto \u003cb\u003eBow St\u003c/b\u003e",
                     "maneuver" : "turn-left",
                     "polyline" : {
                        "points" : "ialyHjuVBC"
                     },
                     "start_location" : {
                        "lat" : 51.5126877,
                        "lng" : -0.121336
                     },
                     "travel_mode" : "WALKING"
                  },
                  {
                     "distance" : {
                        "text" : "0.1 km",
                        "value" : 105
                     },
                     "duration" : {
                        "text" : "1 min",
                        "value" : 75
                     },
                     "end_location" : {
                        "lat" : 51.5121164,
                        "lng" : -0.1224432
                     },
                     "html_instructions" : "Turn \u003cb\u003eright\u003c/b\u003e onto \u003cb\u003eRussell St\u003c/b\u003e",
                     "maneuver" : "turn-right",
                     "polyline" : {
                        "points" : "ealyHfuVFNHPFN^jALJBH\\bABF"
                     },
                     "start_location" : {
                        "lat" : 51.5126695,
                        "lng" : -0.1213162
                     },
                     "travel_mode" : "WALKING"
                  },
                  {
                     "building_level" : {
                        "number" : 0
                     },
                     "distance" : {
                        "text" : "51 m",
                        "value" : 51
                     },
                     "duration" : {
                        "text" : "1 min",
                        "value" : 36
                     },
                     "end_location" : {
                        "lat" : 51.511846,
                        "lng" : -0.1230402
                     },
                     "html_instructions" : "Walk for 51&nbsp;m",
                     "polyline" : {
                        "points" : "w}kyHf|Vt@vB"
                     },
                     "start_location" : {
                        "lat" : 51.5121164,
                        "lng" : -0.1224432
                     },
                     "travel_mode" : "WALKING"
                  },
                  {
                     "distance" : {
                        "text" : "27 m",
                        "value" : 27
                     },
                     "duration" : {
                        "text" : "1 min",
                        "value" : 20
                     },
                     "end_location" : {
                        "lat" : 51.51171290000001,
                        "lng" : -0.1233746
                     },
                     "html_instructions" : "Head \u003cb\u003esouthwest\u003c/b\u003e",
                     "polyline" : {
                        "points" : "a|kyH~_WBHBHRl@"
                     },
                     "start_location" : {
                        "lat" : 51.511846,
                        "lng" : -0.1230402
                     },
                     "travel_mode" : "WALKING"
                  },
                  {
                     "distance" : {
                        "text" : "39 m",
                        "value" : 39
                     },
                     "duration" : {
                        "text" : "1 min",
                        "value" : 30
                     },
                     "end_location" : {
                        "lat" : 51.5120077,
                        "lng" : -0.1236922
                     },
                     "html_instructions" : "Turn \u003cb\u003eright\u003c/b\u003e toward \u003cb\u003eKing St\u003c/b\u003e",
                     "maneuver" : "turn-right",
                     "polyline" : {
                        "points" : "e{kyH`bWUVEFIJCBQN"
                     },
                     "start_location" : {
                        "lat" : 51.51171290000001,
                        "lng" : -0.1233746
                     },
                     "travel_mode" : "WALKING"
                  },
                  {
                     "distance" : {
                        "text" : "0.1 km",
                        "value" : 130
                     },
                     "duration" : {
                        "text" : "2 mins",
                        "value" : 93
                     },
                     "end_location" : {
                        "lat" : 51.5112704,
                        "lng" : -0.1251935
                     },
                     "html_instructions" : "Turn \u003cb\u003eleft\u003c/b\u003e onto \u003cb\u003eKing St\u003c/b\u003e",
                     "maneuver" : "turn-left",
                     "polyline" : {
                        "points" : "a}kyH`dWHRj@|Ah@|AJZNd@@@FLLH"
                     },
                     "start_location" : {
                        "lat" : 51.5120077,
                        "lng" : -0.1236922
                     },
                     "travel_mode" : "WALKING"
                  },
                  {
                     "distance" : {
                        "text" : "0.1 km",
                        "value" : 134
                     },
                     "duration" : {
                        "text" : "2 mins",
                        "value" : 96
                     },
                     "end_location" : {
                        "lat" : 51.5110447,
                        "lng" : -0.1269801
                     },
                     "html_instructions" : "Continue onto \u003cb\u003eNew Row\u003c/b\u003e",
                     "polyline" : {
                        "points" : "mxkyHlmWLb@DT@@@LDt@ARDn@JfCAJ@L"
                     },
                     "start_location" : {
                        "lat" : 51.5112704,
                        "lng" : -0.1251935
                     },
                     "travel_mode" : "WALKING"
                  },
                  {
                     "distance" : {
                        "text" : "0.1 km",
                        "value" : 134
                     },
                     "duration" : {
                        "text" : "2 mins",
                        "value" : 90
                     },
                     "end_location" : {
                        "lat" : 51.5098402,
                        "lng" : -0.1268298
                     },
                     "html_instructions" : "Turn \u003cb\u003eleft\u003c/b\u003e onto \u003cb\u003eSt Martin's Ln\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eB404\u003c/b\u003e\u003cdiv style=\"font-size:0.9em\"\u003eDestination will be on the left\u003c/div\u003e",
                     "maneuver" : "turn-left",
                     "polyline" : {
                        "points" : "_wkyHrxWNCNGXEFAHAL@fAERAx@A"
                     },
                     "start_location" : {
                        "lat" : 51.5110447,
                        "lng" : -0.1269801
                     },
                     "travel_mode" : "WALKING"
                  }
               ],
               "traffic_speed_entry" : [],
               "via_waypoint" : []
            }
         ],
         "overview_polyline" : {
            "points" : "sjlyHhkVxA`BBK~@z@nAdAPPh@vABCFNP`@^jALJ`@lA`ArCRl@UVORURt@pBfA`DFLLHRx@BNBhAPvD?X`ASrBGx@A"
         },
         "summary" : "Russell St",
         "warnings" : [
            "Walking directions are in beta. Use caution – This route may be missing sidewalks or pedestrian paths."
         ],
         "waypoint_order" : []
      }
   ],
   "status" : "OK"
}       
        """)['routes'][0] as Map<String, dynamic>, RouteType.bike));

  when(directionsService.getWalkingRoutes("lastStation", "destination"))
      .thenAnswer(
          (realInvocation) async => r.Route.fromJson(convert.jsonDecode(r"""
     {
   "geocoded_waypoints" : [
      {
         "geocoder_status" : "OK",
         "place_id" : "ChIJd4992M0EdkgRUKSGAfSTXZs",
         "types" : [ "street_address" ]
      },
      {
         "geocoder_status" : "OK",
         "place_id" : "GhIJo-cWuhLBSUARQkEpWrkXwL8",
         "types" : [ "plus_code" ]
      }
   ],
   "routes" : [
      {
         "bounds" : {
            "northeast" : {
               "lat" : 51.5098402,
               "lng" : -0.1255615
            },
            "southwest" : {
               "lat" : 51.5083861,
               "lng" : -0.1269981
            }
         },
         "copyrights" : "Map data ©2022 Google",
         "legs" : [
            {
               "distance" : {
                  "text" : "0.3 km",
                  "value" : 266
               },
               "duration" : {
                  "text" : "3 mins",
                  "value" : 208
               },
               "end_address" : "GV5F+9P London, UK",
               "end_location" : {
                  "lat" : 51.5083861,
                  "lng" : -0.1256396
               },
               "start_address" : "114 St Martin's Ln, London WC2N 4BE, UK",
               "start_location" : {
                  "lat" : 51.5098402,
                  "lng" : -0.1268298
               },
               "steps" : [
                  {
                     "distance" : {
                        "text" : "0.1 km",
                        "value" : 95
                     },
                     "duration" : {
                        "text" : "1 min",
                        "value" : 66
                     },
                     "end_location" : {
                        "lat" : 51.5089917,
                        "lng" : -0.1269801
                     },
                     "html_instructions" : "Head \u003cb\u003esouth\u003c/b\u003e on \u003cb\u003eSt Martin's Ln\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eB404\u003c/b\u003e toward \u003cb\u003eBrydges Pl\u003c/b\u003e",
                     "polyline" : {
                        "points" : "ookyHtwWZ?J@NDF@PD@PXCZAN?N@"
                     },
                     "start_location" : {
                        "lat" : 51.5098402,
                        "lng" : -0.1268298
                     },
                     "travel_mode" : "WALKING"
                  },
                  {
                     "distance" : {
                        "text" : "76 m",
                        "value" : 76
                     },
                     "duration" : {
                        "text" : "1 min",
                        "value" : 54
                     },
                     "end_location" : {
                        "lat" : 51.5090055,
                        "lng" : -0.1258802
                     },
                     "html_instructions" : "Turn \u003cb\u003eleft\u003c/b\u003e onto \u003cb\u003eSt Martin-In-The Fields Church Path\u003c/b\u003e",
                     "maneuver" : "turn-left",
                     "polyline" : {
                        "points" : "ejkyHrxWAaDAy@"
                     },
                     "start_location" : {
                        "lat" : 51.5089917,
                        "lng" : -0.1269801
                     },
                     "travel_mode" : "WALKING"
                  },
                  {
                     "distance" : {
                        "text" : "43 m",
                        "value" : 43
                     },
                     "duration" : {
                        "text" : "1 min",
                        "value" : 28
                     },
                     "end_location" : {
                        "lat" : 51.508571,
                        "lng" : -0.1258397
                     },
                     "html_instructions" : "Turn \u003cb\u003eright\u003c/b\u003e onto \u003cb\u003eAdelaide St\u003c/b\u003e",
                     "maneuver" : "turn-right",
                     "polyline" : {
                        "points" : "ijkyHvqWbA?RG"
                     },
                     "start_location" : {
                        "lat" : 51.5090055,
                        "lng" : -0.1258802
                     },
                     "travel_mode" : "WALKING"
                  },
                  {
                     "distance" : {
                        "text" : "23 m",
                        "value" : 23
                     },
                     "duration" : {
                        "text" : "1 min",
                        "value" : 26
                     },
                     "end_location" : {
                        "lat" : 51.5085726,
                        "lng" : -0.1256755
                     },
                     "html_instructions" : "Turn \u003cb\u003eleft\u003c/b\u003e onto \u003cb\u003eDuncannon St\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eA4\u003c/b\u003e",
                     "maneuver" : "turn-left",
                     "polyline" : {
                        "points" : "qgkyHnqW?W?G"
                     },
                     "start_location" : {
                        "lat" : 51.508571,
                        "lng" : -0.1258397
                     },
                     "travel_mode" : "WALKING"
                  },
                  {
                     "distance" : {
                        "text" : "20 m",
                        "value" : 20
                     },
                     "duration" : {
                        "text" : "1 min",
                        "value" : 14
                     },
                     "end_location" : {
                        "lat" : 51.5084692,
                        "lng" : -0.1256991
                     },
                     "html_instructions" : "Turn \u003cb\u003eright\u003c/b\u003e onto \u003cb\u003eStrand\u003c/b\u003e",
                     "maneuver" : "turn-right",
                     "polyline" : {
                        "points" : "qgkyHnpWFLJI"
                     },
                     "start_location" : {
                        "lat" : 51.5085726,
                        "lng" : -0.1256755
                     },
                     "travel_mode" : "WALKING"
                  },
                  {
                     "distance" : {
                        "text" : "9 m",
                        "value" : 9
                     },
                     "duration" : {
                        "text" : "1 min",
                        "value" : 20
                     },
                     "end_location" : {
                        "lat" : 51.5083861,
                        "lng" : -0.1256396
                     },
                     "html_instructions" : "Turn \u003cb\u003eleft\u003c/b\u003e\u003cdiv style=\"font-size:0.9em\"\u003eDestination will be on the right\u003c/div\u003e",
                     "maneuver" : "turn-left",
                     "polyline" : {
                        "points" : "}fkyHrpWCENUBN"
                     },
                     "start_location" : {
                        "lat" : 51.5084692,
                        "lng" : -0.1256991
                     },
                     "travel_mode" : "WALKING"
                  }
               ],
               "traffic_speed_entry" : [],
               "via_waypoint" : []
            }
         ],
         "overview_polyline" : {
            "points" : "ookyHtwWf@@VFPD@Pt@E^@C{EbA?RG?_@FLJICENUBN"
         },
         "summary" : "St Martin-In-The Fields Church Path",
         "warnings" : [
            "Walking directions are in beta. Use caution – This route may be missing sidewalks or pedestrian paths."
         ],
         "waypoint_order" : []
      }
   ],
   "status" : "OK"
}
     """)["routes"][0] as Map<String, dynamic>, RouteType.walk));

  when(directionsService.getRoutes(
          'firstStation', 'lastStation', ['start'], true))
      .thenAnswer((_) async => r.Route.fromJson(convert.jsonDecode(r"""
          {
   "geocoded_waypoints" : [
      {
         "geocoder_status" : "OK",
         "place_id" : "GhIJ46YGms_BSUAR24MQkC-hvr8",
         "types" : [ "plus_code" ]
      },
      {
         "geocoder_status" : "OK",
         "place_id" : "GhIJqBjnb0LBSUARtoE7UKc8wL8",
         "types" : [ "plus_code" ]
      }
   ],
   "routes" : [
      {
         "bounds" : {
            "northeast" : {
               "lat" : 51.5145912,
               "lng" : -0.1196394
            },
            "southwest" : {
               "lat" : 51.5098393,
               "lng" : -0.127153
            }
         },
         "copyrights" : "Map data ©2022 Google",
         "legs" : [
            {
               "distance" : {
                  "text" : "1.0 km",
                  "value" : 1031
               },
               "duration" : {
                  "text" : "3 mins",
                  "value" : 161
               },
               "end_address" : "GV5F+W7 London, UK",
               "end_location" : {
                  "lat" : 51.5098393,
                  "lng" : -0.126915
               },
               "start_address" : "GV7J+M4 London, UK",
               "start_location" : {
                  "lat" : 51.5141448,
                  "lng" : -0.1196394
               },
               "steps" : [
                  {
                     "distance" : {
                        "text" : "55 m",
                        "value" : 55
                     },
                     "duration" : {
                        "text" : "1 min",
                        "value" : 11
                     },
                     "end_location" : {
                        "lat" : 51.5137327,
                        "lng" : -0.1200871
                     },
                     "html_instructions" : "Head \u003cb\u003esouthwest\u003c/b\u003e on \u003cb\u003eKemble St\u003c/b\u003e toward \u003cb\u003eDrury Ln\u003c/b\u003e",
                     "polyline" : {
                        "points" : "kjlyHvjVpAxA"
                     },
                     "start_location" : {
                        "lat" : 51.5141448,
                        "lng" : -0.1196394
                     },
                     "travel_mode" : "BICYCLING"
                  },
                  {
                     "distance" : {
                        "text" : "0.2 km",
                        "value" : 165
                     },
                     "duration" : {
                        "text" : "1 min",
                        "value" : 30
                     },
                     "end_location" : {
                        "lat" : 51.5145912,
                        "lng" : -0.1220169
                     },
                     "html_instructions" : "Turn \u003cb\u003eright\u003c/b\u003e onto \u003cb\u003eDrury Ln\u003c/b\u003e\u003cdiv style=\"font-size:0.9em\"\u003eLeaving toll zone\u003c/div\u003e",
                     "maneuver" : "turn-right",
                     "polyline" : {
                        "points" : "yglyHpmVKVEJGTELK\\GPSp@Sl@Sn@Sn@Yr@MT"
                     },
                     "start_location" : {
                        "lat" : 51.5137327,
                        "lng" : -0.1200871
                     },
                     "travel_mode" : "BICYCLING"
                  },
                  {
                     "distance" : {
                        "text" : "0.1 km",
                        "value" : 117
                     },
                     "duration" : {
                        "text" : "1 min",
                        "value" : 21
                     },
                     "end_location" : {
                        "lat" : 51.5138071,
                        "lng" : -0.1231193
                     },
                     "html_instructions" : "Turn \u003cb\u003eleft\u003c/b\u003e onto \u003cb\u003eLong Acre\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eB402\u003c/b\u003e",
                     "maneuver" : "turn-left",
                     "polyline" : {
                        "points" : "emlyHryVJLBDBDDHHLh@`A^p@Rb@@BBBBB@@D@F@"
                     },
                     "start_location" : {
                        "lat" : 51.5145912,
                        "lng" : -0.1220169
                     },
                     "travel_mode" : "BICYCLING"
                  },
                  {
                     "distance" : {
                        "text" : "0.1 km",
                        "value" : 101
                     },
                     "duration" : {
                        "text" : "1 min",
                        "value" : 14
                     },
                     "end_location" : {
                        "lat" : 51.5143016,
                        "lng" : -0.124226
                     },
                     "html_instructions" : "Turn \u003cb\u003eright\u003c/b\u003e onto \u003cb\u003eEndell St\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eB401\u003c/b\u003e",
                     "maneuver" : "turn-right",
                     "polyline" : {
                        "points" : "ihlyHn`W?H?D?D@H?F?F?D?HADADADADABCBQZ_@l@]f@EJ"
                     },
                     "start_location" : {
                        "lat" : 51.5138071,
                        "lng" : -0.1231193
                     },
                     "travel_mode" : "BICYCLING"
                  },
                  {
                     "distance" : {
                        "text" : "0.3 km",
                        "value" : 274
                     },
                     "duration" : {
                        "text" : "1 min",
                        "value" : 45
                     },
                     "end_location" : {
                        "lat" : 51.5126916,
                        "lng" : -0.127153
                     },
                     "html_instructions" : "Turn \u003cb\u003eleft\u003c/b\u003e onto \u003cb\u003eShelton St\u003c/b\u003e\u003cdiv style=\"font-size:0.9em\"\u003eEntering toll zone\u003c/div\u003e",
                     "maneuver" : "turn-left",
                     "polyline" : {
                        "points" : "kklyHlgWDFDJJPLZL\\BBVv@HTv@~Br@rBDJDJP^DLHNFH?@PPLNBBD@DB@@F@@BBBDF"
                     },
                     "start_location" : {
                        "lat" : 51.5143016,
                        "lng" : -0.124226
                     },
                     "travel_mode" : "BICYCLING"
                  },
                  {
                     "distance" : {
                        "text" : "0.3 km",
                        "value" : 319
                     },
                     "duration" : {
                        "text" : "1 min",
                        "value" : 40
                     },
                     "end_location" : {
                        "lat" : 51.5098393,
                        "lng" : -0.126915
                     },
                     "html_instructions" : "Turn \u003cb\u003eleft\u003c/b\u003e onto \u003cb\u003eUpper St Martin's Ln\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eB404\u003c/b\u003e\u003cdiv style=\"font-size:0.9em\"\u003eContinue to follow B404\u003c/div\u003e\u003cdiv style=\"font-size:0.9em\"\u003eLeaving toll zone\u003c/div\u003e\u003cdiv style=\"font-size:0.9em\"\u003eDestination will be on the left\u003c/div\u003e",
                     "maneuver" : "turn-left",
                     "polyline" : {
                        "points" : "ialyHtyWNGb@C`@?`@Af@?RBTBF?X@J?N?TAPENCHCXG`@GVAlAElAA"
                     },
                     "start_location" : {
                        "lat" : 51.5126916,
                        "lng" : -0.127153
                     },
                     "travel_mode" : "BICYCLING"
                  }
               ],
               "traffic_speed_entry" : [],
               "via_waypoint" : []
            }
         ],
         "overview_polyline" : {
            "points" : "kjlyHvjVpAxAKVM`@m@nBuA`EMTJLFJxAjC\\n@FBF@?H?J@PA\\GTsAtBEJDFP\\v@tBzBtGf@hAf@l@PJHDHJNGb@CbAAf@?RB\\Bd@@d@AdAUx@IzCG"
         },
         "summary" : "Shelton St and B404",
         "warnings" : [
            "Bicycling directions are in beta. Use caution – This route may contain streets that aren't suited for bicycling."
         ],
         "waypoint_order" : []
      }
   ],
   "status" : "OK"
}
          """)["routes"][0] as Map<String, dynamic>, RouteType.walk));

  when(placesServices.getPlaceFromCoordinates(
          51.508384, -0.125724, SearchType.current.description))
      .thenAnswer((_) async => Place.fromJson(convert.jsonDecode(r"""
      {
   "plus_code" : {
      "compound_code" : "GV5F+9P2 London, UK",
      "global_code" : "9C3XGV5F+9P2"
   },
   "results" : [
      {
         "address_components" : [
            {
               "long_name" : "Charing Cross Station",
               "short_name" : "Charing Cross Station",
               "types" : [
                  "establishment",
                  "point_of_interest",
                  "subway_station",
                  "transit_station"
               ]
            },
            {
               "long_name" : "London",
               "short_name" : "London",
               "types" : [ "postal_town" ]
            },
            {
               "long_name" : "Greater London",
               "short_name" : "Greater London",
               "types" : [ "administrative_area_level_2", "political" ]
            },
            {
               "long_name" : "England",
               "short_name" : "England",
               "types" : [ "administrative_area_level_1", "political" ]
            },
            {
               "long_name" : "United Kingdom",
               "short_name" : "GB",
               "types" : [ "country", "political" ]
            },
            {
               "long_name" : "WC2N 5RJ",
               "short_name" : "WC2N 5RJ",
               "types" : [ "postal_code" ]
            }
         ],
         "formatted_address" : "Charing Cross Station, London WC2N 5RJ, UK",
         "geometry" : {
            "location" : {
               "lat" : 51.5084994,
               "lng" : -0.1258604
            },
            "location_type" : "GEOMETRIC_CENTER",
            "viewport" : {
               "northeast" : {
                  "lat" : 51.5098483802915,
                  "lng" : -0.124511419708498
               },
               "southwest" : {
                  "lat" : 51.5071504197085,
                  "lng" : -0.127209380291502
               }
            }
         },
         "place_id" : "ChIJra2jTs4EdkgRshPsDJz8OM0",
         "plus_code" : {
            "compound_code" : "GV5F+9M London, UK",
            "global_code" : "9C3XGV5F+9M"
         },
         "types" : [
            "establishment",
            "point_of_interest",
            "subway_station",
            "transit_station"
         ]
      },
      {
         "address_components" : [
            {
               "long_name" : "11",
               "short_name" : "11",
               "types" : [ "street_number" ]
            },
            {
               "long_name" : "Strand",
               "short_name" : "A4",
               "types" : [ "route" ]
            },
            {
               "long_name" : "London",
               "short_name" : "London",
               "types" : [ "postal_town" ]
            },
            {
               "long_name" : "Greater London",
               "short_name" : "Greater London",
               "types" : [ "administrative_area_level_2", "political" ]
            },
            {
               "long_name" : "England",
               "short_name" : "England",
               "types" : [ "administrative_area_level_1", "political" ]
            },
            {
               "long_name" : "United Kingdom",
               "short_name" : "GB",
               "types" : [ "country", "political" ]
            },
            {
               "long_name" : "WC2N 5RJ",
               "short_name" : "WC2N 5RJ",
               "types" : [ "postal_code" ]
            }
         ],
         "formatted_address" : "11 A4, London WC2N 5RJ, UK",
         "geometry" : {
            "bounds" : {
               "northeast" : {
                  "lat" : 51.50843829999999,
                  "lng" : -0.1256475
               },
               "southwest" : {
                  "lat" : 51.5081697,
                  "lng" : -0.1261654
               }
            },
            "location" : {
               "lat" : 51.508304,
               "lng" : -0.1259065
            },
            "location_type" : "GEOMETRIC_CENTER",
            "viewport" : {
               "northeast" : {
                  "lat" : 51.5096529802915,
                  "lng" : -0.124557469708498
               },
               "southwest" : {
                  "lat" : 51.5069550197085,
                  "lng" : -0.127255430291502
               }
            }
         },
         "place_id" : "ChIJVWTp9M4EdkgRQFF-0XFuuDA",
         "types" : [ "route" ]
      },
      {
         "address_components" : [
            {
               "long_name" : "GV5F+9P",
               "short_name" : "GV5F+9P",
               "types" : [ "plus_code" ]
            },
            {
               "long_name" : "London",
               "short_name" : "London",
               "types" : [ "postal_town" ]
            },
            {
               "long_name" : "Greater London",
               "short_name" : "Greater London",
               "types" : [ "administrative_area_level_2", "political" ]
            },
            {
               "long_name" : "England",
               "short_name" : "England",
               "types" : [ "administrative_area_level_1", "political" ]
            },
            {
               "long_name" : "United Kingdom",
               "short_name" : "GB",
               "types" : [ "country", "political" ]
            }
         ],
         "formatted_address" : "GV5F+9P London, UK",
         "geometry" : {
            "bounds" : {
               "northeast" : {
                  "lat" : 51.5085,
                  "lng" : -0.125625
               },
               "southwest" : {
                  "lat" : 51.508375,
                  "lng" : -0.12575
               }
            },
            "location" : {
               "lat" : 51.508384,
               "lng" : -0.125724
            },
            "location_type" : "GEOMETRIC_CENTER",
            "viewport" : {
               "northeast" : {
                  "lat" : 51.5097864802915,
                  "lng" : -0.124338519708498
               },
               "southwest" : {
                  "lat" : 51.5070885197085,
                  "lng" : -0.127036480291502
               }
            }
         },
         "place_id" : "GhIJo-cWuhLBSUARQkEpWrkXwL8",
         "plus_code" : {
            "compound_code" : "GV5F+9P London, UK",
            "global_code" : "9C3XGV5F+9P"
         },
         "types" : [ "plus_code" ]
      },
      {
         "address_components" : [
            {
               "long_name" : "WC2N 5RJ",
               "short_name" : "WC2N 5RJ",
               "types" : [ "postal_code" ]
            },
            {
               "long_name" : "London",
               "short_name" : "London",
               "types" : [ "postal_town" ]
            },
            {
               "long_name" : "Greater London",
               "short_name" : "Greater London",
               "types" : [ "administrative_area_level_2", "political" ]
            },
            {
               "long_name" : "England",
               "short_name" : "England",
               "types" : [ "administrative_area_level_1", "political" ]
            },
            {
               "long_name" : "United Kingdom",
               "short_name" : "GB",
               "types" : [ "country", "political" ]
            }
         ],
         "formatted_address" : "London WC2N 5RJ, UK",
         "geometry" : {
            "bounds" : {
               "northeast" : {
                  "lat" : 51.5085094,
                  "lng" : -0.1253217
               },
               "southwest" : {
                  "lat" : 51.5078356,
                  "lng" : -0.1260326
               }
            },
            "location" : {
               "lat" : 51.5080957,
               "lng" : -0.1256962
            },
            "location_type" : "APPROXIMATE",
            "viewport" : {
               "northeast" : {
                  "lat" : 51.5095214802915,
                  "lng" : -0.124328169708498
               },
               "southwest" : {
                  "lat" : 51.5068235197085,
                  "lng" : -0.127026130291502
               }
            }
         },
         "place_id" : "ChIJ7QN-8c4EdkgRz8bZVsDuV-4",
         "types" : [ "postal_code" ]
      },
      {
         "address_components" : [
            {
               "long_name" : "WC2N",
               "short_name" : "WC2N",
               "types" : [ "postal_code", "postal_code_prefix" ]
            },
            {
               "long_name" : "London",
               "short_name" : "London",
               "types" : [ "postal_town" ]
            },
            {
               "long_name" : "Greater London",
               "short_name" : "Greater London",
               "types" : [ "administrative_area_level_2", "political" ]
            },
            {
               "long_name" : "England",
               "short_name" : "England",
               "types" : [ "administrative_area_level_1", "political" ]
            },
            {
               "long_name" : "United Kingdom",
               "short_name" : "GB",
               "types" : [ "country", "political" ]
            }
         ],
         "formatted_address" : "London WC2N, UK",
         "geometry" : {
            "bounds" : {
               "northeast" : {
                  "lat" : 51.5119464,
                  "lng" : -0.1156253
               },
               "southwest" : {
                  "lat" : 51.5057897,
                  "lng" : -0.1277062
               }
            },
            "location" : {
               "lat" : 51.50771659999999,
               "lng" : -0.1225564
            },
            "location_type" : "APPROXIMATE",
            "viewport" : {
               "northeast" : {
                  "lat" : 51.5119464,
                  "lng" : -0.1156253
               },
               "southwest" : {
                  "lat" : 51.5057897,
                  "lng" : -0.1277062
               }
            }
         },
         "place_id" : "ChIJb9KHxsgEdkgRe82UfSxQIv0",
         "types" : [ "postal_code", "postal_code_prefix" ]
      },
      {
         "address_components" : [
            {
               "long_name" : "Charing Cross",
               "short_name" : "Charing Cross",
               "types" : [ "administrative_area_level_4", "political" ]
            },
            {
               "long_name" : "London",
               "short_name" : "London",
               "types" : [ "postal_town" ]
            },
            {
               "long_name" : "Greater London",
               "short_name" : "Greater London",
               "types" : [ "administrative_area_level_2", "political" ]
            },
            {
               "long_name" : "England",
               "short_name" : "England",
               "types" : [ "administrative_area_level_1", "political" ]
            },
            {
               "long_name" : "United Kingdom",
               "short_name" : "GB",
               "types" : [ "country", "political" ]
            }
         ],
         "formatted_address" : "Charing Cross, London, UK",
         "geometry" : {
            "bounds" : {
               "northeast" : {
                  "lat" : 51.5135131,
                  "lng" : -0.121372
               },
               "southwest" : {
                  "lat" : 51.5064678,
                  "lng" : -0.1292108
               }
            },
            "location" : {
               "lat" : 51.5090275,
               "lng" : -0.1255016
            },
            "location_type" : "APPROXIMATE",
            "viewport" : {
               "northeast" : {
                  "lat" : 51.5135131,
                  "lng" : -0.121372
               },
               "southwest" : {
                  "lat" : 51.5064678,
                  "lng" : -0.1292108
               }
            }
         },
         "place_id" : "ChIJrStISs4EdkgRvEoozoLVlx0",
         "types" : [ "administrative_area_level_4", "political" ]
      },
      {
         "address_components" : [
            {
               "long_name" : "City of Westminster",
               "short_name" : "City of Westminster",
               "types" : [ "administrative_area_level_3", "political" ]
            },
            {
               "long_name" : "London",
               "short_name" : "London",
               "types" : [ "postal_town" ]
            },
            {
               "long_name" : "Greater London",
               "short_name" : "Greater London",
               "types" : [ "administrative_area_level_2", "political" ]
            },
            {
               "long_name" : "England",
               "short_name" : "England",
               "types" : [ "administrative_area_level_1", "political" ]
            },
            {
               "long_name" : "United Kingdom",
               "short_name" : "GB",
               "types" : [ "country", "political" ]
            }
         ],
         "formatted_address" : "City of Westminster, London, UK",
         "geometry" : {
            "bounds" : {
               "northeast" : {
                  "lat" : 51.5397932,
                  "lng" : -0.1111016
               },
               "southwest" : {
                  "lat" : 51.4838163,
                  "lng" : -0.2160886
               }
            },
            "location" : {
               "lat" : 51.5145337,
               "lng" : -0.1595389
            },
            "location_type" : "APPROXIMATE",
            "viewport" : {
               "northeast" : {
                  "lat" : 51.5397932,
                  "lng" : -0.1111016
               },
               "southwest" : {
                  "lat" : 51.4838163,
                  "lng" : -0.2160886
               }
            }
         },
         "place_id" : "ChIJxwN8mDUFdkgRoGfsoi2uDgQ",
         "types" : [ "administrative_area_level_3", "political" ]
      },
      {
         "address_components" : [
            {
               "long_name" : "London",
               "short_name" : "London",
               "types" : [ "locality", "political" ]
            },
            {
               "long_name" : "London",
               "short_name" : "London",
               "types" : [ "postal_town" ]
            },
            {
               "long_name" : "Greater London",
               "short_name" : "Greater London",
               "types" : [ "administrative_area_level_2", "political" ]
            },
            {
               "long_name" : "England",
               "short_name" : "England",
               "types" : [ "administrative_area_level_1", "political" ]
            },
            {
               "long_name" : "United Kingdom",
               "short_name" : "GB",
               "types" : [ "country", "political" ]
            }
         ],
         "formatted_address" : "London, UK",
         "geometry" : {
            "bounds" : {
               "northeast" : {
                  "lat" : 51.6723432,
                  "lng" : 0.148271
               },
               "southwest" : {
                  "lat" : 51.38494009999999,
                  "lng" : -0.3514683
               }
            },
            "location" : {
               "lat" : 51.5072178,
               "lng" : -0.1275862
            },
            "location_type" : "APPROXIMATE",
            "viewport" : {
               "northeast" : {
                  "lat" : 51.6723432,
                  "lng" : 0.148271
               },
               "southwest" : {
                  "lat" : 51.38494009999999,
                  "lng" : -0.3514683
               }
            }
         },
         "place_id" : "ChIJdd4hrwug2EcRmSrV3Vo6llI",
         "types" : [ "locality", "political" ]
      },
      {
         "address_components" : [
            {
               "long_name" : "London",
               "short_name" : "London",
               "types" : [ "postal_town" ]
            },
            {
               "long_name" : "Greater London",
               "short_name" : "Greater London",
               "types" : [ "administrative_area_level_2", "political" ]
            },
            {
               "long_name" : "England",
               "short_name" : "England",
               "types" : [ "administrative_area_level_1", "political" ]
            },
            {
               "long_name" : "United Kingdom",
               "short_name" : "GB",
               "types" : [ "country", "political" ]
            }
         ],
         "formatted_address" : "London, UK",
         "geometry" : {
            "bounds" : {
               "northeast" : {
                  "lat" : 51.6723432,
                  "lng" : 0.148271
               },
               "southwest" : {
                  "lat" : 51.38494009999999,
                  "lng" : -0.3514683
               }
            },
            "location" : {
               "lat" : 51.5569879,
               "lng" : -0.1411791
            },
            "location_type" : "APPROXIMATE",
            "viewport" : {
               "northeast" : {
                  "lat" : 51.6723432,
                  "lng" : 0.148271
               },
               "southwest" : {
                  "lat" : 51.38494009999999,
                  "lng" : -0.3514683
               }
            }
         },
         "place_id" : "ChIJ8_MXt1sbdkgRCrIAOXkukUk",
         "types" : [ "postal_town" ]
      },
      {
         "address_components" : [
            {
               "long_name" : "Greater London",
               "short_name" : "Greater London",
               "types" : [ "administrative_area_level_2", "political" ]
            },
            {
               "long_name" : "England",
               "short_name" : "England",
               "types" : [ "administrative_area_level_1", "political" ]
            },
            {
               "long_name" : "United Kingdom",
               "short_name" : "GB",
               "types" : [ "country", "political" ]
            }
         ],
         "formatted_address" : "Greater London, UK",
         "geometry" : {
            "bounds" : {
               "northeast" : {
                  "lat" : 51.6918726,
                  "lng" : 0.3339957
               },
               "southwest" : {
                  "lat" : 51.28676,
                  "lng" : -0.5103751
               }
            },
            "location" : {
               "lat" : 51.4309209,
               "lng" : -0.0936496
            },
            "location_type" : "APPROXIMATE",
            "viewport" : {
               "northeast" : {
                  "lat" : 51.6918726,
                  "lng" : 0.3339957
               },
               "southwest" : {
                  "lat" : 51.28676,
                  "lng" : -0.5103751
               }
            }
         },
         "place_id" : "ChIJb-IaoQug2EcRi-m4hONz8S8",
         "types" : [ "administrative_area_level_2", "political" ]
      },
      {
         "address_components" : [
            {
               "long_name" : "England",
               "short_name" : "England",
               "types" : [ "administrative_area_level_1", "political" ]
            },
            {
               "long_name" : "United Kingdom",
               "short_name" : "GB",
               "types" : [ "country", "political" ]
            }
         ],
         "formatted_address" : "England, UK",
         "geometry" : {
            "bounds" : {
               "northeast" : {
                  "lat" : 55.81165979999999,
                  "lng" : 1.7629159
               },
               "southwest" : {
                  "lat" : 49.8647411,
                  "lng" : -6.4185458
               }
            },
            "location" : {
               "lat" : 52.3555177,
               "lng" : -1.1743197
            },
            "location_type" : "APPROXIMATE",
            "viewport" : {
               "northeast" : {
                  "lat" : 55.81165979999999,
                  "lng" : 1.7629159
               },
               "southwest" : {
                  "lat" : 49.8647411,
                  "lng" : -6.4185458
               }
            }
         },
         "place_id" : "ChIJ39UebIqp0EcRqI4tMyWV4fQ",
         "types" : [ "administrative_area_level_1", "political" ]
      },
      {
         "address_components" : [
            {
               "long_name" : "United Kingdom",
               "short_name" : "GB",
               "types" : [ "country", "political" ]
            }
         ],
         "formatted_address" : "United Kingdom",
         "geometry" : {
            "bounds" : {
               "northeast" : {
                  "lat" : 60.91569999999999,
                  "lng" : 33.9165549
               },
               "southwest" : {
                  "lat" : 34.5614,
                  "lng" : -8.8988999
               }
            },
            "location" : {
               "lat" : 55.378051,
               "lng" : -3.435973
            },
            "location_type" : "APPROXIMATE",
            "viewport" : {
               "northeast" : {
                  "lat" : 60.91569999999999,
                  "lng" : 33.9165549
               },
               "southwest" : {
                  "lat" : 34.5614,
                  "lng" : -8.8988999
               }
            }
         },
         "place_id" : "ChIJqZHHQhE7WgIReiWIMkOg-MQ",
         "types" : [ "country", "political" ]
      }
   ],
   "status" : "OK"
}
      """)['results'][0] as Map<String, dynamic>, "myCurrentLocation"));

  when(locationManager.distanceFromToInMeters(
          LatLng(51.508384, -0.125724), LatLng(51.51316, -0.117254)))
      .thenAnswer((_) => 791);

  when(locationManager.distanceFromToInMeters(
          LatLng(51.508384, -0.125724), LatLng(51.514148, -0.119647)))
      .thenAnswer((_) => 766);

  when(locationManager.distanceFromToInMeters(
          LatLng(51.508384, -0.125724), LatLng(51.50984, -0.126851)))
      .thenAnswer((_) => 29);

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
            Geometry(location: loc.Location(lat: 51.51316, lng: -0.117254)),
        name: "Start",
        placeId: "start",
        description: "start"));

    routeManager.changeDestination(Place(
        geometry:
            Geometry(location: loc.Location(lat: 51.508384, lng: -0.125724)),
        name: "Destination",
        placeId: "destination",
        description: "destination"));

    for (Stop stop in routeManager.getStops()) {
      print(stop.getStop().getLatLng());
    }

    Map<String, dynamic> locationChange_1 = {
      "latitude": 51.513948,
      "longitude": -0.119872,
      "accuracy": 0.0,
      "altitude": 0.0,
      "speed": 0.0,
      "speedAccuracy": 0.0,
      "heading": 0.0,
      "time": 0.0,
      "isMock": false,
      "verticalAccuracy": 0.0,
      "headingAccuracy": 0.0,
      "elapsedRealtimeNanos": 0.0,
      "elapsedRealtimeUncertaintyNanos": 0.0,
      "satelliteNumber": 0,
      "provider": "asdf"
    };
    var x = LocationData.fromMap(locationChange_1);

    appBloc.startNavigation();

    List<Station> stations = [];
    stations.add(navigationManager.getPickupStation());
    stations.add(navigationManager.getDropoffStation());
    when(stationManager.getStations()).thenAnswer((realInvocation) => stations);

    when(directionsService.getWalkingRoutes("MyCurrentLocation", "destination"))
        .thenAnswer(
            (realInvocation) async => r.Route.fromJson(convert.jsonDecode(r"""
            {
   "geocoded_waypoints" : [
      {
         "geocoder_status" : "OK",
         "place_id" : "ChIJE3OFmcoEdkgRnz0Tz2Tq_BI",
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
               "lat" : 51.5133786,
               "lng" : -0.1172754
            },
            "southwest" : {
               "lat" : 51.5128715,
               "lng" : -0.1184306
            }
         },
         "copyrights" : "Map data ©2022 Google",
         "legs" : [
            {
               "distance" : {
                  "text" : "0.1 km",
                  "value" : 109
               },
               "duration" : {
                  "text" : "2 mins",
                  "value" : 99
               },
               "end_address" : "Aldwych / Drury Lane, London WC2B 4NA, UK",
               "end_location" : {
                  "lat" : 51.5128715,
                  "lng" : -0.1184306
               },
               "start_address" : "Cafe Amici, 1 Kingsway, London WC2B 4DS, UK",
               "start_location" : {
                  "lat" : 51.5132611,
                  "lng" : -0.1172754
               },
               "steps" : [
                  {
                     "distance" : {
                        "text" : "17 m",
                        "value" : 17
                     },
                     "duration" : {
                        "text" : "1 min",
                        "value" : 12
                     },
                     "end_location" : {
                        "lat" : 51.51333400000001,
                        "lng" : -0.1175496
                     },
                     "html_instructions" : "Head \u003cb\u003enorthwest\u003c/b\u003e on \u003cb\u003eKingsway\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eA4200\u003c/b\u003e",
                     "polyline" : {
                        "points" : "{dlyH~{UOPGBH^"
                     },
                     "start_location" : {
                        "lat" : 51.5132611,
                        "lng" : -0.1172754
                     },
                     "travel_mode" : "WALKING"
                  },
                  {
                     "distance" : {
                        "text" : "14 m",
                        "value" : 14
                     },
                     "duration" : {
                        "text" : "1 min",
                        "value" : 20
                     },
                     "end_location" : {
                        "lat" : 51.5132865,
                        "lng" : -0.1178081
                     },
                     "html_instructions" : "Turn \u003cb\u003eleft\u003c/b\u003e toward \u003cb\u003eKingsway\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eA4200\u003c/b\u003e",
                     "maneuver" : "turn-left",
                     "polyline" : {
                        "points" : "ielyHt}UBNBb@"
                     },
                     "start_location" : {
                        "lat" : 51.51333400000001,
                        "lng" : -0.1175496
                     },
                     "travel_mode" : "WALKING"
                  },
                  {
                     "distance" : {
                        "text" : "17 m",
                        "value" : 17
                     },
                     "duration" : {
                        "text" : "1 min",
                        "value" : 22
                     },
                     "end_location" : {
                        "lat" : 51.5131996,
                        "lng" : -0.1177848
                     },
                     "html_instructions" : "Turn \u003cb\u003eleft\u003c/b\u003e onto \u003cb\u003eKingsway\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eA4200\u003c/b\u003e",
                     "maneuver" : "turn-left",
                     "polyline" : {
                        "points" : "aelyHh_VPE"
                     },
                     "start_location" : {
                        "lat" : 51.5132865,
                        "lng" : -0.1178081
                     },
                     "travel_mode" : "WALKING"
                  },
                  {
                     "distance" : {
                        "text" : "61 m",
                        "value" : 61
                     },
                     "duration" : {
                        "text" : "1 min",
                        "value" : 45
                     },
                     "end_location" : {
                        "lat" : 51.5128715,
                        "lng" : -0.1184306
                     },
                     "html_instructions" : "Turn \u003cb\u003eright\u003c/b\u003e onto \u003cb\u003eAldwych\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eA4\u003c/b\u003e\u003cdiv style=\"font-size:0.9em\"\u003eDestination will be on the right\u003c/div\u003e",
                     "maneuver" : "turn-right",
                     "polyline" : {
                        "points" : "odlyHb_VDPJ^BFJVJRRZ"
                     },
                     "start_location" : {
                        "lat" : 51.5131996,
                        "lng" : -0.1177848
                     },
                     "travel_mode" : "WALKING"
                  }
               ],
               "traffic_speed_entry" : [],
               "via_waypoint" : []
            }
         ],
         "overview_polyline" : {
            "points" : "{dlyH~{UWTLn@Bb@PEPp@n@nA"
         },
         "summary" : "Kingsway/A4200 and Aldwych/A4",
         "warnings" : [
            "Walking directions are in beta. Use caution – This route may be missing sidewalks or pedestrian paths."
         ],
         "waypoint_order" : []
      }
   ],
   "status" : "OK"
}

            """)['routes'][0] as Map<String, dynamic>, RouteType.walk));

    await untilCalled(locationManager.onUserLocationChange(5.0));
    verify(locationManager.onUserLocationChange(5.0)).called(1);

    controller.add(x);
    await untilCalled(locationManager.distanceFromToInMeters(
        LatLng(51.513206, -0.117373), LatLng(51.50984, -0.126851)));

    Map<String, dynamic> locationChange_2 = {
      "latitude": 51.508384,
      "longitude": -0.125724,
      "accuracy": 0.0,
      "altitude": 0.0,
      "speed": 0.0,
      "speedAccuracy": 0.0,
      "heading": 0.0,
      "time": 0.0,
      "isMock": false,
      "verticalAccuracy": 0.0,
      "headingAccuracy": 0.0,
      "elapsedRealtimeNanos": 0.0,
      "elapsedRealtimeUncertaintyNanos": 0.0,
      "satelliteNumber": 0,
      "provider": "asdf"
    };
    x = LocationData.fromMap(locationChange_2);

    //Verifies partial routes are being stored after initial walking route is done
    verify(directionsService.getRoutes(
        'firstStation', 'lastStation', ['start'], true));

    currentLocationLatLng = LatLng(51.508384, -0.125724);
    controller.add(x);
  });
}
