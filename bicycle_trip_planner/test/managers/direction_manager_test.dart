import 'package:bicycle_trip_planner/models/steps.dart';
import 'package:test/test.dart';
import 'package:bicycle_trip_planner/managers/DirectionManager.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_trip_planner/constants.dart';

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

  test('ensure isCycling is false when initialized', () {
    expect(directionManager.ifCycling(), false);
  });

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

  // Test that showing bike directions works... (Make dummy route... and then check own directions are the same as route...)

  // void toggleCycling() {
  //   _isCycling = !_isCycling;
  //   if (_isCycling) {
  //     print("Showing bike route...");
  //     RouteManager().showBikeRoute();
  //   } else {
  //     RouteManager().showCurrentWalkingRoute();
  //   }
  // }

  //test detecting null for the doubles when the doubles are all set in line 163/164 of direction manager
  // test('ensure that first direction and be removed and return next direction', (){
  //   final bounds = Bounds(northeast: {"a": 1}, southwest: {"b": 2});
  //   final startLocation = Location(lat: 155.1, lng: -12.3);
  //   final endLocation = Location(lat: 234.2, lng: -24.3);
  //   final steps = Steps(instruction: "right", distance: 1, duration: 1);
  //   final polyline = OverviewPolyline(points: []);
  //   final legs = [Legs(startLocation: startLocation, endLocation: endLocation, steps: [steps], distance: 1, duration: 1), Legs(startLocation: startLocation, endLocation: endLocation, steps: [steps], distance: 2, duration: 2), Legs(startLocation: startLocation, endLocation: endLocation, steps: [steps], distance: 2, duration: 2)];
  //   final route = Route(bounds: bounds, legs: legs, polyline: polyline);
  //   directionManager.setCurrentRoute(route);
  //   expect(directionManager.getNumberOfDirections(),2);
  //   final currentDirection = directionManager.getDirections()[0];
  //   expect(directionManager.popDirection().instruction, currentDirection.instruction);
  //   expect(directionManager.getNumberOfDirections(), 1);
  // });
}
