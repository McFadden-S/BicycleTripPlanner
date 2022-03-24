import 'package:bicycle_trip_planner/models/place.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test/test.dart';
import 'package:bicycle_trip_planner/models/stop.dart';

main(){
  final stop = Stop();

  test('ensure uid is an int', (){
    expect(stop.getUID().runtimeType, int);
  });

  test('ensure stop is a Place', (){
    expect(stop.getStop().runtimeType, Place);
  });

  test('ensure initial uid is 0', (){
    expect(stop.getUID(), 0);
  });

  test('ensure overriden toString is correct', (){
    expect(stop.toString(), " - 0");
  });

  test('ensure can set a stop', (){
    const location = LatLng(1, -1);
    final place = Place(latlng: location, name: "Bush House", placeId: "1", description: "");
    stop.setStop(place);
    expect(stop.getStop().name, "Bush House");
  });

}