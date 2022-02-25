import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bicycle_trip_planner/constants.dart';
import 'package:provider/provider.dart';
import 'package:bicycle_trip_planner/widgets/Login/google_sign_in.dart';
import 'package:bicycle_trip_planner/widgets/Login/welcome_screen.dart';

class LoginHomeScreen extends StatefulWidget {
  const LoginHomeScreen({Key? key}) : super(key: key);

  @override
  _LoginHomeScreen createState() => _LoginHomeScreen();
}

class _LoginHomeScreen extends State<LoginHomeScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // Gives height and width of screen

    final _auth = FirebaseAuth.instance;
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Login Screen',
        theme: ThemeData(
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: WelcomeScreen(),
      ),
    );




  }
}