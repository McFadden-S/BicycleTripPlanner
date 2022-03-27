import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/pathway.dart';
import '../models/place.dart';
import '../models/stop.dart';

/// Class Comment:
/// Helper is a manager class that contains static methods which are responsible
/// for object conversion

class Helper {

  //********** Static **********

  /// @param - Place; a place to be converted into a map
  /// @return Map<String, Object>; converts place into map
  static Map<String, Object> place2Map(Place place) {
    Map<String, Object> output = {};
    output['name'] = place.name;
    output['description'] = place.description;
    output['id'] = place.placeId;
    output['lng'] = place.latlng.longitude;
    output['lat'] = place.latlng.latitude;
    return output;
  }

  /// @param - dynamic; a map to be converted into a pathway containing
  ///                   a start, end and (possibly) intermediate stops
  /// @return Pathway; a route devised from the mapIn parameter
  static Pathway mapToPathway(dynamic mapIn) {
    Pathway output = Pathway();
    output.changeStart(mapToPlace(mapIn['start']));
    output.changeDestination(mapToPlace(mapIn['end']));
    if (mapIn['stops'] != null) {
      for (var stop in mapIn['stops']) {
        output.addWaypoint(Stop(mapToPlace(stop)));
      }
    }
    return output;
  }

  /// @param - dynamic; a map to be converted into a place
  /// @return Place; converts a map to a place
  static Place mapToPlace(dynamic mapIn) {
    return Place(
        name: mapIn['name'],
        description: mapIn['description'],
        placeId: mapIn['id'],
        latlng: LatLng(mapIn['lat'], mapIn['lng'])
    );
  }
}
