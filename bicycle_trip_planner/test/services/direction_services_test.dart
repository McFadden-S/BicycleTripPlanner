import 'package:bicycle_trip_planner/auth/Keys.dart';
import 'package:bicycle_trip_planner/models/route_types.dart';
import 'package:bicycle_trip_planner/services/directions_service.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'stations_services_test.mocks.dart' as mock;

void main() {
  group('getRoutes', () {
    String key = Keys.getApiKey();
    test('Get routes without waypoints', () async {
      final origin = "ChIJi3D0484EdkgRuYlzHV73TlY";
      final destination = "ChIJbcdbqcsEdkgReND4g9YagKY";
      final waypoints = "&waypoints=optimize:true";

      final client = mock.MockClient();
      when(client.get(Uri.parse(
              'https://maps.googleapis.com/maps/api/directions/json?origin=place_id:$origin&destination=place_id:$destination$waypoints&mode=bicycling&key=$key')))
          .thenAnswer((_) async => http.Response("""{
             "geocoded_waypoints" : [
                {
                   "geocoder_status" : "OK",
                   "place_id" : "ChIJi3D0484EdkgRuYlzHV73TlY",
                   "types" : [ "street_address" ]
                },
                {
                   "geocoder_status" : "OK",
                   "place_id" : "ChIJbcdbqcsEdkgReND4g9YagKY",
                   "types" : [ "premise" ]
                }
             ],
             "routes" : [
                {
                   "bounds" : {
                      "northeast" : {
                         "lat" : 51.5120798,
                         "lng" : -0.1192914
                      },
                      "southwest" : {
                         "lat" : 51.5071942,
                         "lng" : -0.1280464
                      }
                   },
                   "copyrights" : "Map data ©2022 Google",
                   "legs" : [
                      {
                         "distance" : {
                            "text" : "1.1 km",
                            "value" : 1130
                         },
                         "duration" : {
                            "text" : "5 mins",
                            "value" : 277
                         },
                         "end_address" : "33 Wellington St, London WC2E 7BN, UK",
                         "end_location" : {
                            "lat" : 51.5120798,
                            "lng" : -0.1204823
                         },
                         "start_address" : "10 Northumberland St, London WC2N 5DB, UK",
                         "start_location" : {
                            "lat" : 51.508114,
                            "lng" : -0.1262768
                         },
                         "steps" : [
                            {
                               "distance" : {
                                  "text" : "0.1 km",
                                  "value" : 102
                               },
                               "duration" : {
                                  "text" : "1 min",
                                  "value" : 15
                               },
                               "end_location" : {
                                  "lat" : 51.5074887,
                                  "lng" : -0.1273007
                               },
                               "html_instructions" : "Head \u003cb\u003esouth-west\u003c/b\u003e on \u003cb\u003eStrand\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eA4\u003c/b\u003e towards \u003cb\u003eNorthumberland St\u003c/b\u003e\u003cdiv style=\"font-size:0.9em\"\u003eContinue to follow A4\u003c/div\u003e\u003cdiv style=\"font-size:0.9em\"\u003eParts of this road may be closed at certain times or on certain days\u003c/div\u003e",
                               "polyline" : {
                                  "points" : "udkyHftWTj@DJHPTf@JRHPZTDB@@@B@@?D@J"
                               },
                               "start_location" : {
                                  "lat" : 51.508114,
                                  "lng" : -0.1262768
                               },
                               "travel_mode" : "BICYCLING"
                            },
                            {
                               "distance" : {
                                  "text" : "0.3 km",
                                  "value" : 255
                               },
                               "duration" : {
                                  "text" : "1 min",
                                  "value" : 74
                               },
                               "end_location" : {
                                  "lat" : 51.50855989999999,
                                  "lng" : -0.1273292
                               },
                               "html_instructions" : "At the roundabout, take the \u003cb\u003e5th\u003c/b\u003e exit onto \u003cb\u003eTrafalgar Sq\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eA4\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eA400\u003c/b\u003e\u003cdiv style=\"font-size:0.9em\"\u003eContinue to follow A4/\u003cwbr/\u003eA400\u003c/div\u003e\u003cdiv style=\"font-size:0.9em\"\u003eEntering toll zone\u003c/div\u003e",
                               "maneuver" : "roundabout-left",
                               "polyline" : {
                                  "points" : "y`kyHrzWFEF@D@HDBBBBBD@FBF@B?FBL@T@J?BAD?DADADADCDCDGBEBE@C?CACAAACACEEEOWE_@?EEUEYK]EGACAAAACACACAC?C?A?A?I?A?C?E?KAE@C@QDKBUTC@A@E?S?"
                               },
                               "start_location" : {
                                  "lat" : 51.5074887,
                                  "lng" : -0.1273007
                               },
                               "travel_mode" : "BICYCLING"
                            },
                            {
                               "distance" : {
                                  "text" : "0.7 km",
                                  "value" : 653
                               },
                               "duration" : {
                                  "text" : "3 mins",
                                  "value" : 151
                               },
                               "end_location" : {
                                  "lat" : 51.51134320000001,
                                  "lng" : -0.1192914
                               },
                               "html_instructions" : "Turn \u003cb\u003eright\u003c/b\u003e onto \u003cb\u003eDuncannon St\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eA4\u003c/b\u003e\u003cdiv style=\"font-size:0.9em\"\u003eContinue to follow A4\u003c/div\u003e\u003cdiv style=\"font-size:0.9em\"\u003eLeaving toll zone\u003c/div\u003e",
                               "maneuver" : "turn-right",
                               "polyline" : {
                                  "points" : "ogkyHxzWC_@EkCAkA?i@?_@?O?GAK?CACEKCIEKYo@_@_AIUy@sBO_@Uk@]_AYu@EMCI_@gAIU[aAu@gCa@qAI[}@_DCOSu@WcAEMEICK"
                               },
                               "start_location" : {
                                  "lat" : 51.50855989999999,
                                  "lng" : -0.1273292
                               },
                               "travel_mode" : "BICYCLING"
                            },
                            {
                               "distance" : {
                                  "text" : "0.1 km",
                                  "value" : 120
                               },
                               "duration" : {
                                  "text" : "1 min",
                                  "value" : 37
                               },
                               "end_location" : {
                                  "lat" : 51.5120798,
                                  "lng" : -0.1204823
                               },
                               "html_instructions" : "Turn \u003cb\u003eleft\u003c/b\u003e onto \u003cb\u003eWellington St\u003c/b\u003e\u003cdiv style=\"font-size:0.9em\"\u003eDestination will be on the left\u003c/div\u003e",
                               "maneuver" : "turn-left",
                               "polyline" : {
                                  "points" : "{xkyHphVGDKBIDIDKNMPA@GJIRM^m@nBAB"
                               },
                               "start_location" : {
                                  "lat" : 51.51134320000001,
                                  "lng" : -0.1192914
                               },
                               "travel_mode" : "BICYCLING"
                            }
                         ],
                         "traffic_speed_entry" : [],
                         "via_waypoint" : []
                      }
                   ],
                   "overview_polyline" : {
                      "points" : "udkyHftWz@pBTd@`@XDL@JFELBLHFHFZFr@EVEJKHKDGAIEIKOWE_@E[Qw@KOKEK?U?KAE@UFKBUTC@G@S?C_@GwE?iAAg@oC_H}AaEs@uB}BwHmBiHKWCKGDUHUTa@r@}@rC"
                   },
                   "summary" : "A4",
                   "warnings" : [
                      "Cycling directions are in beta. Use caution – This route may contain streets that aren't suitable for cycling."
                   ],
                   "waypoint_order" : []
                }
             ],
             "status" : "OK"
          }""", 200));

      final answer = await DirectionsService()
          .getRoutes(origin, destination, RouteType.bike);
      expect(answer.distance, 1130);
      expect(answer.duration, 277);
      expect(answer.legs.length, 1);
      expect(answer.directions.length, 4);
      print(answer.polyline.points.length);
      expect(answer.routeType, RouteType.bike);
    });

    test('Get routes with waypoints', () async {
      final origin = "ChIJDewcaLUEdkgRByjdEk9z704";
      final destination = "ChIJaS6FAKMEdkgRgryaUMRNVEI";
      final waypoints = ["ChIJs4GOh8sEdkgRRiBFZKMP8ZE"];

      final client = mock.MockClient();
      when(client.get(Uri.parse(
              'https://maps.googleapis.com/maps/api/directions/json?origin=place_id:ChIJDewcaLUEdkgRByjdEk9z704&destination=place_id:ChIJaS6FAKMEdkgRgryaUMRNVEI&waypoints=optimize:true|place_id:ChIJs4GOh8sEdkgRRiBFZKMP8ZE&mode=bicycling&key=$key')))
          .thenAnswer((_) async => http.Response("""{
             "geocoded_waypoints" : [
                {
                   "geocoder_status" : "OK",
                   "place_id" : "ChIJDewcaLUEdkgRByjdEk9z704",
                   "types" : [ "street_address" ]
                },
                {
                   "geocoder_status" : "OK",
                   "place_id" : "ChIJs4GOh8sEdkgRRiBFZKMP8ZE",
                   "types" : [ "political", "sublocality", "sublocality_level_1" ]
                },
                {
                   "geocoder_status" : "OK",
                   "place_id" : "ChIJaS6FAKMEdkgRgryaUMRNVEI",
                   "types" : [ "street_address" ]
                }
             ],
             "routes" : [
                {
                   "bounds" : {
                      "northeast" : {
                         "lat" : 51.5136199,
                         "lng" : -0.1018883
                      },
                      "southwest" : {
                         "lat" : 51.4964366,
                         "lng" : -0.1251987
                      }
                   },
                   "copyrights" : "Map data ©2022",
                   "legs" : [
                      {
                         "distance" : {
                            "text" : "0.9 km",
                            "value" : 906
                         },
                         "duration" : {
                            "text" : "5 mins",
                            "value" : 329
                         },
                         "end_address" : "Covent Garden, London, UK",
                         "end_location" : {
                            "lat" : 51.51177759999999,
                            "lng" : -0.124189
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
                               "html_instructions" : "Head \u003cb\u003esouth\u003c/b\u003e on \u003cb\u003eHoughton St\u003c/b\u003e towards \u003cb\u003eAldwych\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eA4\u003c/b\u003e",
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
                                  "text" : "0.2 km",
                                  "value" : 223
                               },
                               "duration" : {
                                  "text" : "2 mins",
                                  "value" : 114
                               },
                               "end_location" : {
                                  "lat" : 51.5120957,
                                  "lng" : -0.1189441
                               },
                               "html_instructions" : "Turn \u003cb\u003eright\u003c/b\u003e onto \u003cb\u003eAldwych\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eA4\u003c/b\u003e\u003cdiv style=\"font-size:0.9em\"\u003eEntering toll zone\u003c/div\u003e",
                               "maneuver" : "turn-right",
                               "polyline" : {
                                  "points" : "kelyHdxU@V@ZBVBNBTDVNt@J`@Ld@LXZh@V`@LPRRNJ@@JFHFPHNFH@"
                               },
                               "start_location" : {
                                  "lat" : 51.5133402,
                                  "lng" : -0.1166735
                               },
                               "travel_mode" : "BICYCLING"
                            },
                            {
                               "distance" : {
                                  "text" : "16 m",
                                  "value" : 16
                               },
                               "duration" : {
                                  "text" : "1 min",
                                  "value" : 70
                               },
                               "end_location" : {
                                  "lat" : 51.5121291,
                                  "lng" : -0.1191639
                               },
                               "html_instructions" : "Turn \u003cb\u003eright\u003c/b\u003e onto \u003cb\u003eCatherine St\u003c/b\u003e\u003cdiv style=\"font-size:0.9em\"\u003eLeaving toll zone\u003c/div\u003e\u003cdiv style=\"font-size:0.9em\"\u003eWalk your bicycle\u003c/div\u003e",
                               "maneuver" : "turn-right",
                               "polyline" : {
                                  "points" : "s}kyHjfVEj@"
                               },
                               "start_location" : {
                                  "lat" : 51.5120957,
                                  "lng" : -0.1189441
                               },
                               "travel_mode" : "BICYCLING"
                            },
                            {
                               "distance" : {
                                  "text" : "61 m",
                                  "value" : 61
                               },
                               "duration" : {
                                  "text" : "1 min",
                                  "value" : 29
                               },
                               "end_location" : {
                                  "lat" : 51.5118352,
                                  "lng" : -0.1198957
                               },
                               "html_instructions" : "Turn \u003cb\u003eleft\u003c/b\u003e onto \u003cb\u003eExeter St\u003c/b\u003e\u003cdiv style=\"font-size:0.9em\"\u003eEntering toll zone\u003c/div\u003e",
                               "maneuver" : "turn-left",
                               "polyline" : {
                                  "points" : "y}kyHvgVBFBDBFJ\\Pj@DPBHBF@N"
                               },
                               "start_location" : {
                                  "lat" : 51.5121291,
                                  "lng" : -0.1191639
                               },
                               "travel_mode" : "BICYCLING"
                            },
                            {
                               "distance" : {
                                  "text" : "47 m",
                                  "value" : 47
                               },
                               "duration" : {
                                  "text" : "1 min",
                                  "value" : 14
                               },
                               "end_location" : {
                                  "lat" : 51.5120692,
                                  "lng" : -0.1204612
                               },
                               "html_instructions" : "Turn \u003cb\u003eright\u003c/b\u003e onto \u003cb\u003eWellington St\u003c/b\u003e\u003cdiv style=\"font-size:0.9em\"\u003eLeaving toll zone\u003c/div\u003e",
                               "maneuver" : "turn-right",
                               "polyline" : {
                                  "points" : "_|kyHjlVm@nB"
                               },
                               "start_location" : {
                                  "lat" : 51.5118352,
                                  "lng" : -0.1198957
                               },
                               "travel_mode" : "BICYCLING"
                            },
                            {
                               "distance" : {
                                  "text" : "0.2 km",
                                  "value" : 160
                               },
                               "duration" : {
                                  "text" : "1 min",
                                  "value" : 25
                               },
                               "end_location" : {
                                  "lat" : 51.5111874,
                                  "lng" : -0.1222778
                               },
                               "html_instructions" : "Turn \u003cb\u003eleft\u003c/b\u003e onto \u003cb\u003eTavistock St\u003c/b\u003e\u003cdiv style=\"font-size:0.9em\"\u003eEntering toll zone\u003c/div\u003e",
                               "maneuver" : "turn-left",
                               "polyline" : {
                                  "points" : "m}kyHzoV\\x@n@vAJXHRFPXx@h@zA?B"
                               },
                               "start_location" : {
                                  "lat" : 51.5120692,
                                  "lng" : -0.1204612
                               },
                               "travel_mode" : "BICYCLING"
                            },
                            {
                               "distance" : {
                                  "text" : "47 m",
                                  "value" : 47
                               },
                               "duration" : {
                                  "text" : "1 min",
                                  "value" : 13
                               },
                               "end_location" : {
                                  "lat" : 51.5115331,
                                  "lng" : -0.1226651
                               },
                               "html_instructions" : "Turn \u003cb\u003eright\u003c/b\u003e onto \u003cb\u003eSouthampton St\u003c/b\u003e",
                               "maneuver" : "turn-right",
                               "polyline" : {
                                  "points" : "}wkyHf{Vs@t@EDCDCBAB?B"
                               },
                               "start_location" : {
                                  "lat" : 51.5111874,
                                  "lng" : -0.1222778
                               },
                               "travel_mode" : "BICYCLING"
                            },
                            {
                               "distance" : {
                                  "text" : "0.2 km",
                                  "value" : 153
                               },
                               "duration" : {
                                  "text" : "1 min",
                                  "value" : 23
                               },
                               "end_location" : {
                                  "lat" : 51.5107547,
                                  "lng" : -0.1244885
                               },
                               "html_instructions" : "Turn \u003cb\u003eleft\u003c/b\u003e onto \u003cb\u003eHenrietta St\u003c/b\u003e",
                               "maneuver" : "turn-left",
                               "polyline" : {
                                  "points" : "azkyHt}V?B?@?@DLFNNb@HXBHDRNb@L\\Vt@r@pB"
                               },
                               "start_location" : {
                                  "lat" : 51.5115331,
                                  "lng" : -0.1226651
                               },
                               "travel_mode" : "BICYCLING"
                            },
                            {
                               "distance" : {
                                  "text" : "81 m",
                                  "value" : 81
                               },
                               "duration" : {
                                  "text" : "1 min",
                                  "value" : 20
                               },
                               "end_location" : {
                                  "lat" : 51.5113154,
                                  "lng" : -0.1251987
                               },
                               "html_instructions" : "Turn \u003cb\u003eright\u003c/b\u003e onto \u003cb\u003eBedford St\u003c/b\u003e\u003cdiv style=\"font-size:0.9em\"\u003eLeaving toll zone\u003c/div\u003e\u003cdiv style=\"font-size:0.9em\"\u003eEntering toll zone\u003c/div\u003e",
                               "maneuver" : "turn-right",
                               "polyline" : {
                                  "points" : "eukyH`iWEBw@z@CBOREDGFEFABCDAFCL"
                               },
                               "start_location" : {
                                  "lat" : 51.5107547,
                                  "lng" : -0.1244885
                               },
                               "travel_mode" : "BICYCLING"
                            },
                            {
                               "distance" : {
                                  "text" : "87 m",
                                  "value" : 87
                               },
                               "duration" : {
                                  "text" : "1 min",
                                  "value" : 17
                               },
                               "end_location" : {
                                  "lat" : 51.51177759999999,
                                  "lng" : -0.124189
                               },
                               "html_instructions" : "Turn \u003cb\u003eright\u003c/b\u003e onto \u003cb\u003eKing St\u003c/b\u003e\u003cdiv style=\"font-size:0.9em\"\u003eDestination will be on the right\u003c/div\u003e",
                               "maneuver" : "turn-right",
                               "polyline" : {
                                  "points" : "wxkyHnmWEKCKAAAAOe@K[i@}AGM"
                               },
                               "start_location" : {
                                  "lat" : 51.5113154,
                                  "lng" : -0.1251987
                               },
                               "travel_mode" : "BICYCLING"
                            }
                         ],
                         "traffic_speed_entry" : [],
                         "via_waypoint" : []
                      },
                      {
                         "distance" : {
                            "text" : "2.8 km",
                            "value" : 2773
                         },
                         "duration" : {
                            "text" : "9 mins",
                            "value" : 528
                         },
                         "end_address" : "38 London Rd, Elephant and Castle, London SE1 6JW, UK",
                         "end_location" : {
                            "lat" : 51.4964366,
                            "lng" : -0.1018883
                         },
                         "start_address" : "Covent Garden, London, UK",
                         "start_location" : {
                            "lat" : 51.51177759999999,
                            "lng" : -0.124189
                         },
                         "steps" : [
                            {
                               "distance" : {
                                  "text" : "87 m",
                                  "value" : 87
                               },
                               "duration" : {
                                  "text" : "1 min",
                                  "value" : 16
                               },
                               "end_location" : {
                                  "lat" : 51.5113154,
                                  "lng" : -0.1251987
                               },
                               "html_instructions" : "Head \u003cb\u003esouth-west\u003c/b\u003e on \u003cb\u003eKing St\u003c/b\u003e towards \u003cb\u003eBedford St\u003c/b\u003e",
                               "polyline" : {
                                  "points" : "s{kyHdgWFLh@|AJZNd@@@@@BJDJ"
                               },
                               "start_location" : {
                                  "lat" : 51.51177759999999,
                                  "lng" : -0.124189
                               },
                               "travel_mode" : "BICYCLING"
                            },
                            {
                               "distance" : {
                                  "text" : "0.2 km",
                                  "value" : 222
                               },
                               "duration" : {
                                  "text" : "1 min",
                                  "value" : 28
                               },
                               "end_location" : {
                                  "lat" : 51.5096928,
                                  "lng" : -0.123379
                               },
                               "html_instructions" : "Turn \u003cb\u003eleft\u003c/b\u003e onto \u003cb\u003eBedford St\u003c/b\u003e\u003cdiv style=\"font-size:0.9em\"\u003eLeaving toll zone\u003c/div\u003e",
                               "maneuver" : "turn-left",
                               "polyline" : {
                                  "points" : "wxkyHnmWBM@GBE@CDGFGDENSBCv@{@DCFGv@y@HIDCDE^_@LQv@{@HILO"
                               },
                               "start_location" : {
                                  "lat" : 51.5113154,
                                  "lng" : -0.1251987
                               },
                               "travel_mode" : "BICYCLING"
                            },
                            {
                               "distance" : {
                                  "text" : "0.3 km",
                                  "value" : 347
                               },
                               "duration" : {
                                  "text" : "1 min",
                                  "value" : 87
                               },
                               "end_location" : {
                                  "lat" : 51.5114002,
                                  "lng" : -0.1191957
                               },
                               "html_instructions" : "Turn \u003cb\u003eleft\u003c/b\u003e onto \u003cb\u003eStrand\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eA4\u003c/b\u003e",
                               "maneuver" : "turn-left",
                               "polyline" : {
                                  "points" : "qnkyHbbWYu@EMCI_@gAIU[aAu@gCa@qAI[}@_DCOSu@WcAEMEICKKQ"
                               },
                               "start_location" : {
                                  "lat" : 51.5096928,
                                  "lng" : -0.123379
                               },
                               "travel_mode" : "BICYCLING"
                            },
                            {
                               "distance" : {
                                  "text" : "1.8 km",
                                  "value" : 1768
                               },
                               "duration" : {
                                  "text" : "5 mins",
                                  "value" : 328
                               },
                               "end_location" : {
                                  "lat" : 51.498757,
                                  "lng" : -0.1048796
                               },
                               "html_instructions" : "Turn \u003cb\u003eright\u003c/b\u003e onto \u003cb\u003eLancaster Pl\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eA301\u003c/b\u003e\u003cdiv style=\"font-size:0.9em\"\u003eParts of this road may be closed at certain times or on certain days\u003c/div\u003e\u003cdiv style=\"font-size:0.9em\"\u003eGo through 1 roundabout\u003c/div\u003e",
                               "maneuver" : "turn-right",
                               "polyline" : {
                                  "points" : "gykyH~gVNSZUPKdAw@^WZWt@m@POVS\\[tAoAd@[tD_Dz@u@PShAcALKPORQ^[|@w@x@m@ROXUTSRQ^[LKh@e@JILKHIVWDGFIPQ?MDY?ABQDOBE@EBCBCBCFELCb@?RKBABA@?@ABC@CDG@EHMFa@DQBMJYJUBKJOFMZc@HKRUFKZ_@d@k@DEd@k@HGJGj@u@HGPWTUTYNQ`@g@HKJO^c@NS\\a@`@i@NOb@k@`AmAX[LOJKBEFIJM@EDI^a@JMLQd@k@NSDGb@k@^e@^g@tAkBRWJQ@CDGDKBIBGDQBK@C@K@I@Q@UEq@E]"
                               },
                               "start_location" : {
                                  "lat" : 51.5114002,
                                  "lng" : -0.1191957
                               },
                               "travel_mode" : "BICYCLING"
                            },
                            {
                               "distance" : {
                                  "text" : "0.3 km",
                                  "value" : 349
                               },
                               "duration" : {
                                  "text" : "1 min",
                                  "value" : 69
                               },
                               "end_location" : {
                                  "lat" : 51.4964366,
                                  "lng" : -0.1018883
                               },
                               "html_instructions" : "At the roundabout, take the \u003cb\u003e3rd\u003c/b\u003e exit onto \u003cb\u003eSt George's Circus\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eA201\u003c/b\u003e\u003cdiv style=\"font-size:0.9em\"\u003eContinue to follow A201\u003c/div\u003e\u003cdiv style=\"font-size:0.9em\"\u003eDestination will be on the left\u003c/div\u003e",
                               "maneuver" : "roundabout-left",
                               "polyline" : {
                                  "points" : "gjiyHnnSAA?AA??AAA?AAA?A?AAA?A?C?A?A?A?A?A?A?A?A?A@A?A?A?A@??A@A?A@A@A@??A@?@?@?@?@?@??@@??@@??@@??@@?JK@ABCDEDELQFE@CVYFILQV_@l@{@FIFKX]HK?ABCNM?AHKnAeBv@gAXa@@APSFK"
                               },
                               "start_location" : {
                                  "lat" : 51.498757,
                                  "lng" : -0.1048796
                               },
                               "travel_mode" : "BICYCLING"
                            }
                         ],
                         "traffic_speed_entry" : [],
                         "via_waypoint" : []
                      }
                   ],
                   "overview_polyline" : {
                      "points" : "cglyHjxUv@E@VDr@\\rBXfAh@bAd@r@b@^h@ZXHEj@BFFL\\hANr@m@nBlApCv@xBh@~Ay@z@IPDTd@vAz@jCr@pBEB{@~@c@h@K^sA{DGMFLt@xBRh@HVDURY`DiDx@{@`AeALOYu@IWi@}A}BwHmBiH[u@NSZUvAcApB}A|CoCd@[tD_DlAiA|BqB|AsAlA}@bBwApAgAn@s@PQ?MD[Ha@DKRQp@CVMJGR_@Ls@Ng@b@_A`AqAlB}BTOt@}@lAyAvAgBlFuGb@i@FOj@o@hAyAxDeFf@u@Ro@He@Bg@KoAACCCCK@YJOD?FBBBr@u@n@y@tAqBpCqDlBkC"
                   },
                   "summary" : "Aldwych/A4",
                   "warnings" : [
                      "Cycling directions are in beta. Use caution – This route may contain streets that aren't suitable for cycling."
                   ],
                   "waypoint_order" : [ 0 ]
                }
             ],
             "status" : "OK"
          }""", 200));

      final answer = await DirectionsService()
          .getRoutes(origin, destination, RouteType.bike, waypoints);
      expect(answer.distance, 3679);
      expect(answer.duration, 857);
      expect(answer.legs.length, 2);
      expect(answer.directions.length, 15);
      expect(answer.routeType, RouteType.bike);
    });
  });

  group('getWalkingRoutes', () {
    String key = Keys.getApiKey();
    test('Get walking routes without waypoints', () async {
      final origin = "ChIJN6skQs4EdkgRU24-sEUFmPw";
      final destination = "ChIJi3D0484EdkgRuYlzHV73TlY";
      final waypoints = "";

      final client = mock.MockClient();
      when(client.get(Uri.parse(
              'https://maps.googleapis.com/maps/api/directions/json?origin=place_id:$origin&destination=place_id:$destination$waypoints&mode=walking&key=$key')))
          .thenAnswer((_) async => http.Response("""{
             "geocoded_waypoints" : [
                {
                   "geocoder_status" : "OK",
                   "place_id" : "ChIJN6skQs4EdkgRU24-sEUFmPw",
                   "types" : [ "premise" ]
                },
                {
                   "geocoder_status" : "OK",
                   "place_id" : "ChIJi3D0484EdkgRuYlzHV73TlY",
                   "types" : [ "street_address" ]
                }
             ],
             "routes" : [
                {
                   "bounds" : {
                      "northeast" : {
                         "lat" : 51.5080858,
                         "lng" : -0.1262404
                      },
                      "southwest" : {
                         "lat" : 51.5070603,
                         "lng" : -0.1273583
                      }
                   },
                   "copyrights" : "Map data ©2022 Google",
                   "legs" : [
                      {
                         "distance" : {
                            "text" : "0.2 km",
                            "value" : 152
                         },
                         "duration" : {
                            "text" : "2 mins",
                            "value" : 125
                         },
                         "end_address" : "10 Northumberland St, London WC2N 5DB, UK",
                         "end_location" : {
                            "lat" : 51.5080858,
                            "lng" : -0.1262404
                         },
                         "start_address" : "3 Whitehall, London SW1A 2DD, UK",
                         "start_location" : {
                            "lat" : 51.5070603,
                            "lng" : -0.1273419
                         },
                         "steps" : [
                            {
                               "distance" : {
                                  "text" : "21 m",
                                  "value" : 21
                               },
                               "duration" : {
                                  "text" : "1 min",
                                  "value" : 17
                               },
                               "end_location" : {
                                  "lat" : 51.5071986,
                                  "lng" : -0.1273562
                               },
                               "html_instructions" : "Walk \u003cb\u003enorth\u003c/b\u003e on \u003cb\u003eWhitehall\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eA3212\u003c/b\u003e",
                               "polyline" : {
                                  "points" : "c~jyHzzWA?A@A?G@E?G?"
                               },
                               "start_location" : {
                                  "lat" : 51.5070603,
                                  "lng" : -0.1273419
                               },
                               "travel_mode" : "WALKING"
                            },
                            {
                               "distance" : {
                                  "text" : "0.1 km",
                                  "value" : 131
                               },
                               "duration" : {
                                  "text" : "2 mins",
                                  "value" : 108
                               },
                               "end_location" : {
                                  "lat" : 51.5080858,
                                  "lng" : -0.1262404
                               },
                               "html_instructions" : "At the roundabout, take the \u003cb\u003e3rd\u003c/b\u003e exit onto \u003cb\u003eTrafalgar Sq\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eA4\u003c/b\u003e/\u003cwbr/\u003e\u003cb\u003eA400\u003c/b\u003e\u003cdiv style=\"font-size:0.9em\"\u003eContinue to follow A4\u003c/div\u003e\u003cdiv style=\"font-size:0.9em\"\u003eParts of this road may be closed at certain times or on certain days\u003c/div\u003e\u003cdiv style=\"font-size:0.9em\"\u003eDestination will be on the left\u003c/div\u003e",
                               "maneuver" : "roundabout-left",
                               "polyline" : {
                                  "points" : "__kyH~zWCGEKEEQGEAKACIGGa@YEIKSUg@CGGOIMQa@"
                               },
                               "start_location" : {
                                  "lat" : 51.5071986,
                                  "lng" : -0.1273562
                               },
                               "travel_mode" : "WALKING"
                            }
                         ],
                         "traffic_speed_entry" : [],
                         "via_waypoint" : []
                      }
                   ],
                   "overview_polyline" : {
                      "points" : "c~jyHzzWMBM?ISWMQCKQa@YEIa@{@KW[o@"
                   },
                   "summary" : "A4",
                   "warnings" : [
                      "Walking directions are in beta. Use caution – This route may be missing pavements or pedestrian paths."
                   ],
                   "waypoint_order" : []
                }
             ],
             "status" : "OK"
          }
                    """, 200));

      final answer = await DirectionsService()
          .getRoutes(origin, destination, RouteType.walk);
      expect(answer.distance, 152);
      expect(answer.duration, 125);
      expect(answer.legs.length, 1);
      expect(answer.directions.length, 2);
      expect(answer.routeType, RouteType.walk);
    });
  });
}
