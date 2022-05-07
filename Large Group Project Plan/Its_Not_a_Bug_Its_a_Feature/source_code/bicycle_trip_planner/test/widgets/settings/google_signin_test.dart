import 'package:bicycle_trip_planner/widgets/settings/GoogleSignIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'mocks/google_signin_test.mocks.dart';

@GenerateMocks([GoogleSignIn, FirebaseAuth, GoogleSignInAccount, GoogleSignInAuthentication, UserCredential])
void main(){
  final signIn = MockGoogleSignIn();
  final auth = MockFirebaseAuth();
  final signInAccount = MockGoogleSignInAccount();
  final signInAuth = MockGoogleSignInAuthentication();
  final userCredential = MockUserCredential();

  var googleSignIn = GoogleSignInProvider.forMock(signIn, auth);

  when(signInAccount.authentication).thenAnswer((realInvocation) async=> signInAuth);
  when(signIn.signIn()).thenAnswer((realInvocation) async=> signInAccount);
  when(signInAuth.accessToken).thenAnswer((realInvocation) => "authCredential");
  when(signInAuth.idToken).thenAnswer((realInvocation) => "idToken");
  when(auth.signInWithCredential(any)).thenAnswer((realInvocation) async=> userCredential);
  when(signIn.disconnect()).thenAnswer((realInvocation) async=> null);


  setUp((){
    resetMockitoState();
  });

  test("Sign in ",() async {
    googleSignIn.googleLogin();
    await untilCalled(auth.signInWithCredential(any));

    verify(signIn.signIn());
    verify(signInAccount.authentication);
    verify(signInAuth.accessToken);
    verify(signInAuth.idToken);
    verify(auth.signInWithCredential(any));
  });

  test("Log out",() async {
    googleSignIn.logout();

    await untilCalled(auth.signOut());
    verify(signIn.disconnect());
    verify(auth.signOut());
  });
}