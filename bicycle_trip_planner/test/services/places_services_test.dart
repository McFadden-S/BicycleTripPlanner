
import 'package:bicycle_trip_planner/models/place.dart';
import 'package:bicycle_trip_planner/services/places_service.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'stations_services_test.mocks.dart' as mock;


void main(){
  group('getAutocomplete', () {
    test('Get automcomplete from non empty string', () async {

      const search = "Covent";
      const key = 'AIzaSyBcUJrLd8uIYR2HFTNa6mj-7lVRyUIJXs0';
      var url =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&components=country:gb&location=51.495830%2C-0.145607&radius=35000&strictbounds=true&key=$key';

      final client = mock.MockClient();
      when(client.get(Uri.parse(url)))
          .thenAnswer((_) async =>
          http.Response("""
                  {
            "predictions" : [
              {
                 "description" : "Covent Garden, London, UK",
                 "matched_substrings" : [
                    {
                       "length" : 6,
                       "offset" : 0
                    }
                 ],
                 "place_id" : "ChIJs4GOh8sEdkgRRiBFZKMP8ZE",
                 "reference" : "ChIJs4GOh8sEdkgRRiBFZKMP8ZE",
                 "structured_formatting" : {
                    "main_text" : "Covent Garden",
                    "main_text_matched_substrings" : [
                       {
                          "length" : 6,
                          "offset" : 0
                       }
                    ],
                    "secondary_text" : "London, UK"
                 },
                 "terms" : [
                    {
                       "offset" : 0,
                       "value" : "Covent Garden"
                    },
                    {
                       "offset" : 15,
                       "value" : "London"
                    },
                    {
                       "offset" : 23,
                       "value" : "UK"
                    }
                 ],
                 "types" : [ "sublocality_level_1", "sublocality", "political", "geocode" ]
              },
              {
                 "description" : "Covent Garden Market, James Street, London, UK",
                 "matched_substrings" : [
                    {
                       "length" : 6,
                       "offset" : 0
                    }
                 ],
                 "place_id" : "ChIJQR9pg8sEdkgRKeWNNYlDdPU",
                 "reference" : "ChIJQR9pg8sEdkgRKeWNNYlDdPU",
                 "structured_formatting" : {
                    "main_text" : "Covent Garden Market",
                    "main_text_matched_substrings" : [
                       {
                          "length" : 6,
                          "offset" : 0
                       }
                    ],
                    "secondary_text" : "James Street, London, UK"
                 },
                 "terms" : [
                    {
                       "offset" : 0,
                       "value" : "Covent Garden Market"
                    },
                    {
                       "offset" : 22,
                       "value" : "James Street"
                    },
                    {
                       "offset" : 36,
                       "value" : "London"
                    },
                    {
                       "offset" : 44,
                       "value" : "UK"
                    }
                 ],
                 "types" : [ "shopping_mall", "point_of_interest", "establishment" ]
              },
              {
                 "description" : "Coventry Street, London, UK",
                 "matched_substrings" : [
                    {
                       "length" : 6,
                       "offset" : 0
                    }
                 ],
                 "place_id" : "EhtDb3ZlbnRyeSBTdHJlZXQsIExvbmRvbiwgVUsiLiosChQKEgkbYATF0wR2SBEYOkVWMFamohIUChIJ8_MXt1sbdkgRCrIAOXkukUk",
                 "reference" : "EhtDb3ZlbnRyeSBTdHJlZXQsIExvbmRvbiwgVUsiLiosChQKEgkbYATF0wR2SBEYOkVWMFamohIUChIJ8_MXt1sbdkgRCrIAOXkukUk",
                 "structured_formatting" : {
                    "main_text" : "Coventry Street",
                    "main_text_matched_substrings" : [
                       {
                          "length" : 6,
                          "offset" : 0
                       }
                    ],
                    "secondary_text" : "London, UK"
                 },
                 "terms" : [
                    {
                       "offset" : 0,
                       "value" : "Coventry Street"
                    },
                    {
                       "offset" : 17,
                       "value" : "London"
                    },
                    {
                       "offset" : 25,
                       "value" : "UK"
                    }
                 ],
                 "types" : [ "route", "geocode" ]
              },
              {
                 "description" : "Covent Garden, Long Acre, London, UK",
                 "matched_substrings" : [
                    {
                       "length" : 6,
                       "offset" : 0
                    }
                 ],
                 "place_id" : "ChIJT2mIkcwEdkgRYspzsBq1iAM",
                 "reference" : "ChIJT2mIkcwEdkgRYspzsBq1iAM",
                 "structured_formatting" : {
                    "main_text" : "Covent Garden",
                    "main_text_matched_substrings" : [
                       {
                          "length" : 6,
                          "offset" : 0
                       }
                    ],
                    "secondary_text" : "Long Acre, London, UK"
                 },
                 "terms" : [
                    {
                       "offset" : 0,
                       "value" : "Covent Garden"
                    },
                    {
                       "offset" : 15,
                       "value" : "Long Acre"
                    },
                    {
                       "offset" : 26,
                       "value" : "London"
                    },
                    {
                       "offset" : 34,
                       "value" : "UK"
                    }
                 ],
                 "types" : [
                    "subway_station",
                    "transit_station",
                    "point_of_interest",
                    "establishment"
                 ]
              },
              {
                 "description" : "Coventry University London, Middlesex Street, London, UK",
                 "matched_substrings" : [
                    {
                       "length" : 6,
                       "offset" : 0
                    }
                 ],
                 "place_id" : "ChIJdd2DCrMcdkgRUkBoFNUaElk",
                 "reference" : "ChIJdd2DCrMcdkgRUkBoFNUaElk",
                 "structured_formatting" : {
                    "main_text" : "Coventry University London",
                    "main_text_matched_substrings" : [
                       {
                          "length" : 6,
                          "offset" : 0
                       }
                    ],
                    "secondary_text" : "Middlesex Street, London, UK"
                 },
                 "terms" : [
                    {
                       "offset" : 0,
                       "value" : "Coventry University London"
                    },
                    {
                       "offset" : 28,
                       "value" : "Middlesex Street"
                    },
                    {
                       "offset" : 46,
                       "value" : "London"
                    },
                    {
                       "offset" : 54,
                       "value" : "UK"
                    }
                 ],
                 "types" : [ "university", "point_of_interest", "establishment" ]
              }
            ],
            "status" : "OK"
            }
                  """, 200));

      final answer = await PlacesService().getAutocomplete(search);
      expect(answer.isEmpty, false);
      expect(answer.isNotEmpty, true);
      expect(answer.toList().length, 5);
      expect(answer.first.placeId, "ChIJs4GOh8sEdkgRRiBFZKMP8ZE");
    });

    test('Get automcomplete from empty string', () async {

      const search = "";
      const key = 'AIzaSyBcUJrLd8uIYR2HFTNa6mj-7lVRyUIJXs0';
      var url =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&components=country:gb&location=51.495830%2C-0.145607&radius=35000&strictbounds=true&key=$key';

      final client = mock.MockClient();
      when(client.get(Uri.parse(url)))
          .thenAnswer((_) async =>
          http.Response("""{
             "predictions" : [],
             "status" : "INVALID_REQUEST"
          }""", 200));

      final answer = await PlacesService().getAutocomplete(search);
      expect(answer.isEmpty, true);
      expect(answer.isNotEmpty, false);
      expect(answer.toList().length, 0);
    });
  });

  group('getPlace', ()
  {
    test('Get place from valid place id', () async {

      const placeId = "ChIJT2mIkcwEdkgRYspzsBq1iAM";
      const description = "Covent Garden, Long Acre, London, UK";
      const key = 'AIzaSyBcUJrLd8uIYR2HFTNa6mj-7lVRyUIJXs0';
      const url = "https://maps.googleapis.com/maps/api/place/details/json?key=$key&place_id=$placeId";

      final client = mock.MockClient();
      when(client.get(Uri.parse(url)))
          .thenAnswer((_) async =>
          http.Response("""{
             "html_attributions" : [],
             "result" : {
                "address_components" : [
                   {
                      "long_name" : "Long Acre",
                      "short_name" : "Long Acre",
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
                      "long_name" : "WC2E 9JT",
                      "short_name" : "WC2E 9JT",
                      "types" : [ "postal_code" ]
                   }
                ],
                "adr_address" : "\u003cspan class=\"street-address\"\u003eLong Acre\u003c/span\u003e, \u003cspan class=\"locality\"\u003eLondon\u003c/span\u003e \u003cspan class=\"postal-code\"\u003eWC2E 9JT\u003c/span\u003e, \u003cspan class=\"country-name\"\u003eUK\u003c/span\u003e",
                "business_status" : "OPERATIONAL",
                "formatted_address" : "Long Acre, London WC2E 9JT, UK",
                "geometry" : {
                   "location" : {
                      "lat" : 51.51300070000001,
                      "lng" : -0.1241621
                   },
                   "viewport" : {
                      "northeast" : {
                         "lat" : 51.5144103302915,
                         "lng" : -0.122841569708498
                      },
                      "southwest" : {
                         "lat" : 51.5117123697085,
                         "lng" : -0.125539530291502
                      }
                   }
                },
                "icon" : "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/generic_business-71.png",
                "icon_background_color" : "#7B9EB0",
                "icon_mask_base_uri" : "https://maps.gstatic.com/mapfiles/place_api/icons/v2/generic_pinlet",
                "name" : "Covent Garden",
                "photos" : [
                   {
                      "height" : 3120,
                      "html_attributions" : [
                         "\u003ca href=\"https://maps.google.com/maps/contrib/117391885916273531743\"\u003eMarcx_947\u003c/a\u003e"
                      ],
                      "photo_reference" : "Aap_uEA2XAyC9qkXnPf03he9qBzajvJR50Kj2zLSbLv1joPeaZRcRyX0gyCujqrod79YOV5bnCUdts3cmoakz4UffOWpJ7cboriPpKTDUEDke3Aj60AKKIR5wpCFV0LEJgEsXEw06c-TIie6N091v_8gTZBbk0sAlfic28oZZq-V_IzHEeZ-",
                      "width" : 4160
                   },
                   {
                      "height" : 3000,
                      "html_attributions" : [
                         "\u003ca href=\"https://maps.google.com/maps/contrib/106166648934196052186\"\u003eLee Woodhouse\u003c/a\u003e"
                      ],
                      "photo_reference" : "Aap_uEAEcXPtfrmVLfYbsr_2PV_mCKcdh49TwFfglvfpveZHQArSHliBYOaoPwoBobl4CFMkstbgGw3n2Ndz-twyqgHbxCNkJX4Khz4nyxWRhAbbCGT1fmm05hqfnlCinJ78y4IiVsdAfvzFsq_mtUNAM_bpbmSuj_ry7umrW5SOUDWbawGh",
                      "width" : 4000
                   },
                   {
                      "height" : 4608,
                      "html_attributions" : [
                         "\u003ca href=\"https://maps.google.com/maps/contrib/105429148776874388121\"\u003eKrystyna Laskowska\u003c/a\u003e"
                      ],
                      "photo_reference" : "Aap_uEDteETBTl3kjMNoRGcmG5r07LUIquL6qjiZd04T4BJSeQ8cefXie9QwgC0ZoYJXZRLN-sLVJ_YaAJNCesLOz9na-7o1bvC7jYylaAhCJogEOYMFIuoru8VhtUYsTKqT02rufl71TRSK5XGhiWBdpAKnbR6ESx6AesrIOpfsuOFOi15u",
                      "width" : 2592
                   },
                   {
                      "height" : 3024,
                      "html_attributions" : [
                         "\u003ca href=\"https://maps.google.com/maps/contrib/110546268225452304811\"\u003eThomas Anonymous\u003c/a\u003e"
                      ],
                      "photo_reference" : "Aap_uEA5b42SdZ30R0zyDGV4LlJ5WOyDbugi83-8OKIUuqR-HseFs7uPV8tSMiJFkiIBO29vX8EP__2m0UyieE-PEzJoD5rpQTrFKyhXNU-r3bmwP_6-3WfEQINw1lKZKhiKt6DZNmYuDo3_LllDyUCa_WhFd9fOc4XdNnEYtuAI7W7iiYiW",
                      "width" : 4032
                   },
                   {
                      "height" : 3024,
                      "html_attributions" : [
                         "\u003ca href=\"https://maps.google.com/maps/contrib/110546268225452304811\"\u003eThomas Anonymous\u003c/a\u003e"
                      ],
                      "photo_reference" : "Aap_uEAlOl0wJ3egijDsWhe3zZqAAReer6_GQM2618KXhWAZPIq6KYlh-tbKOCBvjuiMdO8d7KNhtSgsERWsHp_8QL1UKTOPkHTT65-EV6QQk2lc4VvAc6I3YlEp3V7sCzzTPTfCJeb2Ojd0zhnPvrY4kfKVZJs1cQaIxSNuiwYyNj097eej",
                      "width" : 4032
                   },
                   {
                      "height" : 4608,
                      "html_attributions" : [
                         "\u003ca href=\"https://maps.google.com/maps/contrib/105429148776874388121\"\u003eKrystyna Laskowska\u003c/a\u003e"
                      ],
                      "photo_reference" : "Aap_uEDJWR11FpYdNnNzsrWhuOpFXOFUlwQ2LKFhSqZa69YGFFCZZ8ntaO3JCFAanN6S6zgrAYzJP7kdM6kJhHuAtz552gRLzIHcryfHi1vpknZWe7kko4Gc8XHRTpBBpk1ybspHSVlgz6tnpHXbPZhhs-TkJszg7TqKw_3OpoObjtXmAQcI",
                      "width" : 2592
                   },
                   {
                      "height" : 4608,
                      "html_attributions" : [
                         "\u003ca href=\"https://maps.google.com/maps/contrib/105429148776874388121\"\u003eKrystyna Laskowska\u003c/a\u003e"
                      ],
                      "photo_reference" : "Aap_uEAsQwCVLLyigqeja0cIyzIyrIt8snTVjaXAhUT993O-eh9sxyNRn5qvOpCg16HmPLTL8drgQGQ27FEp-DR_L0kMhDhQyx9uohCm57BzrFul1DqIxXxEURezCFvppqB6HUxRGcDzu2mQok0akrnnIxPCLeR6C7o5xqmbDU_u5tF9BaaY",
                      "width" : 2592
                   },
                   {
                      "height" : 2688,
                      "html_attributions" : [
                         "\u003ca href=\"https://maps.google.com/maps/contrib/100792412478720895502\"\u003eroland j. ruttledge\u003c/a\u003e"
                      ],
                      "photo_reference" : "Aap_uEA3xSADeHa3Bxrj7Ho4W-xH3Zi6wzuPkNYw5Mtm8-S0FICnMvGQH0VIo74NkK23Prp0g4hkRuMKEflo0afDI08-wL3UOWcgEataY-OcsONFmGdyu_V0eCMrKuYzEuf36PNyhYdEIRDCEYkagw7mT6JoNcrBF7WhhTPTtuW-w82xj1oe",
                      "width" : 1512
                   },
                   {
                      "height" : 768,
                      "html_attributions" : [
                         "\u003ca href=\"https://maps.google.com/maps/contrib/107314781742708582401\"\u003eKatrina W\u003c/a\u003e"
                      ],
                      "photo_reference" : "Aap_uEDkVDBsa8aTLXmBnXpEwPDzNwVmX-fpeZscAiSrl7hhcJS1rKXn1EJpDRJGfp4rlfM8cx2HbNnr5rORr6Pr5FYlLacgp81LlpJsUmoxf1kh72azL9W9Bowg8blgVpS0N8Mv5xRRHY2ATGcm7S96ndVbO-a3TJKduJ2PGa4xtxi40Gyj",
                      "width" : 1024
                   },
                   {
                      "height" : 2448,
                      "html_attributions" : [
                         "\u003ca href=\"https://maps.google.com/maps/contrib/107072940560249423360\"\u003eStephen Kassay\u003c/a\u003e"
                      ],
                      "photo_reference" : "Aap_uEATJ3htyGaRSweSY7nfD8BQ96LZAIAlmYNnqM4qz0w24dRBKeNnRjK4j8xPHwaxMKVdw-y21Ve6FAOWXLRB4kX2te_nWC7K1we32FQeJWTQ_RBPEzfEGeL8K4oO9L559gD14WOrnpAt8wCV89FA7xctWKWnjZQ19-I9JrefMgzlY_0a",
                      "width" : 3264
                   }
                ],
                "place_id" : "ChIJT2mIkcwEdkgRYspzsBq1iAM",
                "plus_code" : {
                   "compound_code" : "GV7G+68 London, UK",
                   "global_code" : "9C3XGV7G+68"
                },
                "rating" : 4.2,
                "reference" : "ChIJT2mIkcwEdkgRYspzsBq1iAM",
                "reviews" : [
                   {
                      "author_name" : "Phoebe Cassell",
                      "author_url" : "https://www.google.com/maps/contrib/109713782124628890642/reviews",
                      "language" : "en",
                      "profile_photo_url" : "https://lh3.googleusercontent.com/a/AATXAJwsCHXZQz-VtU-C1qTVXlIeiRjokqu-cGeXriDjgA=s128-c0x00000000-cc-rp-mo",
                      "rating" : 5,
                      "relative_time_description" : "4 months ago",
                      "text" : "Fun atmosphere, great vegetarian options. Our server Robins was really helpful too. Highly recommend :)",
                      "time" : 1637437412
                   },
                   {
                      "author_name" : "Adrian Bell",
                      "author_url" : "https://www.google.com/maps/contrib/104284235541895736843/reviews",
                      "language" : "en",
                      "profile_photo_url" : "https://lh3.googleusercontent.com/a-/AOh14GiDVTtpBhQfHvwflN496jCyiyPMPbbi7W9A7JlTFA=s128-c0x00000000-cc-rp-mo-ba4",
                      "rating" : 5,
                      "relative_time_description" : "a month ago",
                      "text" : "Interesting place for adults and kids, performers around the outside and lots of boutique shops & market stalls. Nice clean area and feels safe.",
                      "time" : 1644843940
                   },
                   {
                      "author_name" : "Donna Ware",
                      "author_url" : "https://www.google.com/maps/contrib/111776115672272629296/reviews",
                      "language" : "en",
                      "profile_photo_url" : "https://lh3.googleusercontent.com/a/AATXAJzILsBdsFBTlfAAQd-LwIub6mLZhuAIp9ODf_5o=s128-c0x00000000-cc-rp-mo-ba4",
                      "rating" : 5,
                      "relative_time_description" : "a month ago",
                      "text" : "Full of buzz. Very busy. Lots going on. Live music. Watch what shoes you wear though as there are quite a few cobblestones. Well worth a visit.",
                      "time" : 1645053326
                   },
                   {
                      "author_name" : "Magdalena C",
                      "author_url" : "https://www.google.com/maps/contrib/116012592392452087391/reviews",
                      "language" : "en",
                      "profile_photo_url" : "https://lh3.googleusercontent.com/a-/AOh14Gh1EK92-HAn28zddtmonZ_TfzZ52lDtDH8YuHFO4Q=s128-c0x00000000-cc-rp-mo-ba4",
                      "rating" : 5,
                      "relative_time_description" : "6 months ago",
                      "text" : "Great place to visit. Lots of shops, restaurants, street performance. Close to Soho and Oxford Street. If you like walking it is the place to be. :) Amazing atmosphere.",
                      "time" : 1631452867
                   },
                   {
                      "author_name" : "Nick Pearce",
                      "author_url" : "https://www.google.com/maps/contrib/110635084158065577887/reviews",
                      "language" : "en",
                      "profile_photo_url" : "https://lh3.googleusercontent.com/a-/AOh14GjYnLhDp_eUQLcn46Zsh_Z_c46NYkVbEzAOjvvJNQ=s128-c0x00000000-cc-rp-mo",
                      "rating" : 5,
                      "relative_time_description" : "6 months ago",
                      "text" : "Received some amazing service from a lady at the station, helped us with our tickets and different ways of purchasing them in the future. Was super friendly and made our travel home so much easier. Great service",
                      "time" : 1631551053
                   }
                ],
                "types" : [
                   "subway_station",
                   "transit_station",
                   "point_of_interest",
                   "establishment"
                ],
                "url" : "https://maps.google.com/?cid=254652505180588642",
                "user_ratings_total" : 423,
                "utc_offset" : 0,
                "vicinity" : "Long Acre, London",
                "website" : "https://tfl.gov.uk/tube/stop/940GZZLUCGN/covent-garden-underground-station/?Input=Covent+Garden+Underground+Station"
             },
             "status" : "OK"
          }""", 200));

      final answer = await PlacesService().getPlace(placeId, description);
      expect(answer.description, description);
      expect(answer.geometry.location.lat, 51.51300070000001);
      expect(answer.geometry.location.lng,   -0.1241621);
    });

    test('Get place from invalid place id', () async {

      const placeId = "";
      const description = "Covent Garden, Long Acre, London, UK";
      const key = 'AIzaSyBcUJrLd8uIYR2HFTNa6mj-7lVRyUIJXs0';
      const url = "https://maps.googleapis.com/maps/api/place/details/json?key=$key&place_id=$placeId";

      final client = mock.MockClient();
      when(client.get(Uri.parse(url)))
          .thenAnswer((_) async =>
          http.Response("""{
           "error_message" : "Missing the placeid or reference parameter.",
           "html_attributions" : [],
           "status" : "INVALID_REQUEST"
        }""", 200));

      final answer = await PlacesService().getPlace(placeId, description);
      expect(answer.name, Place.placeNotFound().name);
      expect(answer.placeId, Place.placeNotFound().placeId);
      expect(answer.description, Place.placeNotFound().description);
      expect(answer.geometry.location.lat, Place.placeNotFound().geometry.location.lat);
      expect(answer.geometry.location.lng, Place.placeNotFound().geometry.location.lng);
    });
  });

  group('getPlaceFromCoordinates', ()
  {
    test('Get place from valid coordinates', () async {

      const lat = 51.5130007;
      const lng = -0.1241621;
      const description = "Covent Garden, Long Acre, London, UK";
      const key = 'AIzaSyBcUJrLd8uIYR2HFTNa6mj-7lVRyUIJXs0';
      var url =
          'https://maps.googleapis.com/maps/api/geocode/json?key=$key&latlng=$lat,$lng';

      final client = mock.MockClient();
      when(client.get(Uri.parse(url)))
          .thenAnswer((_) async =>
          http.Response("""{
             "plus_code" : {
                "compound_code" : "GV7G+684 London, UK",
                "global_code" : "9C3XGV7G+684"
             },
             "results" : [
                {
                   "address_components" : [
                      {
                         "long_name" : "Covent Garden",
                         "short_name" : "Covent Garden",
                         "types" : [
                            "establishment",
                            "point_of_interest",
                            "subway_station",
                            "transit_station"
                         ]
                      },
                      {
                         "long_name" : "Long Acre",
                         "short_name" : "Long Acre",
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
                         "long_name" : "WC2E 9JT",
                         "short_name" : "WC2E 9JT",
                         "types" : [ "postal_code" ]
                      }
                   ],
                   "formatted_address" : "Covent Garden, Long Acre, London WC2E 9JT, UK",
                   "geometry" : {
                      "location" : {
                         "lat" : 51.5130007,
                         "lng" : -0.1241621
                      },
                      "location_type" : "GEOMETRIC_CENTER",
                      "viewport" : {
                         "northeast" : {
                            "lat" : 51.5143496802915,
                            "lng" : -0.122813119708498
                         },
                         "southwest" : {
                            "lat" : 51.5116517197085,
                            "lng" : -0.125511080291502
                         }
                      }
                   },
                   "place_id" : "ChIJT2mIkcwEdkgRYspzsBq1iAM",
                   "plus_code" : {
                      "compound_code" : "GV7G+68 London, UK",
                      "global_code" : "9C3XGV7G+68"
                   },
                   "types" : [
                      "establishment",
                      "point_of_interest",
                      "subway_station",
                      "transit_station"
                   ]
                }
             ],
             "status" : "OK"
            }""", 200));

      final answer = await PlacesService().getPlaceFromCoordinates(lat, lng, description);
      expect(answer.placeId, "ChIJT2mIkcwEdkgRYspzsBq1iAM");
      expect(answer.description, description);
      expect(answer.geometry.location.lat, lat);
      expect(answer.geometry.location.lng, lng);
    });
    test('Get place from invalid coordinates', () async {

      const lat = 110000000.0;
      const lng = 100000000.0;
      const description = "Covent Garden, Long Acre, London, UK";
      const key = 'AIzaSyBcUJrLd8uIYR2HFTNa6mj-7lVRyUIJXs0';
      var url =
          'https://maps.googleapis.com/maps/api/geocode/json?key=$key&latlng=$lat,$lng';

      final client = mock.MockClient();
      when(client.get(Uri.parse(url)))
          .thenAnswer((_) async =>
          http.Response("""{
              "results" : [],
               "status" : "ZERO_RESULTS"
            }""", 200));

      final answer = await PlacesService().getPlaceFromCoordinates(lat, lng, description);
      expect(answer.placeId, Place.placeNotFound().placeId);
      expect(answer.name, Place.placeNotFound().name);
      expect(answer.placeId, Place.placeNotFound().placeId);
      expect(answer.description, Place.placeNotFound().description);
      expect(answer.geometry.location.lat, Place.placeNotFound().geometry.location.lat);
      expect(answer.geometry.location.lng, Place.placeNotFound().geometry.location.lng);
    });
  });

  group('getPlaceFromAddress', ()
  {
    test('Get place from valid address', () async {

      const address = "Covent Garden, Long Acre, London WC2E 9JT, UK";
      const description = "Covent Garden, Long Acre, London, UK";
      const key = 'AIzaSyBcUJrLd8uIYR2HFTNa6mj-7lVRyUIJXs0';
      var url =
          'https://maps.googleapis.com/maps/api/geocode/json?key=$key&address=$address';

      final client = mock.MockClient();
      when(client.get(Uri.parse(url)))
          .thenAnswer((_) async =>
          http.Response("""{
             "results" : [
                {
                   "address_components" : [
                      {
                         "long_name" : "Covent Garden",
                         "short_name" : "Covent Garden",
                         "types" : [
                            "establishment",
                            "point_of_interest",
                            "subway_station",
                            "transit_station"
                         ]
                      },
                      {
                         "long_name" : "Long Acre",
                         "short_name" : "Long Acre",
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
                         "long_name" : "WC2E 9JT",
                         "short_name" : "WC2E 9JT",
                         "types" : [ "postal_code" ]
                      }
                   ],
                   "formatted_address" : "Covent Garden, Long Acre, London WC2E 9JT, UK",
                   "geometry" : {
                      "location" : {
                         "lat" : 51.5130007,
                         "lng" : -0.1241621
                      },
                      "location_type" : "GEOMETRIC_CENTER",
                      "viewport" : {
                         "northeast" : {
                            "lat" : 51.5144103302915,
                            "lng" : -0.122841569708498
                         },
                         "southwest" : {
                            "lat" : 51.5117123697085,
                            "lng" : -0.125539530291502
                         }
                      }
                   },
                   "place_id" : "ChIJT2mIkcwEdkgRYspzsBq1iAM",
                   "plus_code" : {
                      "compound_code" : "GV7G+68 London, UK",
                      "global_code" : "9C3XGV7G+68"
                   },
                   "types" : [
                      "establishment",
                      "point_of_interest",
                      "subway_station",
                      "transit_station"
                   ]
                }
             ],
             "status" : "OK"
          }
          """, 200));

      final answer = await PlacesService().getPlaceFromAddress(address, description);
      expect(answer.description, description);
      expect(answer.geometry.location.lat, 51.5130007);
      expect(answer.geometry.location.lng,   -0.1241621);
      expect(answer.placeId, "ChIJT2mIkcwEdkgRYspzsBq1iAM");
    });
    test('Get place from invalid address', () async {

      const address = "";
      const description = "Covent Garden, Long Acre, London, UK";
      const key = 'AIzaSyBcUJrLd8uIYR2HFTNa6mj-7lVRyUIJXs0';
      var url =
          'https://maps.googleapis.com/maps/api/geocode/json?key=$key&address=$address';

      final client = mock.MockClient();
      when(client.get(Uri.parse(url)))
          .thenAnswer((_) async =>
          http.Response("""{
              "results" : [],
               "status" : "ZERO_RESULTS"
            }""", 200));

      final answer = await PlacesService().getPlaceFromAddress(address, description);
      expect(answer.placeId, Place.placeNotFound().placeId);
      expect(answer.name, Place.placeNotFound().name);
      expect(answer.placeId, Place.placeNotFound().placeId);
      expect(answer.description, Place.placeNotFound().description);
      expect(answer.geometry.location.lat, Place.placeNotFound().geometry.location.lat);
      expect(answer.geometry.location.lng, Place.placeNotFound().geometry.location.lng);
    });
  });
}