import 'package:bicycle_trip_planner/models/place.dart';
import 'package:bicycle_trip_planner/models/stop.dart';
import 'package:test/test.dart';
import 'package:bicycle_trip_planner/models/pathway.dart';
import 'package:bicycle_trip_planner/models/location.dart';
import 'package:bicycle_trip_planner/models/geometry.dart';


main(){
  final pathway = Pathway();
  final stop = Stop();
  final stop2 = Stop();
  final location = Location(lat: 1, lng: -1);
  final geometry = Geometry(location: location);
  final place = Place(geometry: geometry, name: "Bush House", placeId: "1", description: "");
  final place2 = Place(geometry: geometry, name: "Strand", placeId: "1", description: "");

  // setUp((){
  //   pathway.clear();
  // });

  test("Stops to string", (){
    expect(pathway.toString(), "[ - 1,  - 2]");
  });

  test('ensure can get stop by index', (){
    expect(pathway.getStopByIndex(0).getUID(), 1);
  });

  test('ensure size is 2 when initialized', (){
    expect(pathway.getStops().length, 2);
  });

  test("ensure stop can be got from id",(){
    expect(pathway.getStop(1).getUID(), 1);
  });

  test('ensure there are 2 stops when initialized', (){
    expect(pathway.getStops().length, 2);
  });

  test('ensure start is a Stop', (){
    expect(pathway.getStart().runtimeType, Stop);
  });

  test('ensure destination is a Stop', (){
    expect(pathway.getDestination().runtimeType, Stop);
  });

  test("ensure you can get all waypoints",(){
    pathway.addStop(Stop());
    pathway.addStop(Stop());
    pathway.addStop(Stop());
    expect(pathway.getWaypoints().length, 3);

  });

  test('ensure firstWaypoint is a stop', (){
    expect(pathway.getFirstWaypoint().runtimeType, Stop);
  });

  test('ensure can add and remove firstWaypoint on request', (){
    pathway.clear();
    pathway.addFirstWayPoint(stop);
    expect(pathway.getFirstWaypoint(), stop);
    pathway.setHasFirstWaypoint(true);
    expect(pathway.getStops().length, 3);
    pathway.removeFirstWayPoint();
    expect(pathway.getStops().length, 2);
  });

  test('ensure can add start and clear on request', (){
    pathway.clear();
    pathway.addStart(stop);
    expect(pathway.getStops().length, 3);
    expect(pathway.getStart(), stop);
    pathway.clearStart();
    expect(pathway.getStops().length, 3);
  });

  test('ensure can change start on request', (){
    pathway.addStart(stop);
    expect(pathway.getStart().getStop().name, "");
    pathway.changeStart(place);
    expect(pathway.getStart().getStop().name, "Bush House");
  });

  test('ensure can change destination on request', (){
    expect(pathway.getDestination().getStop().name, "");
    pathway.changeDestination(place2);
    expect(pathway.getDestination().getStop().name, "Strand");
  });

  test('ensure can clear destination on request', (){
    pathway.changeDestination(place2);
    expect(pathway.getDestination().getStop().name, "Strand");
    pathway.clearDestination();
    expect(pathway.getDestination().getStop().name, "");
  });

  test('ensure can add stop on request', (){
    pathway.addStop(stop2);
    expect(pathway.getStops().length, 5);
  });

  test("ensure can add waypoint on request",(){
    pathway.addWaypoint(stop);
    expect(pathway.getStopByIndex(pathway.getStops().length-1).getUID(), stop.getUID());
  });

  test('ensure can remove stop on request', (){
    expect(pathway.getStops().length, 6);
    pathway.removeStop(4);
    expect(pathway.getStops().length, 5);
  });

  test('ensure can swap stops', (){
    pathway.clear();
    pathway.changeStop(pathway.getStopByIndex(0).getUID(), place2);
    pathway.changeStop(pathway.getStopByIndex(1).getUID(), place);

    expect(pathway.getStopByIndex(0).getStop().name, "Strand");
    expect(pathway.getStopByIndex(1).getStop().name, "Bush House");

    pathway.swapStops(pathway.getStopByIndex(0).getUID(), pathway.getStopByIndex(1).getUID());
    expect(pathway.getStopByIndex(0).getStop().name, "Bush House");
    expect(pathway.getStopByIndex(1).getStop().name, "Strand");
  });

  test("Set has first waypoint",(){
    expect(pathway.getHasFirstWaypoint(),false);
    pathway.setHasFirstWaypoint(true);
    expect(pathway.getHasFirstWaypoint(),true);
    pathway.setHasFirstWaypoint(false);
    expect(pathway.getHasFirstWaypoint(),false);
  });

  test("Toggle has first waypoint",(){
    expect(pathway.getHasFirstWaypoint(), false);
    pathway.toggleHasFirstWaypoint();
    expect(pathway.getHasFirstWaypoint(), true);
    pathway.toggleHasFirstWaypoint();
    expect(pathway.getHasFirstWaypoint(), false);
  });

  test("Move stop",(){
    pathway.getStops().first.getUID();
    final initID = pathway.getStops().first.getUID();

    pathway.moveStop(initID, 2);
    expect(pathway.getStops()[1].getUID(), initID);
  });
}