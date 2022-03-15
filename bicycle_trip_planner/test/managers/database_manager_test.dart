import 'package:bicycle_trip_planner/managers/DatabaseManager.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database_mocks/firebase_database_mocks.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  DatabaseManager databaseManager = DatabaseManager();
  FirebaseDatabase firebaseDatabase = MockFirebaseDatabase.instance;
  // Put fake data
  const userId = 'userId';
  const userName = 'Elon musk';
  const favouriteRouteId = "routeID";
  const favouriteStationsID = "158";
  const description = "description";
  const routeID = "endRouteID";
  const lat = "50.54631";
  const lng = "-0.15413";
  const name = "locationName";

  const fakeData = {
    'users': {
      userId: {
        'favouriteRoutes': {
          favouriteRouteId: {
            'end':{
              'description':{description},
              'id':{routeID},
              'lat': {lat},
              'lng': {lng},
              'name': {name}
            },
            'start':{
              'description':{description},
              'id':{routeID},
              'lat': {lat},
              'lng': {lng},
              'name': {name}
            },
            'stops':{
              0: {
                'description':{description},
                'id':{routeID},
                'lat': {lat},
                'lng': {lng},
                'name': {name}
              }
            }
          },
          'favouriteStations': {
            favouriteStationsID: {favouriteStationsID}
          }
        }
      }
    }
  };

  MockFirebaseDatabase.instance.ref().set(fakeData);


  test('Get favourite station', () async {
    final stationFromFakeDatabase = await databaseManager.getFavouriteStations();
    expect(stationFromFakeDatabase.first.toString(), equals(favouriteStationsID));
  });

  test('Get favourite routes', () async {
    final routeFromFakeDatabase = await databaseManager.getFavouriteRoutes();
    //Need to create the pathway object
    expect(
      routeFromFakeDatabase,
      equals({
        'name': userName,
        'email': 'musk.email@tesla.com',
        'photoUrl': 'url-to-photo.jpg',
      }),
    );
  });

  test(,)
}