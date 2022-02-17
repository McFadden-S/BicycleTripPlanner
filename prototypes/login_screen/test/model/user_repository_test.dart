import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth{}
class MockFirebaseUser extends Mock implements User{}
class MockAuthUser extends Mock implements UserCredential{}


void main() {
  MockFirebaseAuth _auth = MockFirebaseAuth();
  BehaviorSubject<MockFirebaseUser> _user = BehaviorSubject<MockFirebaseUser>();
  when(_auth.authStateChanges()).thenAnswer((_){
    return _user;
  });

  String? x  = FirebaseAuth.instance.currentUser?.uid;
  group('user repository test', (){
    when(_auth.signInWithEmailAndPassword(email: "email",password: "password")).thenAnswer((_)async{
      _user.add(MockFirebaseUser());
      return MockAuthUser();
    });
    when(_auth.signInWithEmailAndPassword(email: "mail",password: "pass")).thenThrow((){
      return null;
    });

    test("sign in with email and password", () async {
      await _auth.createUserWithEmailAndPassword(email: "email", password: "password");
      UserCredential testUser = await _auth.signInWithEmailAndPassword(email: "email", password: "password");
      bool check = false;
      if (testUser.user!= null){
        check = true;
      }
      expect(check, true);
      //testUser.user?.delete();
    });


    test("sign in fails with incorrect email and password",() async {
      UserCredential testUser = await _auth.signInWithEmailAndPassword(email: "email", password: "password");



    });

    test('sign out', ()async{
      await _repo.signOut();
      expect(_repo.status, Status.Unauthenticated);
    });
  });
}
