import 'package:bicycle_trip_planner/widgets/settings/UserProfile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bicycle_trip_planner/widgets/settings/components/RoundedTextButton.dart';
import 'package:bicycle_trip_planner/widgets/settings/LoginScreen.dart';
import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/widgets/settings/SignUpScreen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:bicycle_trip_planner/widgets/settings/GoogleSignIn.dart';
import '../../bloc/application_bloc.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreen createState() => _WelcomeScreen();
}

class _WelcomeScreen extends State<AuthenticationScreen> {
  // final databaseManager = DatabaseManager();
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // Gives height and width of screen
    return MultiProvider(
        providers: [
          ListenableProvider(create: (context) => GoogleSignInProvider()),
          ListenableProvider(create: (context) => ApplicationBloc()),
        ],
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              primaryColor: ThemeStyle.kPrimaryColor,
              scaffoldBackgroundColor: Colors.white,
            ),
            home: _auth.currentUser != null
                ? UserProfile()
                : Scaffold(
                    body: SafeArea(
                      child: Container(
                        color: ThemeStyle.cardColor,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Welcome to Bike Planner",
                                style: TextStyle(
                                  color: ThemeStyle.primaryTextColor,
                                    fontWeight: FontWeight.bold,
                                  fontSize: 20
                                ),
                              ),
                              SizedBox(height: size.height * 0.1),
                              RoundedTextButton(
                                  key: Key("Login"),
                                  text: "Login",
                                  press: () async {
                                    if (_auth.currentUser == null) {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return LoginScreen();
                                          },
                                        ),
                                      );
                                      redirectToUserProfile();
                                    }
                                  },
                              color: ThemeStyle.buttonPrimaryColor),
                              SizedBox(height: 10),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              width: size.width * 0.6,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: ElevatedButton.icon(
                                  key: Key("googleLogin"),
                                  icon: FaIcon(FontAwesomeIcons.google),
                                  label: Text("Login with Google"),
                                  onPressed: () async {
                                    await GoogleSignInProvider().googleLogin();
                                    redirectToUserProfile();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      primary: ThemeStyle.buttonPrimaryColor,
                                      padding: EdgeInsets.symmetric(vertical: 15),
                                      textStyle: TextStyle(
                                          color: ThemeStyle.primaryTextColor, fontSize: 14, fontWeight: FontWeight.w500)),
                                ),
                              ),
                            ),
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                    "OR",
                                  style: TextStyle(color: ThemeStyle.primaryTextColor),
                                ),
                              ),
                              SizedBox(height: 10),
                              RoundedTextButton(
                                key: Key("SignUp"),
                                text: "Sign Up",
                                press: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return SignUpScreen();
                                    }),
                                  );
                                  redirectToUserProfile();
                                },
                              ),
                              SizedBox(height: 10),
                              IconButton(
                                icon: const BackButtonIcon(),
                                color: ThemeStyle.primaryIconColor,
                                tooltip: MaterialLocalizations.of(context)
                                    .backButtonTooltip,
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
          );
        });
  }

  void redirectToUserProfile() {
    if (_auth.currentUser != null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return UserProfile();
      }));
    }
  }
}
