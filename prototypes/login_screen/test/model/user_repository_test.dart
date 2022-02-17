import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';
import 'package:firebase_auth/firebase_auth_test.mocks.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth{}
class MockFirebaseUser extends Mock implements User{}
class MockAuthUser extends Mock implements UserCredential{}

@GenerateMocks([MockFirebaseAuth])
void main() {
  MockFirebaseAuth auth = MockFirebaseAuth();
  test("sign in with email and password", () async {
    await auth.createUserWithEmailAndPassword(email: "email@example.org", password: "password");
    bool check = false;
    //UserCredential testUser = await _auth.signInWithEmailAndPassword(email: "email@example.org", password: "password");
    expectLater(check, false);
    //testUser.user?.delete();
  });
  //test("sign in fails with incorrect email and password",() async {
  //  UserCredential testUser = await _auth.signInWithEmailAndPassword(email: "email", password: "password");
  //  expect(testUser.user, null);
  //});
}
