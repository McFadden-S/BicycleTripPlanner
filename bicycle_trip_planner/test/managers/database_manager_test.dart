import 'dart:math';

import 'package:bicycle_trip_planner/managers/DatabaseManager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database_mocks/firebase_database_mocks.dart';
import 'package:flutter/cupertino.dart';
import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';

import 'firebase_mocks/firebase_auth_mocks.dart';

Future<void> main() async {

  setupFirebaseMocks();
  setupFirebaseAuthMocks();



  await Firebase.initializeApp();

  const userId = 'userId';
  const userName = 'Elon musk';
  const favouriteRouteId = 'routeID';
  final favouriteStationsID = 158;
  final favouriteStationsID2 = 250;
  const description = "description";
  const routeID = "endRouteID";
  const lat = 50.54631;
  const lng = -0.15413;
  const name = "locationName";
  final fakeData = {
    'users': {
      userId: {
        'favouriteRoutes': {
          favouriteRouteId: {
            'end':{
              'description':description,
              'id':routeID,
              'lat':lat,
              'lng':lng,
              'name': name
            },
            'start':{
              'description':description,
              'id':routeID,
              'lat': lat,
              'lng': lng,
              'name': name
            },
            'stops':[
              {
                'description':description,
                'id':routeID,
                'lat': lat,
                'lng': lng,
                'name': name
              }
            ]
          },
        },
        'favouriteStations': {
          favouriteStationsID.toString(): favouriteStationsID,
          favouriteStationsID2.toString(): favouriteStationsID2
        }
      }
    }
  };
  MockFirebaseDatabase().ref().set(fakeData);

  var database = MockFirebaseDatabase();
  var auth = MockFirebaseAuth();
  late final databaseManager;



  MockFirebaseDatabase.instance.ref().set(fakeData);
  setUp(() async {
    WidgetsFlutterBinding.ensureInitialized();

    final googleSignIn = MockGoogleSignIn();
    final signinAccount = await googleSignIn.signIn();
    final googleAuth = await signinAccount?.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final user = MockUser(
      isAnonymous: false,
      uid: userId,
      email: 'bob@somedomain.com',
      displayName: 'Bob',
    );
    auth = MockFirebaseAuth(mockUser: user);
    final result = await auth.signInWithCredential(credential);
    database.ref().set(fakeData);
    databaseManager = DatabaseManager.forMock(database, auth);
  });

  test('Get favourite stations', () async {
    final stationsFromFakeDatabase = await databaseManager.getFavouriteStations();
    var mockStations = fakeData['users']!['userId']!['favouriteStations']?.values.toList();
    expect(ListEquality().equals(stationsFromFakeDatabase, mockStations), true);
  });

  test('Get favourite routes', () async {
    final routeFromFakeDatabase = await databaseManager.getFavouriteRoutes();
    var mockRoute = fakeData['users']!['userId']!['favouriteRoutes'];
    expect(routeFromFakeDatabase.length, mockRoute?.length);
    expect(DeepCollectionEquality().equals(routeFromFakeDatabase[routeID], mockRoute![routeID]), true);
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

    await databaseManager.addToFavouriteStations(favouriteStationsID);

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