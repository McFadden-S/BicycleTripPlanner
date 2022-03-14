import 'package:bicycle_trip_planner/managers/DatabaseManager.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database_mocks/firebase_database_mocks.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  FirebaseDatabase firebaseDatabase;
  DatabaseManager databaseManager;

  setUpAll(() {
    firebaseDatabase = MockFirebaseDatabase.instance;
    databaseManager = DatabaseManager(firebaseDatabase);
  });

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



  test('Should get userName ...', () async {
    final userNameFromFakeDatabase = await databaseManager.getUserName(userId);
    expect(userNameFromFakeDatabase, equals(userName));
  });

  test('Should get user ...', () async {
    final userNameFromFakeDatabase = await databaseManager.getUser(userId);
    expect(
      userNameFromFakeDatabase,
      equals({
        'name': userName,
        'email': 'musk.email@tesla.com',
        'photoUrl': 'url-to-photo.jpg',
      }),
    );
  });
}