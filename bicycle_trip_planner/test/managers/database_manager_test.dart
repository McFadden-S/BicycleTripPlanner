import 'dart:math';

import 'package:bicycle_trip_planner/managers/DatabaseManager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database_mocks/firebase_database_mocks.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_firebase.dart';

void main() {

  late DatabaseManager databaseManager;
  late FirebaseAuth auth;

  const favouriteRouteId = "routeID";
  const favouriteStationsID = "158";
  const description = "description";
  const routeID = "endRouteID";
  const lat = "50.54631";
  const lng = "-0.15413";
  const name = "locationName";

  FirebaseDatabase firebaseDatabase;
  // Put fake data
  const userId = 'userId';
  const userName = 'Elon musk';
  const fakeData = {
    'users': {
      userId: {
        'name': userName,
        'email': 'musk.email@tesla.com',
        'photoUrl': 'url-to-photo.jpg',
      },
      'otherUserId': {
        'name': 'userName',
        'email': 'othermusk.email@tesla.com',
        'photoUrl': 'other_url-to-photo.jpg',
      }
    }
  };

  MockFirebaseDatabase.instance.ref().set(fakeData);
  setupFirebaseMocks();
  setupFirebaseAuthMocks();
  setupFirebaseDatabaseMocks();
  setUpAll(() async {
    WidgetsFlutterBinding.ensureInitialized();
    firebaseDatabase = MockFirebaseDatabase.instance;
    final app = await Firebase.initializeApp(
      name: '1',
      options: const FirebaseOptions(
        apiKey: '',
        appId: '',
        messagingSenderId: '',
        projectId: '',
      ),
    );

    final user = MockUser(
      isAnonymous: false,
      uid: 'someuid',
      email: 'bob@somedomain.com',
      displayName: 'Bob',
    );
    auth = MockFirebaseAuth(mockUser: user);



    databaseManager = DatabaseManager.forMock(MockFirebaseDatabase(), MockFirebaseAuth(mockUser: user));
  });

  test('Get favourite station', () async {
    final stationFromFakeDatabase = await databaseManager.getFavouriteStations();
    expect(stationFromFakeDatabase.first.toString(), equals(favouriteStationsID));
  });

  test('Get favourite routes', () async {
    final routeFromFakeDatabase = await databaseManager.getFavouriteRoutes();
    //Need to create the pathway object
    expect(
      routeFromFakeDatabase,
      equals(""),
    );
  });

  test('Remove favourite station',() async{
    await databaseManager.removeFavouriteStation(favouriteStationsID);
    final stationFromFakeDatabase = await databaseManager.getFavouriteStations();
    expect(stationFromFakeDatabase, equals(null));
  });

  test('Remove favourite route',()async{
    await databaseManager.removeFavouriteRoute(routeID);
    final stationFromFakeDatabase = await databaseManager.getFavouriteRoutes();
    expect(stationFromFakeDatabase, equals(null));
  });

  test('Add favourite station',()async{
    final initialStationFromFakeDatabase = await databaseManager.getFavouriteStations();
    expect(initialStationFromFakeDatabase, equals(null));

    await databaseManager.addToFavouriteStations(int.parse(favouriteStationsID));

    final stationFromFakeDatabase = await databaseManager.getFavouriteStations();
    expect(stationFromFakeDatabase.first.toString(), equals(favouriteStationsID));
  });

  test('Add favourite route',() async{
    final stationFromFakeDatabase = await databaseManager.getFavouriteRoutes();
    expect(stationFromFakeDatabase, equals(null));

    //await databaseManager.addToFavouriteRoutes(start, end, stops)
    //Need to add place data to create test
  });

}