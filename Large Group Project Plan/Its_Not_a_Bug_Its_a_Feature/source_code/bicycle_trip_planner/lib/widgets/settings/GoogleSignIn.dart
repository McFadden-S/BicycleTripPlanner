import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Class to let the user sign in through google
class GoogleSignInProvider extends ChangeNotifier{

  // Variables used to get allow sign in
  late var googleSignIn;
  late var _auth;

  // Default constructor
  GoogleSignInProvider(){
    googleSignIn = GoogleSignIn();

    _auth = FirebaseAuth.instance;
  }

  // Constructor used to pass in mocked values
  GoogleSignInProvider.forMock(GoogleSignIn signIn, FirebaseAuth auth){
    googleSignIn = signIn;
    _auth = auth;
  }

  // The current user
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  // Logs the user in using google
  Future googleLogin() async {
    final googleUser = await googleSignIn.signIn();
    if(googleUser == null) return;
    _user = googleUser;
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await _auth.signInWithCredential(credential);
    notifyListeners();
  }

  // Logs the user out
  Future logout() async {
    await googleSignIn.disconnect();
    _auth.signOut();
  }


}