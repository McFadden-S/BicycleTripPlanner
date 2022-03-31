import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'bloc/application_bloc_test.mocks.dart';
var locationManager = MockLocationManager();
var placesServices = MockPlacesService();
var directionsService = MockDirectionsService();
var stationManager = MockStationManager();
var dialogManager = MockDialogManager();
var userSettings = MockUserSettings();
var cameraManager = MockCameraManager();
var markerManager = MockMarkerManager();
var mockRouteManager = MockRouteManager();
var mockNavigationManager = MockNavigationManager();
var stationsService = MockStationsService();
var directionManager = MockDirectionManager();
var databaseManager = MockDatabaseManager();
var appBloc = ApplicationBloc.forMock(
    dialogManager,
    placesServices,
    locationManager,
    userSettings,
    cameraManager,
    markerManager,
    mockRouteManager,
    mockNavigationManager,
    directionsService,
    stationManager,
    stationsService,
    directionManager,
    databaseManager
);

pumpWidget(WidgetTester tester, Widget? home) async {
  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ListenableProvider(create: (context) => appBloc),
      ],
      builder: (context, child) {
        return MaterialApp(home: home);
      },
    ),
  );
}

ApplicationBloc getAppBloc(){
  return appBloc;
}