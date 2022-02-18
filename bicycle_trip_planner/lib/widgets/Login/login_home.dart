import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bicycle_trip_planner/widgets/Login/background.dart';
import 'package:bicycle_trip_planner/widgets/Login/components/rounded_button.dart';
import 'package:bicycle_trip_planner/widgets/Login/login_screen.dart';
import 'package:bicycle_trip_planner/widgets/Login/constants.dart';
import 'package:bicycle_trip_planner/widgets/Login/signup_screen.dart';
import 'package:bicycle_trip_planner/widgets/Login/components/elavated_button_with_icon.dart';
import 'package:bicycle_trip_planner/widgets/Login/components/or_divider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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