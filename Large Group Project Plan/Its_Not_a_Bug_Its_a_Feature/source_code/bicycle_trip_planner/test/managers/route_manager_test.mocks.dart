// Mocks generated by Mockito 5.1.0 from annotations
// in bicycle_trip_planner/test/managers/route_manager_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i6;

import 'package:bicycle_trip_planner/bloc/application_bloc.dart' as _i9;
import 'package:bicycle_trip_planner/managers/CameraManager.dart' as _i5;
import 'package:bicycle_trip_planner/managers/LocationManager.dart' as _i3;
import 'package:bicycle_trip_planner/managers/MarkerManager.dart' as _i4;
import 'package:bicycle_trip_planner/models/place.dart' as _i7;
import 'package:bicycle_trip_planner/models/station.dart' as _i8;
import 'package:google_maps_flutter/google_maps_flutter.dart' as _i2;
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

class _FakeGoogleMapController_0 extends _i1.Fake
    implements _i2.GoogleMapController {}

class _FakeLocationManager_1 extends _i1.Fake implements _i3.LocationManager {}

class _FakeMarkerManager_2 extends _i1.Fake implements _i4.MarkerManager {}

class _FakeMarker_3 extends _i1.Fake implements _i2.Marker {}

/// A class which mocks [CameraManager].
///
/// See the documentation for Mockito's code generation for more information.
class MockCameraManager extends _i1.Mock implements _i5.CameraManager {
  MockCameraManager() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.GoogleMapController get googleMapController => (super.noSuchMethod(
      Invocation.getter(#googleMapController),
      returnValue: _FakeGoogleMapController_0()) as _i2.GoogleMapController);
  @override
  set googleMapController(_i2.GoogleMapController? _googleMapController) =>
      super.noSuchMethod(
          Invocation.setter(#googleMapController, _googleMapController),
          returnValueForMissingStub: null);
  @override
  _i3.LocationManager get locationManager =>
      (super.noSuchMethod(Invocation.getter(#locationManager),
          returnValue: _FakeLocationManager_1()) as _i3.LocationManager);
  @override
  _i4.MarkerManager get markerManager =>
      (super.noSuchMethod(Invocation.getter(#markerManager),
          returnValue: _FakeMarkerManager_2()) as _i4.MarkerManager);
  @override
  set markerManager(_i4.MarkerManager? _markerManager) =>
      super.noSuchMethod(Invocation.setter(#markerManager, _markerManager),
          returnValueForMissingStub: null);
  @override
  bool get locationViewed => (super
          .noSuchMethod(Invocation.getter(#locationViewed), returnValue: false)
      as bool);
  @override
  set locationViewed(bool? _locationViewed) =>
      super.noSuchMethod(Invocation.setter(#locationViewed, _locationViewed),
          returnValueForMissingStub: null);
  @override
  void init() => super.noSuchMethod(Invocation.method(#init, []),
      returnValueForMissingStub: null);
  @override
  void dispose() => super.noSuchMethod(Invocation.method(#dispose, []),
      returnValueForMissingStub: null);
  @override
  void setCameraBounds(_i2.LatLng? southwest, _i2.LatLng? northeast) => super
      .noSuchMethod(Invocation.method(#setCameraBounds, [southwest, northeast]),
          returnValueForMissingStub: null);
  @override
  void setCameraPosition(_i2.LatLng? position, {double? zoomIn = 16.0}) =>
      super.noSuchMethod(
          Invocation.method(#setCameraPosition, [position], {#zoomIn: zoomIn}),
          returnValueForMissingStub: null);
  @override
  void setRouteCamera(_i2.LatLng? origin, Map<String, dynamic>? boundsSw,
          Map<String, dynamic>? boundsNe) =>
      super.noSuchMethod(
          Invocation.method(#setRouteCamera, [origin, boundsSw, boundsNe]),
          returnValueForMissingStub: null);
  @override
  _i6.Future<void> goToPlace(_i2.LatLng? latLng, Map<String, dynamic>? boundsNe,
          Map<String, dynamic>? boundsSw) =>
      (super.noSuchMethod(
          Invocation.method(#goToPlace, [latLng, boundsNe, boundsSw]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i6.Future<void>);
  @override
  _i6.Future<void> viewPlace(_i7.Place? place) =>
      (super.noSuchMethod(Invocation.method(#viewPlace, [place]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i6.Future<void>);
  @override
  _i6.Future<void> viewRoute() =>
      (super.noSuchMethod(Invocation.method(#viewRoute, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i6.Future<void>);
  @override
  void viewUser({double? zoomIn = 16.0}) =>
      super.noSuchMethod(Invocation.method(#viewUser, [], {#zoomIn: zoomIn}),
          returnValueForMissingStub: null);
  @override
  void userLocated() => super.noSuchMethod(Invocation.method(#userLocated, []),
      returnValueForMissingStub: null);
  @override
  bool isLocated() =>
      (super.noSuchMethod(Invocation.method(#isLocated, []), returnValue: false)
          as bool);
}

/// A class which mocks [MarkerManager].
///
/// See the documentation for Mockito's code generation for more information.
class MockMarkerManager extends _i1.Mock implements _i4.MarkerManager {
  MockMarkerManager() {
    _i1.throwOnMissingStub(this);
  }

  @override
  set userMarkerIcon(_i2.BitmapDescriptor? _userMarkerIcon) =>
      super.noSuchMethod(Invocation.setter(#userMarkerIcon, _userMarkerIcon),
          returnValueForMissingStub: null);
  @override
  _i6.Stream<Set<_i2.Marker>> get mapMarkerStream =>
      (super.noSuchMethod(Invocation.getter(#mapMarkerStream),
              returnValue: Stream<Set<_i2.Marker>>.empty())
          as _i6.Stream<Set<_i2.Marker>>);
  @override
  void setMarker(_i2.LatLng? point, String? markerID, [double? color = 0.0]) =>
      super.noSuchMethod(
          Invocation.method(#setMarker, [point, markerID, color]),
          returnValueForMissingStub: null);
  @override
  void removeMarker(String? markerID) =>
      super.noSuchMethod(Invocation.method(#removeMarker, [markerID]),
          returnValueForMissingStub: null);
  @override
  Set<_i2.Marker> getMarkers() =>
      (super.noSuchMethod(Invocation.method(#getMarkers, []),
          returnValue: <_i2.Marker>{}) as Set<_i2.Marker>);
  @override
  _i2.Marker getUserMarker() =>
      (super.noSuchMethod(Invocation.method(#getUserMarker, []),
          returnValue: _FakeMarker_3()) as _i2.Marker);
  @override
  void clearMarker(int? uid) =>
      super.noSuchMethod(Invocation.method(#clearMarker, [uid]),
          returnValueForMissingStub: null);
  @override
  void setPlaceMarker(_i7.Place? place, [int? uid = -1]) =>
      super.noSuchMethod(Invocation.method(#setPlaceMarker, [place, uid]),
          returnValueForMissingStub: null);
  @override
  void setStationMarkerWithUID(
          _i8.Station? station, _i9.ApplicationBloc? appBloc,
          [int? uid = -1]) =>
      super.noSuchMethod(
          Invocation.method(#setStationMarkerWithUID, [station, appBloc, uid]),
          returnValueForMissingStub: null);
  @override
  _i6.Future<_i2.Marker> setUserMarker(_i2.LatLng? point) =>
      (super.noSuchMethod(Invocation.method(#setUserMarker, [point]),
              returnValue: Future<_i2.Marker>.value(_FakeMarker_3()))
          as _i6.Future<_i2.Marker>);
  @override
  void setStationMarker(_i8.Station? station, _i9.ApplicationBloc? appBloc) =>
      super.noSuchMethod(
          Invocation.method(#setStationMarker, [station, appBloc]),
          returnValueForMissingStub: null);
  @override
  void setStationMarkers(
          List<_i8.Station>? stations, _i9.ApplicationBloc? appBloc) =>
      super.noSuchMethod(
          Invocation.method(#setStationMarkers, [stations, appBloc]),
          returnValueForMissingStub: null);
  @override
  void clearStationMarkers(List<_i8.Station>? stations) =>
      super.noSuchMethod(Invocation.method(#clearStationMarkers, [stations]),
          returnValueForMissingStub: null);
}
