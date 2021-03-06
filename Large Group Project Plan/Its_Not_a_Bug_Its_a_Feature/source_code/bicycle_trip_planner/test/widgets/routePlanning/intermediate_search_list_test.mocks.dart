// Mocks generated by Mockito 5.1.0 from annotations
// in bicycle_trip_planner/test/widgets/routePlanning/intermediate_search_list_test.dart.
// Do not manually edit this file.

import 'package:bicycle_trip_planner/managers/RouteManager.dart' as _i4;
import 'package:bicycle_trip_planner/models/bounds.dart' as _i5;
import 'package:bicycle_trip_planner/models/place.dart' as _i7;
import 'package:bicycle_trip_planner/models/route.dart' as _i2;
import 'package:bicycle_trip_planner/models/stop.dart' as _i3;
import 'package:google_maps_flutter/google_maps_flutter.dart' as _i6;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeRoute_0 extends _i1.Fake implements _i2.Route {}

class _FakeStop_1 extends _i1.Fake implements _i3.Stop {}

/// A class which mocks [RouteManager].
///
/// See the documentation for Mockito's code generation for more information.
class MockRouteManager extends _i1.Mock implements _i4.RouteManager {
  MockRouteManager() {
    _i1.throwOnMissingStub(this);
  }

  @override
  void moveCameraTo(_i2.Route? route,
          [_i5.Bounds? bounds = const _i5.Bounds.boundsNotFound()]) =>
      super.noSuchMethod(Invocation.method(#moveCameraTo, [route, bounds]),
          returnValueForMissingStub: null);
  @override
  dynamic setRouteMarker(_i6.LatLng? pos, [double? color = 0.0]) =>
      super.noSuchMethod(Invocation.method(#setRouteMarker, [pos, color]));
  @override
  void setRoutes(_i2.Route? startWalk, _i2.Route? bike, _i2.Route? endWalk) =>
      super.noSuchMethod(
          Invocation.method(#setRoutes, [startWalk, bike, endWalk]),
          returnValueForMissingStub: null);
  @override
  void showCurrentWalkingRoute([bool? relocateMap = true]) => super
      .noSuchMethod(Invocation.method(#showCurrentWalkingRoute, [relocateMap]),
          returnValueForMissingStub: null);
  @override
  void showCurrentRoute([bool? relocateMap = true]) =>
      super.noSuchMethod(Invocation.method(#showCurrentRoute, [relocateMap]),
          returnValueForMissingStub: null);
  @override
  void showBikeRoute([dynamic relocateMap = true]) =>
      super.noSuchMethod(Invocation.method(#showBikeRoute, [relocateMap]),
          returnValueForMissingStub: null);
  @override
  void setDirectionsData(_i2.Route? route) =>
      super.noSuchMethod(Invocation.method(#setDirectionsData, [route]),
          returnValueForMissingStub: null);
  @override
  void showAllRoutes([bool? relocateMap = true]) =>
      super.noSuchMethod(Invocation.method(#showAllRoutes, [relocateMap]),
          returnValueForMissingStub: null);
  @override
  void setLoading(bool? isLoading) =>
      super.noSuchMethod(Invocation.method(#setLoading, [isLoading]),
          returnValueForMissingStub: null);
  @override
  bool ifLoading() =>
      (super.noSuchMethod(Invocation.method(#ifLoading, []), returnValue: false)
          as bool);
  @override
  void setCurrentRoute(_i2.Route? route, [dynamic relocateMap = true]) => super
      .noSuchMethod(Invocation.method(#setCurrentRoute, [route, relocateMap]),
          returnValueForMissingStub: null);
  @override
  _i2.Route getCurrentRoute() =>
      (super.noSuchMethod(Invocation.method(#getCurrentRoute, []),
          returnValue: _FakeRoute_0()) as _i2.Route);
  @override
  bool ifRouteSet() => (super.noSuchMethod(Invocation.method(#ifRouteSet, []),
      returnValue: false) as bool);
  @override
  int getGroupSize() =>
      (super.noSuchMethod(Invocation.method(#getGroupSize, []), returnValue: 0)
          as int);
  @override
  void setGroupSize(int? size) =>
      super.noSuchMethod(Invocation.method(#setGroupSize, [size]),
          returnValueForMissingStub: null);
  @override
  bool ifWalkToFirstWaypoint() =>
      (super.noSuchMethod(Invocation.method(#ifWalkToFirstWaypoint, []),
          returnValue: false) as bool);
  @override
  void toggleWalkToFirstWaypoint() =>
      super.noSuchMethod(Invocation.method(#toggleWalkToFirstWaypoint, []),
          returnValueForMissingStub: null);
  @override
  void setWalkToFirstWaypoint(bool? ifWalk) =>
      super.noSuchMethod(Invocation.method(#setWalkToFirstWaypoint, [ifWalk]),
          returnValueForMissingStub: null);
  @override
  bool ifStartFromCurrentLocation() =>
      (super.noSuchMethod(Invocation.method(#ifStartFromCurrentLocation, []),
          returnValue: false) as bool);
  @override
  void toggleStartFromCurrentLocation() =>
      super.noSuchMethod(Invocation.method(#toggleStartFromCurrentLocation, []),
          returnValueForMissingStub: null);
  @override
  void setStartFromCurrentLocation(bool? value) => super.noSuchMethod(
      Invocation.method(#setStartFromCurrentLocation, [value]),
      returnValueForMissingStub: null);
  @override
  void setOptimised(bool? optimised) =>
      super.noSuchMethod(Invocation.method(#setOptimised, [optimised]),
          returnValueForMissingStub: null);
  @override
  void toggleOptimised() =>
      super.noSuchMethod(Invocation.method(#toggleOptimised, []),
          returnValueForMissingStub: null);
  @override
  bool ifOptimised() => (super.noSuchMethod(Invocation.method(#ifOptimised, []),
      returnValue: false) as bool);
  @override
  void setCostOptimised(bool? optimised) =>
      super.noSuchMethod(Invocation.method(#setCostOptimised, [optimised]),
          returnValueForMissingStub: null);
  @override
  void toggleCostOptimised() =>
      super.noSuchMethod(Invocation.method(#toggleCostOptimised, []),
          returnValueForMissingStub: null);
  @override
  bool ifCostOptimised() =>
      (super.noSuchMethod(Invocation.method(#ifCostOptimised, []),
          returnValue: false) as bool);
  @override
  _i3.Stop getStart() => (super.noSuchMethod(Invocation.method(#getStart, []),
      returnValue: _FakeStop_1()) as _i3.Stop);
  @override
  _i3.Stop getDestination() =>
      (super.noSuchMethod(Invocation.method(#getDestination, []),
          returnValue: _FakeStop_1()) as _i3.Stop);
  @override
  List<_i3.Stop> getWaypoints() =>
      (super.noSuchMethod(Invocation.method(#getWaypoints, []),
          returnValue: <_i3.Stop>[]) as List<_i3.Stop>);
  @override
  _i3.Stop getFirstWaypoint() =>
      (super.noSuchMethod(Invocation.method(#getFirstWaypoint, []),
          returnValue: _FakeStop_1()) as _i3.Stop);
  @override
  List<_i3.Stop> getStops() =>
      (super.noSuchMethod(Invocation.method(#getStops, []),
          returnValue: <_i3.Stop>[]) as List<_i3.Stop>);
  @override
  _i3.Stop getStop(int? id) =>
      (super.noSuchMethod(Invocation.method(#getStop, [id]),
          returnValue: _FakeStop_1()) as _i3.Stop);
  @override
  bool ifChanged() =>
      (super.noSuchMethod(Invocation.method(#ifChanged, []), returnValue: false)
          as bool);
  @override
  _i3.Stop getStopByIndex(int? index) =>
      (super.noSuchMethod(Invocation.method(#getStopByIndex, [index]),
          returnValue: _FakeStop_1()) as _i3.Stop);
  @override
  bool ifStartSet() => (super.noSuchMethod(Invocation.method(#ifStartSet, []),
      returnValue: false) as bool);
  @override
  bool ifDestinationSet() =>
      (super.noSuchMethod(Invocation.method(#ifDestinationSet, []),
          returnValue: false) as bool);
  @override
  bool ifFirstWaypointSet() =>
      (super.noSuchMethod(Invocation.method(#ifFirstWaypointSet, []),
          returnValue: false) as bool);
  @override
  bool ifWaypointsSet() =>
      (super.noSuchMethod(Invocation.method(#ifWaypointsSet, []),
          returnValue: false) as bool);
  @override
  void changeStart(_i7.Place? start) =>
      super.noSuchMethod(Invocation.method(#changeStart, [start]),
          returnValueForMissingStub: null);
  @override
  void changeDestination(_i7.Place? destination) =>
      super.noSuchMethod(Invocation.method(#changeDestination, [destination]),
          returnValueForMissingStub: null);
  @override
  void changeStop(int? id, _i7.Place? stop) =>
      super.noSuchMethod(Invocation.method(#changeStop, [id, stop]),
          returnValueForMissingStub: null);
  @override
  void swapStops(int? stop1ID, int? stop2ID) =>
      super.noSuchMethod(Invocation.method(#swapStops, [stop1ID, stop2ID]),
          returnValueForMissingStub: null);
  @override
  _i3.Stop addWaypoint(_i7.Place? waypoint) =>
      (super.noSuchMethod(Invocation.method(#addWaypoint, [waypoint]),
          returnValue: _FakeStop_1()) as _i3.Stop);
  @override
  _i3.Stop addCostWaypoint(_i7.Place? waypoint) =>
      (super.noSuchMethod(Invocation.method(#addCostWaypoint, [waypoint]),
          returnValue: _FakeStop_1()) as _i3.Stop);
  @override
  _i3.Stop addFirstWaypoint(_i7.Place? waypoint) =>
      (super.noSuchMethod(Invocation.method(#addFirstWaypoint, [waypoint]),
          returnValue: _FakeStop_1()) as _i3.Stop);
  @override
  void clearStart() => super.noSuchMethod(Invocation.method(#clearStart, []),
      returnValueForMissingStub: null);
  @override
  void clearDestination() =>
      super.noSuchMethod(Invocation.method(#clearDestination, []),
          returnValueForMissingStub: null);
  @override
  void clearStop(int? id) =>
      super.noSuchMethod(Invocation.method(#clearStop, [id]),
          returnValueForMissingStub: null);
  @override
  void clearFirstWaypoint() =>
      super.noSuchMethod(Invocation.method(#clearFirstWaypoint, []),
          returnValueForMissingStub: null);
  @override
  void removeStop(int? id) =>
      super.noSuchMethod(Invocation.method(#removeStop, [id]),
          returnValueForMissingStub: null);
  @override
  void removeWaypoints() =>
      super.noSuchMethod(Invocation.method(#removeWaypoints, []),
          returnValueForMissingStub: null);
  @override
  void clearPathwayMarkers() =>
      super.noSuchMethod(Invocation.method(#clearPathwayMarkers, []),
          returnValueForMissingStub: null);
  @override
  void clearChanged() =>
      super.noSuchMethod(Invocation.method(#clearChanged, []),
          returnValueForMissingStub: null);
  @override
  void clearRoutes() => super.noSuchMethod(Invocation.method(#clearRoutes, []),
      returnValueForMissingStub: null);
  @override
  void clear() => super.noSuchMethod(Invocation.method(#clear, []),
      returnValueForMissingStub: null);
  @override
  _i2.Route getStartWalkingRoute() =>
      (super.noSuchMethod(Invocation.method(#getStartWalkingRoute, []),
          returnValue: _FakeRoute_0()) as _i2.Route);
  @override
  _i2.Route getBikingRoute() =>
      (super.noSuchMethod(Invocation.method(#getBikingRoute, []),
          returnValue: _FakeRoute_0()) as _i2.Route);
  @override
  _i2.Route getEndWalkingRoute() =>
      (super.noSuchMethod(Invocation.method(#getEndWalkingRoute, []),
          returnValue: _FakeRoute_0()) as _i2.Route);
  @override
  bool getCostOptimised() =>
      (super.noSuchMethod(Invocation.method(#getCostOptimised, []),
          returnValue: false) as bool);
  @override
  bool getLoading() => (super.noSuchMethod(Invocation.method(#getLoading, []),
      returnValue: false) as bool);
}
