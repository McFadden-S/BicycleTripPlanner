import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/models/route_types.dart';
import 'package:bicycle_trip_planner/models/steps.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test/test.dart';
import 'package:bicycle_trip_planner/managers/DirectionManager.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_trip_planner/constants.dart';
import 'dart:convert' as convert;
import 'package:bicycle_trip_planner/models/route.dart' as R;

void main() {
  final directionManager = DirectionManager();

  List<Steps> createDummyDirections() {
    List<Steps> steps = [];
    steps.add(Steps(instruction: "Turn right", distance: 50, duration: 16));
    steps.add(Steps(instruction: "Turn left", distance: 150, duration: 16));
    steps.add(Steps(instruction: "Roundabout", distance: 150, duration: 16));
    steps.add(
        Steps(instruction: "Continue straight", distance: 250, duration: 16));
    steps.add(Steps(instruction: "Turn left", distance: 150, duration: 16));
    return steps;
  }

  test('ensure duration is no data when initialized', () {
    expect(directionManager.getDuration(), "No data");
  });

  test('ensure distance is no data when initialized', () {
    expect(directionManager.getDistance(), "No data");
  });

  test('ensure directions is empty when initialized', () {
    expect(directionManager.getDirections().length, 0);
  });

  test('ensure currentDirection is empty when initialized', () {
    expect(directionManager.getCurrentDirection().instruction, "");
    expect(directionManager.getCurrentDirection().duration, 0);
    expect(directionManager.getCurrentDirection().distance, 0);
  });

  test('test calculation conversion for duration is correct', () {
    directionManager.setDuration(60);
    expect(directionManager.getDuration(), '1 min');
  });

  // TODO: Check this test, this test shouldn't work???
  test('test calculation conversion for distance is correct', () {
    directionManager.setDistance(1000);
    expect(directionManager.getDistance(), '1 mi');
  });
  test('ensure the right icons are being returned depending on input', () {
    expect(
        directionManager.directionIcon("left").toString(),
        Icon(Icons.arrow_back, color: ThemeStyle.buttonPrimaryColor, size: 60)
            .toString());
    expect(
        directionManager.directionIcon("right").toString(),
        Icon(Icons.arrow_forward,
                color: ThemeStyle.buttonPrimaryColor, size: 60)
            .toString());
    expect(
        directionManager.directionIcon("straight").toString(),
        Icon(Icons.arrow_upward, color: ThemeStyle.buttonPrimaryColor, size: 60)
            .toString());
    expect(
        directionManager.directionIcon("continue").toString(),
        Icon(Icons.arrow_upward, color: ThemeStyle.buttonPrimaryColor, size: 60)
            .toString());
    expect(
        directionManager.directionIcon("head").toString(),
        Icon(Icons.arrow_upward, color: ThemeStyle.buttonPrimaryColor, size: 60)
            .toString());
    expect(
        directionManager.directionIcon("roundabout").toString(),
        Icon(Icons.data_usage_outlined,
                color: ThemeStyle.buttonPrimaryColor, size: 60)
            .toString());
    expect(
        directionManager.directionIcon("else").toString(),
        Icon(Icons.circle, color: ThemeStyle.buttonPrimaryColor, size: 60)
            .toString());
  });

  test("Test bike directions", () {
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

    final routeManager = RouteManager();

    routeManager.setRoutes(route_1, route_2, route_3);

    List<Steps> r2Directions = [];
    r2Directions.addAll(route_2.directions);
    r2Directions.removeAt(0);

    routeManager.showBikeRoute(false);

    expect(directionManager.getDirections(), r2Directions);

    List<Steps> r1Directions = [];
    r1Directions.addAll(route_1.directions);
    r1Directions.removeAt(0);

    routeManager.showCurrentWalkingRoute(false);

    expect(directionManager.getDirections(), r1Directions);
  });
}
