import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/pathway.dart';
import '../models/place.dart';
import '../models/stop.dart';

class Helper {
  static Map<String, Object> place2Map(Place place) {
    Map<String, Object> output = {};
    output['name'] = place.name;
    output['description'] = place.description;
    output['id'] = place.placeId;
    output['lng'] = place.latlng.longitude;
    output['lat'] = place.latlng.latitude;
    return output;
  }

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

  static Place mapToPlace(dynamic mapIn) {
    return Place(
        name: mapIn['name'],
        description: mapIn['description'],
        placeId: mapIn['id'],
        latlng: LatLng(mapIn['lat'], mapIn['lng'])
    );
  }
}
