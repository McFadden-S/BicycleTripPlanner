import 'package:bicycle_trip_planner/managers/DirectionManager.dart';
import 'package:bicycle_trip_planner/managers/PolylineManager.dart';
import 'package:bicycle_trip_planner/models/distance_types.dart';
import 'package:bicycle_trip_planner/models/geometry.dart';
import 'package:bicycle_trip_planner/models/place.dart';
import 'package:bicycle_trip_planner/models/route.dart' as R;
import 'package:bicycle_trip_planner/models/route_types.dart';
import 'package:bicycle_trip_planner/models/steps.dart';
import 'package:bicycle_trip_planner/models/stop.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test/test.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'dart:convert' as convert;

void main() {
  final routeManager = RouteManager();
  final directionManager = DirectionManager();

  final route_1 = R.Route.fromJson(convert.jsonDecode(r"""
       {
   "geocoded_waypoints" : [
      {
         "geocoder_status" : "OK",
         "place_id" : "ChIJ__8_fLUEdkgRXd3d1TaO8nw",
         "types" : [ "establishment", "point_of_interest", "university" ]
      },
      {
         "geocoder_status" : "OK",
         "place_id" : "ChIJDewcaLUEdkgRByjdEk9z704",
         "types" : [ "street_address" ]
      }
   ],
   "routes" : [
      {
         "bounds" : {
            "northeast" : {
               "lat" : 51.5136215,
               "lng" : -0.1128304
            },
            "southwest" : {
               "lat" : 51.5128475,
               "lng" : -0.1174349
            }
         },
         "copyrights" : "Map data ©2022 Google",
         "legs" : [
            {
               "distance" : {
                  "text" : "0.7 km",
                  "value" : 690
               },
               "duration" : {
                  "text" : "9 mins",
                  "value" : 524
               },
               "end_address" : "58 Houghton St, London WC2B 4RR, UK",
               "end_location" : {
                  "lat" : 51.5136215,
                  "lng" : -0.1166481
               },
               "start_address" : "30 Aldwych, London WC2B 4BG, UK",
               "start_location" : {
                  "lat" : 51.513074,
                  "lng" : -0.1174349
               },
               "steps" : [
                  {
                     "distance" : {
                        "text" : "0.2 km",
                        "value" : 204
                     },
                     "duration" : {
                        "text" : "2 mins",
                        "value" : 141
                     },
                     "end_location" : {
                        "lat" : 51.5130335,
                        "lng" : -0.114607
                     },
                     "html_instructions" : "Head \u003cb\u003enortheast\u003c/b\u003e on \u003cb\u003eAldwych\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eA4\u003c/b\u003e toward \u003cb\u003eKingsway\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eA4200\u003c/b\u003e\u003cdiv style=\"font-size:0.9em\"\u003eContinue to follow Aldwych\u003c/div\u003e",
                     "polyline" : {
                        "points" : "uclyH||UCKG_@?AE[CMAUCW?EIo@?_@@_@@IH[BWFc@Jk@F_@\\q@@GBCc@kA"
                     },
                     "start_location" : {
                        "lat" : 51.513074,
                        "lng" : -0.1174349
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
                        "value" : 27
                     },
                     "end_location" : {
                        "lat" : 51.51307600000001,
                        "lng" : -0.1146608
                     },
                     "html_instructions" : "Cross the road",
                     "polyline" : {
                        "points" : "mclyHhkUIH"
                     },
                     "start_location" : {
                        "lat" : 51.5130335,
                        "lng" : -0.114607
                     },
                     "travel_mode" : "WALKING"
                  },
                  {
                     "distance" : {
                        "text" : "0.2 km",
                        "value" : 156
                     },
                     "duration" : {
                        "text" : "2 mins",
                        "value" : 109
                     },
                     "end_location" : {
                        "lat" : 51.51348489999999,
                        "lng" : -0.1128304
                     },
                     "html_instructions" : "Turn \u003cb\u003eright\u003c/b\u003e onto \u003cb\u003eStrand\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eA4\u003c/b\u003e",
                     "maneuver" : "turn-right",
                     "polyline" : {
                        "points" : "wclyHrkUG}@KWCKMeAK_ASeB?IIU"
                     },
                     "start_location" : {
                        "lat" : 51.51307600000001,
                        "lng" : -0.1146608
                     },
                     "travel_mode" : "WALKING"
                  },
                  {
                     "distance" : {
                        "text" : "0.3 km",
                        "value" : 277
                     },
                     "duration" : {
                        "text" : "4 mins",
                        "value" : 224
                     },
                     "end_location" : {
                        "lat" : 51.5134052,
                        "lng" : -0.11663
                     },
                     "html_instructions" : "Cross the road\u003cdiv style=\"font-size:0.9em\"\u003eContinue to follow A4\u003c/div\u003e",
                     "polyline" : {
                        "points" : "gflyHd`UCT?H@HR`BFj@@ZJfAHNDNJjAEZGb@Mn@Id@Gj@ET@z@AZAf@?V"
                     },
                     "start_location" : {
                        "lat" : 51.51348489999999,
                        "lng" : -0.1128304
                     },
                     "travel_mode" : "WALKING"
                  },
                  {
                     "distance" : {
                        "text" : "31 m",
                        "value" : 31
                     },
                     "duration" : {
                        "text" : "1 min",
                        "value" : 23
                     },
                     "end_location" : {
                        "lat" : 51.5136215,
                        "lng" : -0.1166481
                     },
                     "html_instructions" : "Turn \u003cb\u003eright\u003c/b\u003e onto \u003cb\u003eHoughton St\u003c/b\u003e\u003cdiv style=\"font-size:0.9em\"\u003eDestination will be on the left\u003c/div\u003e",
                     "maneuver" : "turn-right",
                     "polyline" : {
                        "points" : "yelyH|wUi@B"
                     },
                     "start_location" : {
                        "lat" : 51.5134052,
                        "lng" : -0.11663
                     },
                     "travel_mode" : "WALKING"
                  }
               ],
               "traffic_speed_entry" : [],
               "via_waypoint" : []
            }
         ],
         "overview_polyline" : {
            "points" : "uclyH||UQiAIaAIo@?_@Bi@Ls@RoAF_@\\q@DKc@kAIHG}@KWQqA_@eDI_@C^TjBHfAJfAHNDNJjAM~@WtAM`A?vAA~@i@B"
         },
         "summary" : "Aldwych and A4",
         "warnings" : [
            "Walking directions are in beta. Use caution – This route may be missing sidewalks or pedestrian paths."
         ],
         "waypoint_order" : []
      }
   ],
   "status" : "OK"
}

        """)["routes"][0] as Map<String, dynamic>, RouteType.walk);

  final route_2 = R.Route.fromJson(convert.jsonDecode(r"""
{
   "geocoded_waypoints" : [
      {
         "geocoder_status" : "OK",
         "place_id" : "ChIJDewcaLUEdkgRByjdEk9z704",
         "types" : [ "street_address" ]
      },
      {
         "geocoder_status" : "OK",
         "place_id" : "ChIJqR5M5rkEdkgRITVCkjoRm5Y",
         "types" : [ "street_address" ]
      }
   ],
   "routes" : [
      {
         "bounds" : {
            "northeast" : {
               "lat" : 51.5136199,
               "lng" : -0.1127984
            },
            "southwest" : {
               "lat" : 51.503849,
               "lng" : -0.1190993
            }
         },
         "copyrights" : "Map data ©2022",
         "legs" : [
            {
               "distance" : {
                  "text" : "1.4 km",
                  "value" : 1436
               },
               "duration" : {
                  "text" : "6 mins",
                  "value" : 378
               },
               "end_address" : "15a Mepham St, London SE1 8SQ, UK",
               "end_location" : {
                  "lat" : 51.503849,
                  "lng" : -0.1127984
               },
               "start_address" : "58 Houghton St, London WC2B 4RR, UK",
               "start_location" : {
                  "lat" : 51.5136199,
                  "lng" : -0.1166969
               },
               "steps" : [
                  {
                     "distance" : {
                        "text" : "31 m",
                        "value" : 31
                     },
                     "duration" : {
                        "text" : "1 min",
                        "value" : 4
                     },
                     "end_location" : {
                        "lat" : 51.5133402,
                        "lng" : -0.1166735
                     },
                     "html_instructions" : "Head \u003cb\u003esouth\u003c/b\u003e on \u003cb\u003eHoughton St\u003c/b\u003e toward \u003cb\u003eAldwych\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eA4\u003c/b\u003e",
                     "polyline" : {
                        "points" : "cglyHjxUv@E"
                     },
                     "start_location" : {
                        "lat" : 51.5136199,
                        "lng" : -0.1166969
                     },
                     "travel_mode" : "BICYCLING"
                  },
                  {
                     "distance" : {
                        "text" : "0.3 km",
                        "value" : 278
                     },
                     "duration" : {
                        "text" : "2 mins",
                        "value" : 123
                     },
                     "end_location" : {
                        "lat" : 51.5116184,
                        "lng" : -0.1188994
                     },
                     "html_instructions" : "Turn \u003cb\u003eright\u003c/b\u003e onto \u003cb\u003eAldwych\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eA4\u003c/b\u003e\u003cdiv style=\"font-size:0.9em\"\u003eContinue to follow Aldwych\u003c/div\u003e\u003cdiv style=\"font-size:0.9em\"\u003eEntering toll zone\u003c/div\u003e",
                     "maneuver" : "turn-right",
                     "polyline" : {
                        "points" : "kelyHdxU@V@ZBVBNBTDVNt@J`@Ld@LXZh@V`@LPRRNJ@@JFHFPHNFH@PDN@J@F?B?ZMB?@ABA"
                     },
                     "start_location" : {
                        "lat" : 51.5133402,
                        "lng" : -0.1166735
                     },
                     "travel_mode" : "BICYCLING"
                  },
                  {
                     "distance" : {
                        "text" : "38 m",
                        "value" : 38
                     },
                     "duration" : {
                        "text" : "1 min",
                        "value" : 29
                     },
                     "end_location" : {
                        "lat" : 51.5113175,
                        "lng" : -0.1190993
                     },
                     "html_instructions" : "Turn \u003cb\u003eright\u003c/b\u003e onto \u003cb\u003eStrand\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eA4\u003c/b\u003e\u003cdiv style=\"font-size:0.9em\"\u003eLeaving toll zone\u003c/div\u003e\u003cdiv style=\"font-size:0.9em\"\u003eWalk your bicycle\u003c/div\u003e",
                     "maneuver" : "turn-right",
                     "polyline" : {
                        "points" : "szkyHbfVHAB?B?DBD@BBJHHLBF"
                     },
                     "start_location" : {
                        "lat" : 51.5116184,
                        "lng" : -0.1188994
                     },
                     "travel_mode" : "BICYCLING"
                  },
                  {
                     "distance" : {
                        "text" : "0.8 km",
                        "value" : 780
                     },
                     "duration" : {
                        "text" : "3 mins",
                        "value" : 165
                     },
                     "end_location" : {
                        "lat" : 51.5051624,
                        "lng" : -0.1137021
                     },
                     "html_instructions" : "Turn \u003cb\u003eleft\u003c/b\u003e onto \u003cb\u003eLancaster Pl\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eA301\u003c/b\u003e\u003cdiv style=\"font-size:0.9em\"\u003eContinue to follow A301\u003c/div\u003e",
                     "maneuver" : "turn-left",
                     "polyline" : {
                        "points" : "wxkyHjgVZUPKdAw@^WZWt@m@POVS\\[tAoAd@[tD_Dz@u@PShAcALKPORQ^[|@w@x@m@ROXUTSRQ^[LKh@e@JILKHIVWDGFIPQ"
                     },
                     "start_location" : {
                        "lat" : 51.5113175,
                        "lng" : -0.1190993
                     },
                     "travel_mode" : "BICYCLING"
                  },
                  {
                     "distance" : {
                        "text" : "0.2 km",
                        "value" : 182
                     },
                     "duration" : {
                        "text" : "1 min",
                        "value" : 38
                     },
                     "end_location" : {
                        "lat" : 51.5043292,
                        "lng" : -0.1144167
                     },
                     "html_instructions" : "At the roundabout, take the \u003cb\u003e4th\u003c/b\u003e exit onto \u003cb\u003eYork Rd\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eA3200\u003c/b\u003e",
                     "maneuver" : "roundabout-left",
                     "polyline" : {
                        "points" : "grjyHreU?MDY?ABQDOBE@EBCBCBCFELCb@?JDFBFF@B@@@D@B@B?D@FBHCPAV?T?V?V@F?F@B?BBDZp@"
                     },
                     "start_location" : {
                        "lat" : 51.5051624,
                        "lng" : -0.1137021
                     },
                     "travel_mode" : "BICYCLING"
                  },
                  {
                     "distance" : {
                        "text" : "0.1 km",
                        "value" : 127
                     },
                     "duration" : {
                        "text" : "1 min",
                        "value" : 19
                     },
                     "end_location" : {
                        "lat" : 51.503849,
                        "lng" : -0.1127984
                     },
                     "html_instructions" : "Turn \u003cb\u003eleft\u003c/b\u003e onto \u003cb\u003eMepham St\u003c/b\u003e\u003cdiv style=\"font-size:0.9em\"\u003eEntering toll zone\u003c/div\u003e\u003cdiv style=\"font-size:0.9em\"\u003eDestination will be on the right\u003c/div\u003e",
                     "maneuver" : "turn-left",
                     "polyline" : {
                        "points" : "amjyHbjUJKDEDIHYFa@XkBF[DYFc@@QBS"
                     },
                     "start_location" : {
                        "lat" : 51.5043292,
                        "lng" : -0.1144167
                     },
                     "travel_mode" : "BICYCLING"
                  }
               ],
               "traffic_speed_entry" : [],
               "via_waypoint" : []
            }
         ],
         "overview_polyline" : {
            "points" : "cglyHjxUv@E@VDr@\\rBXfAh@bAd@r@b@^h@ZXH`@FR@^MRERDNLLTrByAbCmBt@o@tAoAd@[pFuEzAwArAiAdDkCdDsCv@{@H{@N_@FGTIb@?JDNJDJDT?ZAl@@~@`@~@PQNc@n@cELiA"
         },
         "summary" : "A301",
         "warnings" : [
            "Bicycling directions are in beta. Use caution – This route may contain streets that aren't suited for bicycling."
         ],
         "waypoint_order" : []
      }
   ],
   "status" : "OK"
}

        """)["routes"][0] as Map<String, dynamic>, RouteType.bike);

  final route_3 = R.Route.fromJson(convert.jsonDecode(r"""
        {
   "geocoded_waypoints" : [
      {
         "geocoder_status" : "OK",
         "place_id" : "ChIJqR5M5rkEdkgRITVCkjoRm5Y",
         "types" : [ "street_address" ]
      },
      {
         "geocoder_status" : "OK",
         "place_id" : "ChIJHVKfwLkEdkgRyojcJB0Aejk",
         "types" : [ "premise" ]
      }
   ],
   "routes" : [
      {
         "bounds" : {
            "northeast" : {
               "lat" : 51.5037871,
               "lng" : -0.1124857
            },
            "southwest" : {
               "lat" : 51.5036225,
               "lng" : -0.1128278
            }
         },
         "copyrights" : "Map data ©2022 Google",
         "legs" : [
            {
               "distance" : {
                  "text" : "29 m",
                  "value" : 29
               },
               "duration" : {
                  "text" : "1 min",
                  "value" : 26
               },
               "end_address" : "Waterloo Station, London SE1 8SR, UK",
               "end_location" : {
                  "lat" : 51.5036225,
                  "lng" : -0.1124857
               },
               "start_address" : "15a Mepham St, London SE1 8SQ, UK",
               "start_location" : {
                  "lat" : 51.5037871,
                  "lng" : -0.1128278
               },
               "steps" : [
                  {
                     "distance" : {
                        "text" : "29 m",
                        "value" : 29
                     },
                     "duration" : {
                        "text" : "1 min",
                        "value" : 26
                     },
                     "end_location" : {
                        "lat" : 51.5036225,
                        "lng" : -0.1124857
                     },
                     "html_instructions" : "Head \u003cb\u003eeast\u003c/b\u003e on \u003cb\u003eCab Rd\u003c/b\u003e toward \u003cb\u003eCab Rd\u003c/b\u003e\u003cdiv style=\"font-size:0.9em\"\u003eDestination will be on the right\u003c/div\u003e",
                     "polyline" : {
                        "points" : "uijyHd`UBOBO@IBERS"
                     },
                     "start_location" : {
                        "lat" : 51.5037871,
                        "lng" : -0.1128278
                     },
                     "travel_mode" : "WALKING"
                  }
               ],
               "traffic_speed_entry" : [],
               "via_waypoint" : []
            }
         ],
         "overview_polyline" : {
            "points" : "uijyHd`UHi@VY"
         },
         "summary" : "Cab Rd",
         "warnings" : [
            "Walking directions are in beta. Use caution – This route may be missing sidewalks or pedestrian paths."
         ],
         "waypoint_order" : []
      }
   ],
   "status" : "OK"
}  
        """)["routes"][0] as Map<String, dynamic>, RouteType.walk);


  // ************ Helper functions ***************

  Place createPlace(String name, String id) {
    return Place(
        geometry: const Geometry.geometryNotFound(),
        name: name,
        placeId: id,
        description: "description");
  }

  setUp(() {
    routeManager.clear();
    directionManager.clear();
  });

  test('ensure that group size is 1 when initialized', () {
    expect(routeManager.getGroupSize(), 1);
  });

  test('ensure that group size can be set when needed', () {
    routeManager.setGroupSize(2);
    expect(routeManager.getGroupSize(), 2);
  });

  test('ensure optimised is true when initialized', () {
    expect(routeManager.ifOptimised(), true);
  });

  test('ensure optimised can be toggled when requested', () {
    routeManager.toggleOptimised();
    expect(routeManager.ifOptimised(), false);
  });

  test('ensure that start is empty when initialized', () {
    expect(routeManager.getStart().getStop(), const Place.placeNotFound());
  });

  test('ensure that destination is empty when initialized', () {
    expect(
        routeManager.getDestination().getStop(), const Place.placeNotFound());
  });

  test('ensure that waypoints are empty when initialized', () {
    expect(routeManager.getWaypoints().length, 0);
  });

  test('ensure that start is changed when requested', () {
    Place start = createPlace("start", "1");
    routeManager.changeStart(start);
    expect(routeManager.getStart().getStop(), start);
    expect(routeManager.getStart().getStop().placeId, "1");
    expect(routeManager.ifChanged(), true);
    expect(routeManager.ifStartSet(), true);
  });

  test("ensure stop can be changed",(){
     final stop = Stop(Place(geometry: const Geometry.geometryNotFound(), name: "stop_2", placeId: "placeId", description: "description"));

    routeManager.changeStop(routeManager.getStops().first.getUID(), stop.getStop());
    expect(routeManager.getStops().first.getStop().name, stop.getStop().name);
  });

  test('ensure that start can be cleared when requested', () {
    Place start = createPlace("start", "1");
    routeManager.changeStart(start);
    routeManager.clearStart();
    expect(routeManager.getStart().getStop(), const Place.placeNotFound());
    expect(routeManager.ifChanged(), true);
    expect(routeManager.ifStartSet(), false);
  });

  test('ensure that destination is changed when requested', () {
    Place end = createPlace("end", "1");
    routeManager.changeDestination(end);
    expect(routeManager.getDestination().getStop(), end);
    expect(routeManager.getDestination().getStop().placeId, "1");
    expect(routeManager.ifChanged(), true);
    expect(routeManager.ifDestinationSet(), true);
  });

  test('ensure that destination can be cleared when requested', () {
    Place end = createPlace("end", "1");
    routeManager.changeDestination(end);
    routeManager.clearDestination();
    expect(
        routeManager.getDestination().getStop(), const Place.placeNotFound());
    expect(routeManager.ifDestinationSet(), false);
  });

  test('ensure that can add waypoint when requested', () {
    expect(routeManager.getWaypoints().length, 0);
    routeManager.addWaypoint(const Place.placeNotFound());
    expect(routeManager.getWaypoints().length, 1);
    expect(routeManager.ifWaypointsSet(), true);
  });

  test("Ensure start can be added",(){
    expect(routeManager.getStart().getStop(),const Place.placeNotFound());
    expect(routeManager.ifStartSet(), false);
    routeManager.changeStart(Place(geometry: const Geometry.geometryNotFound(), name: "something", placeId: "placeId", description: "description"));
    expect(routeManager.getStart().getStop().name, "something");
    expect(routeManager.ifStartSet(), true);
  });

  test("Ensure first waypoint can be set",(){
    expect(routeManager.ifFirstWaypointSet(), false);
    expect(routeManager.getFirstWaypoint().getStop().name,Place.placeNotFound().name);

    final waypoint = Place(geometry: Geometry.geometryNotFound(), name: "Something", placeId: "placeId", description: "description");
    routeManager.addFirstWaypoint(waypoint);

    expect(routeManager.ifFirstWaypointSet(), true);
    expect(routeManager.getFirstWaypoint().getStop().name,"Something");

  });

  test(
      'ensure that number of waypoints do not changed when existing id is changed',
      () {
    Stop waypoint = routeManager.addWaypoint(const Place.placeNotFound());
    expect(routeManager.getWaypoints().length, 1);
    Place place = createPlace("waypoint", "1");
    routeManager.changeStop(waypoint.getUID(), place);
    expect(routeManager.getWaypoints().length, 1);
  });

  test('ensure can clear waypoint using id', () {
    Place place = createPlace("waypoint", "1");
    Stop waypoint = routeManager.addWaypoint(place);
    expect(routeManager.getWaypoints().length, 1);
    routeManager.clearStop(waypoint.getUID());
    expect(routeManager.getStop(waypoint.getUID()).getStop(),
        const Place.placeNotFound());
    expect(routeManager.getWaypoints().length, 1);
  });

  test('ensure can remove waypoint using id', () {
    Place place = createPlace("waypoint", "1");
    Stop waypoint = routeManager.addWaypoint(place);
    expect(routeManager.getWaypoints().length, 1);
    routeManager.removeStop(waypoint.getUID());
    expect(routeManager.getWaypoints().length, 0);
  });

  test('ensure can clear waypoints when requested', () {
    routeManager.addWaypoint(const Place.placeNotFound());
    routeManager.addWaypoint(const Place.placeNotFound());
    routeManager.addWaypoint(const Place.placeNotFound());
    expect(routeManager.getWaypoints().length, 3);
    routeManager.removeWaypoints();
    expect(routeManager.getWaypoints().length, 0);
  });

  test('ensure clear changed clears changes', () {
    routeManager.changeStart(const Place.placeNotFound());
    expect(routeManager.ifChanged(), true);
    routeManager.clearChanged();
    expect(routeManager.ifChanged(), false);
  });

  test("ensure clear first waypoint works",(){
    final waypoint = Place(geometry: Geometry.geometryNotFound(), name: "name", placeId: "placeId", description: "description");
    routeManager.addFirstWaypoint(waypoint);
    expect(routeManager.ifFirstWaypointSet(), true);
    routeManager.clearFirstWaypoint();
    expect(routeManager.ifFirstWaypointSet(),false);
  });

  test('ensure route manager initialises correctly', () {
    expect(routeManager.ifStartFromCurrentLocation(), false);
    expect(routeManager.ifWalkToFirstWaypoint(), false);
    expect(routeManager.ifOptimised(), true);
    expect(routeManager.getStartWalkingRoute(), R.Route.routeNotFound());
    expect(routeManager.getBikingRoute(), R.Route.routeNotFound());
    expect(routeManager.getEndWalkingRoute(), R.Route.routeNotFound());
  });

  test('ensure route manager sets routes correctly', () {
    final route_1 = R.Route.fromJson(convert.jsonDecode(r"""
       {
   "geocoded_waypoints" : [
      {
         "geocoder_status" : "OK",
         "place_id" : "ChIJ__8_fLUEdkgRXd3d1TaO8nw",
         "types" : [ "establishment", "point_of_interest", "university" ]
      },
      {
         "geocoder_status" : "OK",
         "place_id" : "ChIJDewcaLUEdkgRByjdEk9z704",
         "types" : [ "street_address" ]
      }
   ],
   "routes" : [
      {
         "bounds" : {
            "northeast" : {
               "lat" : 51.5136215,
               "lng" : -0.1128304
            },
            "southwest" : {
               "lat" : 51.5128475,
               "lng" : -0.1174349
            }
         },
         "copyrights" : "Map data ©2022 Google",
         "legs" : [
            {
               "distance" : {
                  "text" : "0.7 km",
                  "value" : 690
               },
               "duration" : {
                  "text" : "9 mins",
                  "value" : 524
               },
               "end_address" : "58 Houghton St, London WC2B 4RR, UK",
               "end_location" : {
                  "lat" : 51.5136215,
                  "lng" : -0.1166481
               },
               "start_address" : "30 Aldwych, London WC2B 4BG, UK",
               "start_location" : {
                  "lat" : 51.513074,
                  "lng" : -0.1174349
               },
               "steps" : [
                  {
                     "distance" : {
                        "text" : "0.2 km",
                        "value" : 204
                     },
                     "duration" : {
                        "text" : "2 mins",
                        "value" : 141
                     },
                     "end_location" : {
                        "lat" : 51.5130335,
                        "lng" : -0.114607
                     },
                     "html_instructions" : "Head \u003cb\u003enortheast\u003c/b\u003e on \u003cb\u003eAldwych\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eA4\u003c/b\u003e toward \u003cb\u003eKingsway\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eA4200\u003c/b\u003e\u003cdiv style=\"font-size:0.9em\"\u003eContinue to follow Aldwych\u003c/div\u003e",
                     "polyline" : {
                        "points" : "uclyH||UCKG_@?AE[CMAUCW?EIo@?_@@_@@IH[BWFc@Jk@F_@\\q@@GBCc@kA"
                     },
                     "start_location" : {
                        "lat" : 51.513074,
                        "lng" : -0.1174349
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
                        "value" : 27
                     },
                     "end_location" : {
                        "lat" : 51.51307600000001,
                        "lng" : -0.1146608
                     },
                     "html_instructions" : "Cross the road",
                     "polyline" : {
                        "points" : "mclyHhkUIH"
                     },
                     "start_location" : {
                        "lat" : 51.5130335,
                        "lng" : -0.114607
                     },
                     "travel_mode" : "WALKING"
                  },
                  {
                     "distance" : {
                        "text" : "0.2 km",
                        "value" : 156
                     },
                     "duration" : {
                        "text" : "2 mins",
                        "value" : 109
                     },
                     "end_location" : {
                        "lat" : 51.51348489999999,
                        "lng" : -0.1128304
                     },
                     "html_instructions" : "Turn \u003cb\u003eright\u003c/b\u003e onto \u003cb\u003eStrand\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eA4\u003c/b\u003e",
                     "maneuver" : "turn-right",
                     "polyline" : {
                        "points" : "wclyHrkUG}@KWCKMeAK_ASeB?IIU"
                     },
                     "start_location" : {
                        "lat" : 51.51307600000001,
                        "lng" : -0.1146608
                     },
                     "travel_mode" : "WALKING"
                  },
                  {
                     "distance" : {
                        "text" : "0.3 km",
                        "value" : 277
                     },
                     "duration" : {
                        "text" : "4 mins",
                        "value" : 224
                     },
                     "end_location" : {
                        "lat" : 51.5134052,
                        "lng" : -0.11663
                     },
                     "html_instructions" : "Cross the road\u003cdiv style=\"font-size:0.9em\"\u003eContinue to follow A4\u003c/div\u003e",
                     "polyline" : {
                        "points" : "gflyHd`UCT?H@HR`BFj@@ZJfAHNDNJjAEZGb@Mn@Id@Gj@ET@z@AZAf@?V"
                     },
                     "start_location" : {
                        "lat" : 51.51348489999999,
                        "lng" : -0.1128304
                     },
                     "travel_mode" : "WALKING"
                  },
                  {
                     "distance" : {
                        "text" : "31 m",
                        "value" : 31
                     },
                     "duration" : {
                        "text" : "1 min",
                        "value" : 23
                     },
                     "end_location" : {
                        "lat" : 51.5136215,
                        "lng" : -0.1166481
                     },
                     "html_instructions" : "Turn \u003cb\u003eright\u003c/b\u003e onto \u003cb\u003eHoughton St\u003c/b\u003e\u003cdiv style=\"font-size:0.9em\"\u003eDestination will be on the left\u003c/div\u003e",
                     "maneuver" : "turn-right",
                     "polyline" : {
                        "points" : "yelyH|wUi@B"
                     },
                     "start_location" : {
                        "lat" : 51.5134052,
                        "lng" : -0.11663
                     },
                     "travel_mode" : "WALKING"
                  }
               ],
               "traffic_speed_entry" : [],
               "via_waypoint" : []
            }
         ],
         "overview_polyline" : {
            "points" : "uclyH||UQiAIaAIo@?_@Bi@Ls@RoAF_@\\q@DKc@kAIHG}@KWQqA_@eDI_@C^TjBHfAJfAHNDNJjAM~@WtAM`A?vAA~@i@B"
         },
         "summary" : "Aldwych and A4",
         "warnings" : [
            "Walking directions are in beta. Use caution – This route may be missing sidewalks or pedestrian paths."
         ],
         "waypoint_order" : []
      }
   ],
   "status" : "OK"
}

        """)["routes"][0] as Map<String, dynamic>, RouteType.walk);

    final route_2 = R.Route.fromJson(convert.jsonDecode(r"""
{
   "geocoded_waypoints" : [
      {
         "geocoder_status" : "OK",
         "place_id" : "ChIJDewcaLUEdkgRByjdEk9z704",
         "types" : [ "street_address" ]
      },
      {
         "geocoder_status" : "OK",
         "place_id" : "ChIJqR5M5rkEdkgRITVCkjoRm5Y",
         "types" : [ "street_address" ]
      }
   ],
   "routes" : [
      {
         "bounds" : {
            "northeast" : {
               "lat" : 51.5136199,
               "lng" : -0.1127984
            },
            "southwest" : {
               "lat" : 51.503849,
               "lng" : -0.1190993
            }
         },
         "copyrights" : "Map data ©2022",
         "legs" : [
            {
               "distance" : {
                  "text" : "1.4 km",
                  "value" : 1436
               },
               "duration" : {
                  "text" : "6 mins",
                  "value" : 378
               },
               "end_address" : "15a Mepham St, London SE1 8SQ, UK",
               "end_location" : {
                  "lat" : 51.503849,
                  "lng" : -0.1127984
               },
               "start_address" : "58 Houghton St, London WC2B 4RR, UK",
               "start_location" : {
                  "lat" : 51.5136199,
                  "lng" : -0.1166969
               },
               "steps" : [
                  {
                     "distance" : {
                        "text" : "31 m",
                        "value" : 31
                     },
                     "duration" : {
                        "text" : "1 min",
                        "value" : 4
                     },
                     "end_location" : {
                        "lat" : 51.5133402,
                        "lng" : -0.1166735
                     },
                     "html_instructions" : "Head \u003cb\u003esouth\u003c/b\u003e on \u003cb\u003eHoughton St\u003c/b\u003e toward \u003cb\u003eAldwych\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eA4\u003c/b\u003e",
                     "polyline" : {
                        "points" : "cglyHjxUv@E"
                     },
                     "start_location" : {
                        "lat" : 51.5136199,
                        "lng" : -0.1166969
                     },
                     "travel_mode" : "BICYCLING"
                  },
                  {
                     "distance" : {
                        "text" : "0.3 km",
                        "value" : 278
                     },
                     "duration" : {
                        "text" : "2 mins",
                        "value" : 123
                     },
                     "end_location" : {
                        "lat" : 51.5116184,
                        "lng" : -0.1188994
                     },
                     "html_instructions" : "Turn \u003cb\u003eright\u003c/b\u003e onto \u003cb\u003eAldwych\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eA4\u003c/b\u003e\u003cdiv style=\"font-size:0.9em\"\u003eContinue to follow Aldwych\u003c/div\u003e\u003cdiv style=\"font-size:0.9em\"\u003eEntering toll zone\u003c/div\u003e",
                     "maneuver" : "turn-right",
                     "polyline" : {
                        "points" : "kelyHdxU@V@ZBVBNBTDVNt@J`@Ld@LXZh@V`@LPRRNJ@@JFHFPHNFH@PDN@J@F?B?ZMB?@ABA"
                     },
                     "start_location" : {
                        "lat" : 51.5133402,
                        "lng" : -0.1166735
                     },
                     "travel_mode" : "BICYCLING"
                  },
                  {
                     "distance" : {
                        "text" : "38 m",
                        "value" : 38
                     },
                     "duration" : {
                        "text" : "1 min",
                        "value" : 29
                     },
                     "end_location" : {
                        "lat" : 51.5113175,
                        "lng" : -0.1190993
                     },
                     "html_instructions" : "Turn \u003cb\u003eright\u003c/b\u003e onto \u003cb\u003eStrand\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eA4\u003c/b\u003e\u003cdiv style=\"font-size:0.9em\"\u003eLeaving toll zone\u003c/div\u003e\u003cdiv style=\"font-size:0.9em\"\u003eWalk your bicycle\u003c/div\u003e",
                     "maneuver" : "turn-right",
                     "polyline" : {
                        "points" : "szkyHbfVHAB?B?DBD@BBJHHLBF"
                     },
                     "start_location" : {
                        "lat" : 51.5116184,
                        "lng" : -0.1188994
                     },
                     "travel_mode" : "BICYCLING"
                  },
                  {
                     "distance" : {
                        "text" : "0.8 km",
                        "value" : 780
                     },
                     "duration" : {
                        "text" : "3 mins",
                        "value" : 165
                     },
                     "end_location" : {
                        "lat" : 51.5051624,
                        "lng" : -0.1137021
                     },
                     "html_instructions" : "Turn \u003cb\u003eleft\u003c/b\u003e onto \u003cb\u003eLancaster Pl\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eA301\u003c/b\u003e\u003cdiv style=\"font-size:0.9em\"\u003eContinue to follow A301\u003c/div\u003e",
                     "maneuver" : "turn-left",
                     "polyline" : {
                        "points" : "wxkyHjgVZUPKdAw@^WZWt@m@POVS\\[tAoAd@[tD_Dz@u@PShAcALKPORQ^[|@w@x@m@ROXUTSRQ^[LKh@e@JILKHIVWDGFIPQ"
                     },
                     "start_location" : {
                        "lat" : 51.5113175,
                        "lng" : -0.1190993
                     },
                     "travel_mode" : "BICYCLING"
                  },
                  {
                     "distance" : {
                        "text" : "0.2 km",
                        "value" : 182
                     },
                     "duration" : {
                        "text" : "1 min",
                        "value" : 38
                     },
                     "end_location" : {
                        "lat" : 51.5043292,
                        "lng" : -0.1144167
                     },
                     "html_instructions" : "At the roundabout, take the \u003cb\u003e4th\u003c/b\u003e exit onto \u003cb\u003eYork Rd\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eA3200\u003c/b\u003e",
                     "maneuver" : "roundabout-left",
                     "polyline" : {
                        "points" : "grjyHreU?MDY?ABQDOBE@EBCBCBCFELCb@?JDFBFF@B@@@D@B@B?D@FBHCPAV?T?V?V@F?F@B?BBDZp@"
                     },
                     "start_location" : {
                        "lat" : 51.5051624,
                        "lng" : -0.1137021
                     },
                     "travel_mode" : "BICYCLING"
                  },
                  {
                     "distance" : {
                        "text" : "0.1 km",
                        "value" : 127
                     },
                     "duration" : {
                        "text" : "1 min",
                        "value" : 19
                     },
                     "end_location" : {
                        "lat" : 51.503849,
                        "lng" : -0.1127984
                     },
                     "html_instructions" : "Turn \u003cb\u003eleft\u003c/b\u003e onto \u003cb\u003eMepham St\u003c/b\u003e\u003cdiv style=\"font-size:0.9em\"\u003eEntering toll zone\u003c/div\u003e\u003cdiv style=\"font-size:0.9em\"\u003eDestination will be on the right\u003c/div\u003e",
                     "maneuver" : "turn-left",
                     "polyline" : {
                        "points" : "amjyHbjUJKDEDIHYFa@XkBF[DYFc@@QBS"
                     },
                     "start_location" : {
                        "lat" : 51.5043292,
                        "lng" : -0.1144167
                     },
                     "travel_mode" : "BICYCLING"
                  }
               ],
               "traffic_speed_entry" : [],
               "via_waypoint" : []
            }
         ],
         "overview_polyline" : {
            "points" : "cglyHjxUv@E@VDr@\\rBXfAh@bAd@r@b@^h@ZXH`@FR@^MRERDNLLTrByAbCmBt@o@tAoAd@[pFuEzAwArAiAdDkCdDsCv@{@H{@N_@FGTIb@?JDNJDJDT?ZAl@@~@`@~@PQNc@n@cELiA"
         },
         "summary" : "A301",
         "warnings" : [
            "Bicycling directions are in beta. Use caution – This route may contain streets that aren't suited for bicycling."
         ],
         "waypoint_order" : []
      }
   ],
   "status" : "OK"
}

        """)["routes"][0] as Map<String, dynamic>, RouteType.bike);

    final route_3 = R.Route.fromJson(convert.jsonDecode(r"""
        {
   "geocoded_waypoints" : [
      {
         "geocoder_status" : "OK",
         "place_id" : "ChIJqR5M5rkEdkgRITVCkjoRm5Y",
         "types" : [ "street_address" ]
      },
      {
         "geocoder_status" : "OK",
         "place_id" : "ChIJHVKfwLkEdkgRyojcJB0Aejk",
         "types" : [ "premise" ]
      }
   ],
   "routes" : [
      {
         "bounds" : {
            "northeast" : {
               "lat" : 51.5037871,
               "lng" : -0.1124857
            },
            "southwest" : {
               "lat" : 51.5036225,
               "lng" : -0.1128278
            }
         },
         "copyrights" : "Map data ©2022 Google",
         "legs" : [
            {
               "distance" : {
                  "text" : "29 m",
                  "value" : 29
               },
               "duration" : {
                  "text" : "1 min",
                  "value" : 26
               },
               "end_address" : "Waterloo Station, London SE1 8SR, UK",
               "end_location" : {
                  "lat" : 51.5036225,
                  "lng" : -0.1124857
               },
               "start_address" : "15a Mepham St, London SE1 8SQ, UK",
               "start_location" : {
                  "lat" : 51.5037871,
                  "lng" : -0.1128278
               },
               "steps" : [
                  {
                     "distance" : {
                        "text" : "29 m",
                        "value" : 29
                     },
                     "duration" : {
                        "text" : "1 min",
                        "value" : 26
                     },
                     "end_location" : {
                        "lat" : 51.5036225,
                        "lng" : -0.1124857
                     },
                     "html_instructions" : "Head \u003cb\u003eeast\u003c/b\u003e on \u003cb\u003eCab Rd\u003c/b\u003e toward \u003cb\u003eCab Rd\u003c/b\u003e\u003cdiv style=\"font-size:0.9em\"\u003eDestination will be on the right\u003c/div\u003e",
                     "polyline" : {
                        "points" : "uijyHd`UBOBO@IBERS"
                     },
                     "start_location" : {
                        "lat" : 51.5037871,
                        "lng" : -0.1128278
                     },
                     "travel_mode" : "WALKING"
                  }
               ],
               "traffic_speed_entry" : [],
               "via_waypoint" : []
            }
         ],
         "overview_polyline" : {
            "points" : "uijyHd`UHi@VY"
         },
         "summary" : "Cab Rd",
         "warnings" : [
            "Walking directions are in beta. Use caution – This route may be missing sidewalks or pedestrian paths."
         ],
         "waypoint_order" : []
      }
   ],
   "status" : "OK"
}  
        """)["routes"][0] as Map<String, dynamic>, RouteType.walk);

    expect(routeManager.ifRouteSet(), false);
    routeManager.setRoutes(route_1, route_2, route_3);
    expect(routeManager.ifRouteSet(), true);
  });


  test("Set optimised",(){
    routeManager.setOptimised(false);
    expect(routeManager.ifOptimised(), false);
    routeManager.setOptimised(true);
    expect(routeManager.ifOptimised(), true);
  });

  test("Set directions data", () {
    final route = R.Route.fromJson(convert.jsonDecode(r"""
{
   "geocoded_waypoints" : [
      {
         "geocoder_status" : "OK",
         "place_id" : "ChIJDewcaLUEdkgRByjdEk9z704",
         "types" : [ "street_address" ]
      },
      {
         "geocoder_status" : "OK",
         "place_id" : "ChIJqR5M5rkEdkgRITVCkjoRm5Y",
         "types" : [ "street_address" ]
      }
   ],
   "routes" : [
      {
         "bounds" : {
            "northeast" : {
               "lat" : 51.5136199,
               "lng" : -0.1127984
            },
            "southwest" : {
               "lat" : 51.503849,
               "lng" : -0.1190993
            }
         },
         "copyrights" : "Map data ©2022",
         "legs" : [
            {
               "distance" : {
                  "text" : "1.4 km",
                  "value" : 1436
               },
               "duration" : {
                  "text" : "6 mins",
                  "value" : 378
               },
               "end_address" : "15a Mepham St, London SE1 8SQ, UK",
               "end_location" : {
                  "lat" : 51.503849,
                  "lng" : -0.1127984
               },
               "start_address" : "58 Houghton St, London WC2B 4RR, UK",
               "start_location" : {
                  "lat" : 51.5136199,
                  "lng" : -0.1166969
               },
               "steps" : [
                  {
                     "distance" : {
                        "text" : "31 m",
                        "value" : 31
                     },
                     "duration" : {
                        "text" : "1 min",
                        "value" : 4
                     },
                     "end_location" : {
                        "lat" : 51.5133402,
                        "lng" : -0.1166735
                     },
                     "html_instructions" : "Head \u003cb\u003esouth\u003c/b\u003e on \u003cb\u003eHoughton St\u003c/b\u003e toward \u003cb\u003eAldwych\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eA4\u003c/b\u003e",
                     "polyline" : {
                        "points" : "cglyHjxUv@E"
                     },
                     "start_location" : {
                        "lat" : 51.5136199,
                        "lng" : -0.1166969
                     },
                     "travel_mode" : "BICYCLING"
                  },
                  {
                     "distance" : {
                        "text" : "0.3 km",
                        "value" : 278
                     },
                     "duration" : {
                        "text" : "2 mins",
                        "value" : 123
                     },
                     "end_location" : {
                        "lat" : 51.5116184,
                        "lng" : -0.1188994
                     },
                     "html_instructions" : "Turn \u003cb\u003eright\u003c/b\u003e onto \u003cb\u003eAldwych\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eA4\u003c/b\u003e\u003cdiv style=\"font-size:0.9em\"\u003eContinue to follow Aldwych\u003c/div\u003e\u003cdiv style=\"font-size:0.9em\"\u003eEntering toll zone\u003c/div\u003e",
                     "maneuver" : "turn-right",
                     "polyline" : {
                        "points" : "kelyHdxU@V@ZBVBNBTDVNt@J`@Ld@LXZh@V`@LPRRNJ@@JFHFPHNFH@PDN@J@F?B?ZMB?@ABA"
                     },
                     "start_location" : {
                        "lat" : 51.5133402,
                        "lng" : -0.1166735
                     },
                     "travel_mode" : "BICYCLING"
                  },
                  {
                     "distance" : {
                        "text" : "38 m",
                        "value" : 38
                     },
                     "duration" : {
                        "text" : "1 min",
                        "value" : 29
                     },
                     "end_location" : {
                        "lat" : 51.5113175,
                        "lng" : -0.1190993
                     },
                     "html_instructions" : "Turn \u003cb\u003eright\u003c/b\u003e onto \u003cb\u003eStrand\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eA4\u003c/b\u003e\u003cdiv style=\"font-size:0.9em\"\u003eLeaving toll zone\u003c/div\u003e\u003cdiv style=\"font-size:0.9em\"\u003eWalk your bicycle\u003c/div\u003e",
                     "maneuver" : "turn-right",
                     "polyline" : {
                        "points" : "szkyHbfVHAB?B?DBD@BBJHHLBF"
                     },
                     "start_location" : {
                        "lat" : 51.5116184,
                        "lng" : -0.1188994
                     },
                     "travel_mode" : "BICYCLING"
                  },
                  {
                     "distance" : {
                        "text" : "0.8 km",
                        "value" : 780
                     },
                     "duration" : {
                        "text" : "3 mins",
                        "value" : 165
                     },
                     "end_location" : {
                        "lat" : 51.5051624,
                        "lng" : -0.1137021
                     },
                     "html_instructions" : "Turn \u003cb\u003eleft\u003c/b\u003e onto \u003cb\u003eLancaster Pl\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eA301\u003c/b\u003e\u003cdiv style=\"font-size:0.9em\"\u003eContinue to follow A301\u003c/div\u003e",
                     "maneuver" : "turn-left",
                     "polyline" : {
                        "points" : "wxkyHjgVZUPKdAw@^WZWt@m@POVS\\[tAoAd@[tD_Dz@u@PShAcALKPORQ^[|@w@x@m@ROXUTSRQ^[LKh@e@JILKHIVWDGFIPQ"
                     },
                     "start_location" : {
                        "lat" : 51.5113175,
                        "lng" : -0.1190993
                     },
                     "travel_mode" : "BICYCLING"
                  },
                  {
                     "distance" : {
                        "text" : "0.2 km",
                        "value" : 182
                     },
                     "duration" : {
                        "text" : "1 min",
                        "value" : 38
                     },
                     "end_location" : {
                        "lat" : 51.5043292,
                        "lng" : -0.1144167
                     },
                     "html_instructions" : "At the roundabout, take the \u003cb\u003e4th\u003c/b\u003e exit onto \u003cb\u003eYork Rd\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eA3200\u003c/b\u003e",
                     "maneuver" : "roundabout-left",
                     "polyline" : {
                        "points" : "grjyHreU?MDY?ABQDOBE@EBCBCBCFELCb@?JDFBFF@B@@@D@B@B?D@FBHCPAV?T?V?V@F?F@B?BBDZp@"
                     },
                     "start_location" : {
                        "lat" : 51.5051624,
                        "lng" : -0.1137021
                     },
                     "travel_mode" : "BICYCLING"
                  },
                  {
                     "distance" : {
                        "text" : "0.1 km",
                        "value" : 127
                     },
                     "duration" : {
                        "text" : "1 min",
                        "value" : 19
                     },
                     "end_location" : {
                        "lat" : 51.503849,
                        "lng" : -0.1127984
                     },
                     "html_instructions" : "Turn \u003cb\u003eleft\u003c/b\u003e onto \u003cb\u003eMepham St\u003c/b\u003e\u003cdiv style=\"font-size:0.9em\"\u003eEntering toll zone\u003c/div\u003e\u003cdiv style=\"font-size:0.9em\"\u003eDestination will be on the right\u003c/div\u003e",
                     "maneuver" : "turn-left",
                     "polyline" : {
                        "points" : "amjyHbjUJKDEDIHYFa@XkBF[DYFc@@QBS"
                     },
                     "start_location" : {
                        "lat" : 51.5043292,
                        "lng" : -0.1144167
                     },
                     "travel_mode" : "BICYCLING"
                  }
               ],
               "traffic_speed_entry" : [],
               "via_waypoint" : []
            }
         ],
         "overview_polyline" : {
            "points" : "cglyHjxUv@E@VDr@\\rBXfAh@bAd@r@b@^h@ZXH`@FR@^MRERDNLLTrByAbCmBt@o@tAoAd@[pFuEzAwArAiAdDkCdDsCv@{@H{@N_@FGTIb@?JDNJDJDT?ZAl@@~@`@~@PQNc@n@cELiA"
         },
         "summary" : "A301",
         "warnings" : [
            "Bicycling directions are in beta. Use caution – This route may contain streets that aren't suited for bicycling."
         ],
         "waypoint_order" : []
      }
   ],
   "status" : "OK"
}

        """)["routes"][0] as Map<String, dynamic>, RouteType.bike);

    routeManager.setDirectionsData(route);

    Steps x = directionManager.getCurrentDirection();

    List<Steps> listSteps = [];
    listSteps.addAll(route.directions);
    expect(x, route.directions.first);

    listSteps.removeAt(0);
    expect(directionManager.getDirections(), listSteps);
    expect(directionManager.getDistance(),
        DistanceType.miles.convert(1436).ceil().toString() + " mi");
    expect(directionManager.getDuration(), "7 min");
  });

  test("Set current route", () {
    final route = R.Route.fromJson(convert.jsonDecode(r"""
{
   "geocoded_waypoints" : [
      {
         "geocoder_status" : "OK",
         "place_id" : "ChIJDewcaLUEdkgRByjdEk9z704",
         "types" : [ "street_address" ]
      },
      {
         "geocoder_status" : "OK",
         "place_id" : "ChIJqR5M5rkEdkgRITVCkjoRm5Y",
         "types" : [ "street_address" ]
      }
   ],
   "routes" : [
      {
         "bounds" : {
            "northeast" : {
               "lat" : 51.5136199,
               "lng" : -0.1127984
            },
            "southwest" : {
               "lat" : 51.503849,
               "lng" : -0.1190993
            }
         },
         "copyrights" : "Map data ©2022",
         "legs" : [
            {
               "distance" : {
                  "text" : "1.4 km",
                  "value" : 1436
               },
               "duration" : {
                  "text" : "6 mins",
                  "value" : 378
               },
               "end_address" : "15a Mepham St, London SE1 8SQ, UK",
               "end_location" : {
                  "lat" : 51.503849,
                  "lng" : -0.1127984
               },
               "start_address" : "58 Houghton St, London WC2B 4RR, UK",
               "start_location" : {
                  "lat" : 51.5136199,
                  "lng" : -0.1166969
               },
               "steps" : [
                  {
                     "distance" : {
                        "text" : "31 m",
                        "value" : 31
                     },
                     "duration" : {
                        "text" : "1 min",
                        "value" : 4
                     },
                     "end_location" : {
                        "lat" : 51.5133402,
                        "lng" : -0.1166735
                     },
                     "html_instructions" : "Head \u003cb\u003esouth\u003c/b\u003e on \u003cb\u003eHoughton St\u003c/b\u003e toward \u003cb\u003eAldwych\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eA4\u003c/b\u003e",
                     "polyline" : {
                        "points" : "cglyHjxUv@E"
                     },
                     "start_location" : {
                        "lat" : 51.5136199,
                        "lng" : -0.1166969
                     },
                     "travel_mode" : "BICYCLING"
                  },
                  {
                     "distance" : {
                        "text" : "0.3 km",
                        "value" : 278
                     },
                     "duration" : {
                        "text" : "2 mins",
                        "value" : 123
                     },
                     "end_location" : {
                        "lat" : 51.5116184,
                        "lng" : -0.1188994
                     },
                     "html_instructions" : "Turn \u003cb\u003eright\u003c/b\u003e onto \u003cb\u003eAldwych\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eA4\u003c/b\u003e\u003cdiv style=\"font-size:0.9em\"\u003eContinue to follow Aldwych\u003c/div\u003e\u003cdiv style=\"font-size:0.9em\"\u003eEntering toll zone\u003c/div\u003e",
                     "maneuver" : "turn-right",
                     "polyline" : {
                        "points" : "kelyHdxU@V@ZBVBNBTDVNt@J`@Ld@LXZh@V`@LPRRNJ@@JFHFPHNFH@PDN@J@F?B?ZMB?@ABA"
                     },
                     "start_location" : {
                        "lat" : 51.5133402,
                        "lng" : -0.1166735
                     },
                     "travel_mode" : "BICYCLING"
                  },
                  {
                     "distance" : {
                        "text" : "38 m",
                        "value" : 38
                     },
                     "duration" : {
                        "text" : "1 min",
                        "value" : 29
                     },
                     "end_location" : {
                        "lat" : 51.5113175,
                        "lng" : -0.1190993
                     },
                     "html_instructions" : "Turn \u003cb\u003eright\u003c/b\u003e onto \u003cb\u003eStrand\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eA4\u003c/b\u003e\u003cdiv style=\"font-size:0.9em\"\u003eLeaving toll zone\u003c/div\u003e\u003cdiv style=\"font-size:0.9em\"\u003eWalk your bicycle\u003c/div\u003e",
                     "maneuver" : "turn-right",
                     "polyline" : {
                        "points" : "szkyHbfVHAB?B?DBD@BBJHHLBF"
                     },
                     "start_location" : {
                        "lat" : 51.5116184,
                        "lng" : -0.1188994
                     },
                     "travel_mode" : "BICYCLING"
                  },
                  {
                     "distance" : {
                        "text" : "0.8 km",
                        "value" : 780
                     },
                     "duration" : {
                        "text" : "3 mins",
                        "value" : 165
                     },
                     "end_location" : {
                        "lat" : 51.5051624,
                        "lng" : -0.1137021
                     },
                     "html_instructions" : "Turn \u003cb\u003eleft\u003c/b\u003e onto \u003cb\u003eLancaster Pl\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eA301\u003c/b\u003e\u003cdiv style=\"font-size:0.9em\"\u003eContinue to follow A301\u003c/div\u003e",
                     "maneuver" : "turn-left",
                     "polyline" : {
                        "points" : "wxkyHjgVZUPKdAw@^WZWt@m@POVS\\[tAoAd@[tD_Dz@u@PShAcALKPORQ^[|@w@x@m@ROXUTSRQ^[LKh@e@JILKHIVWDGFIPQ"
                     },
                     "start_location" : {
                        "lat" : 51.5113175,
                        "lng" : -0.1190993
                     },
                     "travel_mode" : "BICYCLING"
                  },
                  {
                     "distance" : {
                        "text" : "0.2 km",
                        "value" : 182
                     },
                     "duration" : {
                        "text" : "1 min",
                        "value" : 38
                     },
                     "end_location" : {
                        "lat" : 51.5043292,
                        "lng" : -0.1144167
                     },
                     "html_instructions" : "At the roundabout, take the \u003cb\u003e4th\u003c/b\u003e exit onto \u003cb\u003eYork Rd\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eA3200\u003c/b\u003e",
                     "maneuver" : "roundabout-left",
                     "polyline" : {
                        "points" : "grjyHreU?MDY?ABQDOBE@EBCBCBCFELCb@?JDFBFF@B@@@D@B@B?D@FBHCPAV?T?V?V@F?F@B?BBDZp@"
                     },
                     "start_location" : {
                        "lat" : 51.5051624,
                        "lng" : -0.1137021
                     },
                     "travel_mode" : "BICYCLING"
                  },
                  {
                     "distance" : {
                        "text" : "0.1 km",
                        "value" : 127
                     },
                     "duration" : {
                        "text" : "1 min",
                        "value" : 19
                     },
                     "end_location" : {
                        "lat" : 51.503849,
                        "lng" : -0.1127984
                     },
                     "html_instructions" : "Turn \u003cb\u003eleft\u003c/b\u003e onto \u003cb\u003eMepham St\u003c/b\u003e\u003cdiv style=\"font-size:0.9em\"\u003eEntering toll zone\u003c/div\u003e\u003cdiv style=\"font-size:0.9em\"\u003eDestination will be on the right\u003c/div\u003e",
                     "maneuver" : "turn-left",
                     "polyline" : {
                        "points" : "amjyHbjUJKDEDIHYFa@XkBF[DYFc@@QBS"
                     },
                     "start_location" : {
                        "lat" : 51.5043292,
                        "lng" : -0.1144167
                     },
                     "travel_mode" : "BICYCLING"
                  }
               ],
               "traffic_speed_entry" : [],
               "via_waypoint" : []
            }
         ],
         "overview_polyline" : {
            "points" : "cglyHjxUv@E@VDr@\\rBXfAh@bAd@r@b@^h@ZXH`@FR@^MRERDNLLTrByAbCmBt@o@tAoAd@[pFuEzAwArAiAdDkCdDsCv@{@H{@N_@FGTIb@?JDNJDJDT?ZAl@@~@`@~@PQNc@n@cELiA"
         },
         "summary" : "A301",
         "warnings" : [
            "Bicycling directions are in beta. Use caution – This route may contain streets that aren't suited for bicycling."
         ],
         "waypoint_order" : []
      }
   ],
   "status" : "OK"
}

        """)["routes"][0] as Map<String, dynamic>, RouteType.bike);

    routeManager.setCurrentRoute(route, false);

    final polylineManager = PolylineManager();

    List<LatLng> listLatLng = [];
    for (Polyline polyline in polylineManager.getPolyLines()) {
      listLatLng.addAll(polyline.points);
    }

    expect(
        listLatLng,
        route.polyline.points
            .map((e) => LatLng(e.latitude, e.longitude))
            .toList());
  });

  test("If route set", () {


    routeManager.setRoutes(route_1, route_2, route_3);

    routeManager.showAllRoutes(false);

    final polylineManager = PolylineManager();
    List<LatLng> listLatLng = [];
    for (Polyline polyline in polylineManager.getPolyLines()) {
      listLatLng.addAll(polyline.points);
    }

    List<LatLng> listRoute = [];
    listRoute.addAll(route_1.polyline.points
        .map((e) => LatLng(e.latitude, e.longitude))
        .toList());
    listRoute.addAll(route_2.polyline.points
        .map((e) => LatLng(e.latitude, e.longitude))
        .toList());
    listRoute.addAll(route_3.polyline.points
        .map((e) => LatLng(e.latitude, e.longitude))
        .toList());
    expect(listLatLng, listRoute);
  });

  test("Show current route",(){
    expect(routeManager.getStartWalkingRoute(),R.Route.routeNotFound());
    expect(routeManager.getBikingRoute(),R.Route.routeNotFound());
    expect(routeManager.getEndWalkingRoute(),R.Route.routeNotFound());

    routeManager.showCurrentRoute(false);
    expect(directionManager.getDirections().length,0);

    routeManager.setRoutes(route_1, route_2, route_3);

    routeManager.showCurrentRoute(false);
    expect(directionManager.getDirections().length,4);

    routeManager.setRoutes(R.Route.routeNotFound(), route_2, route_3);

    routeManager.showCurrentRoute(false);
    expect(directionManager.getDirections().length,5);

    routeManager.setRoutes(R.Route.routeNotFound(), R.Route.routeNotFound(), route_3);

    routeManager.showCurrentRoute(false);
    expect(directionManager.getDirections().length,0);

    routeManager.setRoutes(R.Route.routeNotFound(), route_2, R.Route.routeNotFound());

    routeManager.showCurrentRoute(false);
    expect(directionManager.getDirections().length,5);
  });

  test("Show current walking route",(){
    expect(routeManager.getStartWalkingRoute(),R.Route.routeNotFound());
    expect(routeManager.getEndWalkingRoute(),R.Route.routeNotFound());
    expect(directionManager.getDirections().length,0);

    routeManager.setRoutes(route_1, R.Route.routeNotFound(), R.Route.routeNotFound());

    routeManager.showCurrentRoute(false);
    expect(directionManager.getDirections().length,4);

    routeManager.setRoutes(R.Route.routeNotFound(), R.Route.routeNotFound(), route_3);

    routeManager.showCurrentRoute(false);
    expect(directionManager.getDirections().length,0);
  });

  test("Show bike route",(){
    expect(routeManager.getBikingRoute(),R.Route.routeNotFound());

    routeManager.showCurrentRoute(false);
    expect(directionManager.getDirections().length,0);

    routeManager.setRoutes(R.Route.routeNotFound(), route_2, R.Route.routeNotFound());

    routeManager.showCurrentRoute(false);
    expect(directionManager.getDirections().length,5);

  });

  test("Set destination",(){
    expect(routeManager.ifDestinationSet(),false);
    routeManager.changeDestination(Place(geometry: Geometry.geometryNotFound(), name: "name", placeId: "placeId", description: "description"));
    expect(routeManager.ifDestinationSet(), true);
  });

  test("Toggle start from current location",(){
    expect(routeManager.ifStartFromCurrentLocation(), false);
    routeManager.toggleStartFromCurrentLocation();
    expect(routeManager.ifStartFromCurrentLocation(), true);

    routeManager.toggleStartFromCurrentLocation();
    expect(routeManager.ifStartFromCurrentLocation(), false);
  });

  test("Set start from current location", (){
    expect(routeManager.ifStartFromCurrentLocation(), false);
    routeManager.setStartFromCurrentLocation(true);
    expect(routeManager.ifStartFromCurrentLocation(), true);

    routeManager.setStartFromCurrentLocation(false);
    expect(routeManager.ifStartFromCurrentLocation(), false);
  });

  test("Toggle walk to first waypoint", () {
    expect(routeManager.ifChanged(), false);
    expect(routeManager.ifWalkToFirstWaypoint(), false);
    routeManager.toggleWalkToFirstWaypoint();

    expect(routeManager.ifWalkToFirstWaypoint(), true);
    expect(routeManager.ifChanged(), true);
  });

  test("Set walk to first waypoint", () {
    expect(routeManager.ifWalkToFirstWaypoint(), false);
    expect(routeManager.ifChanged(), false);
    routeManager.setWalkToFirstWaypoint(true);
    expect(routeManager.ifWalkToFirstWaypoint(), true);
    expect(routeManager.ifChanged(), true);
  });

  test("Swap any two stops should swap their positions in pathway", () {
    Place place1 = createPlace("place1", "1");
    Place place2 = createPlace("place2", "2");
    Stop waypoint1 = routeManager.addWaypoint(place1);
    Stop waypoint2 = routeManager.addWaypoint(place2);
    expect(routeManager.getStopByIndex(1), waypoint1);
    expect(routeManager.getStopByIndex(2), waypoint2);
    routeManager.swapStops(waypoint1.getUID(), waypoint2.getUID());
    expect(routeManager.getStopByIndex(1), waypoint2);
    expect(routeManager.getStopByIndex(2), waypoint1);
  });
}
