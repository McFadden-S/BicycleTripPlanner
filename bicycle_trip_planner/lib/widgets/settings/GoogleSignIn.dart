import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier{

  late var googleSignIn;
  late var _auth;

  GoogleSignInProvider(){
    googleSignIn = GoogleSignIn();

    _auth = FirebaseAuth.instance;
  }

  GoogleSignInProvider.forMock(GoogleSignIn signIn, FirebaseAuth auth){
    googleSignIn = signIn;
    _auth = auth;
  }

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

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

  Future logout() async {
    await googleSignIn.disconnect();
    _auth.signOut();
  }


}