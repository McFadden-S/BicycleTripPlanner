import 'package:test/test.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/models/stop.dart';

void main(){
  final routeManager = RouteManager();

  test('ensure that group size is 1 when initialized', (){
    expect(routeManager.getGroupSize(), 1);
  });

  test('ensure that group size can be set when needed', (){
    routeManager.setGroupSize(2);
    expect(routeManager.getGroupSize(), 2);
  });

  test('ensure optimised is true when initialized', (){
    expect(routeManager.ifOptimised(), true);
  });

  test('ensure optimised can be toggled when requested', (){
    routeManager.toggleOptimised();
    expect(routeManager.ifOptimised(), false);
  });

  test('ensure that start is empty when initialized', (){
    expect(routeManager.getStart().getStop(), "");
  });

  test('ensure that destination is empty when initialized', (){
    expect(routeManager.getDestination().getStop(), "");
  });

  test('ensure that waypoints are empty when initialized', (){
    expect(routeManager.getWaypoints().length, 0);
  });

  test('ensure that start is changed when requested', (){
    routeManager.changeStart("Bush House");
    expect(routeManager.getStart().getStop(), "Bush House");
    expect(routeManager.ifChanged(), true);
    expect(routeManager.ifStartSet(), true);
  });

  test('ensure that start can be cleared when requested', (){
    routeManager.clearStart();
    expect(routeManager.getStart().getStop(), "");
    expect(routeManager.ifChanged(), true);
    routeManager.clearChanged();
    expect(routeManager.ifChanged(), false);
    expect(routeManager.ifStartSet(), false);
  });

  test('ensure that destination is changed when requested', (){
    routeManager.changeDestination("Bush House");
    expect(routeManager.getDestination().getStop(), "Bush House");
    expect(routeManager.ifChanged(), true);
    expect(routeManager.ifDestinationSet(), true);
  });

  test('ensure that destination can be cleared when requested', (){
    routeManager.clearDestination();
    expect(routeManager.getDestination().getStop(), "");
    routeManager.clearChanged();
    expect(routeManager.ifChanged(), false);
    expect(routeManager.ifDestinationSet(), false);
  });

  test('ensure that can add waypoint when requested', (){
    expect(routeManager.getWaypoints().length, 0);
    routeManager.addWaypoint("Bush House");
    expect(routeManager.getWaypoints().length, 1);
    expect(routeManager.ifWaypointsSet(), true);
  });

  test('ensure that number of waypoints do not changed when existing id is changed', (){
    expect(routeManager.getWaypoints().length, 1);
    routeManager.changeWaypoint(1, "Strand");
    expect(routeManager.getWaypoints().length, 1);
  });

  test('ensure can clear waypoint using id', (){
    routeManager.clearStop(1);
    expect(routeManager.getStop(1).getStop(), "");
    expect(routeManager.getWaypoints().length, 1);
  });

  test('ensure can remove waypoint using id', (){
    routeManager.removeStop(1);
    expect(routeManager.getWaypoints().length, 0);
  });

  test('ensure can clear waypoints when requested', (){
    routeManager.addWaypoint("Bush House");
    expect(routeManager.getWaypoints().length, 1);
    routeManager.removeWaypoints();
    expect(routeManager.getWaypoints().length, 0);
  });

}