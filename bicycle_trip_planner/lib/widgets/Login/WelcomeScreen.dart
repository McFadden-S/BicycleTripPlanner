import 'package:bicycle_trip_planner/widgets/Login/UserProfile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bicycle_trip_planner/widgets/Login/BackgroundContainer.dart';
import 'package:bicycle_trip_planner/widgets/Login/components/rounded_button.dart';
import 'package:bicycle_trip_planner/widgets/Login/LoginScreen.dart';
import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/widgets/Login/SignUpScreen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:bicycle_trip_planner/widgets/Login/GoogleSignIn.dart';
import '../../bloc/application_bloc.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreen createState() => _WelcomeScreen();
}

class _WelcomeScreen extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);
    Size size = MediaQuery.of(context).size; // Gives height and width of screen
    return  MultiProvider(
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
          home:
          applicationBloc.getCurrentUser() != null ?
          UserProfile()
              : Scaffold(
            body: Background(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Welcome to Bike Planner",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: size.height * 0.03),
                  RoundedButton(
                      key: Key("Login"),
                      text: "Login",
                      press: () async {
                        if (applicationBloc.getCurrentUser() == null) {
                         await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return LoginScreen();
                              },
                            ),
                          );
                          redirectToUserProfile(applicationBloc);
                        }
                      }
                  ),
                  SizedBox(height: size.height * 0.05),
                  RoundedButton(
                    key: Key("SignUp"),
                    text: "Sign Up",
                    press: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return SignUpScreen();
                        }),
                      );
                      redirectToUserProfile(applicationBloc);
                    },
                    color: ThemeStyle.kPrimaryLightColor,
                    textColor: Colors.black,
                  ),
                  Text("Divider"),
                  ElevatedButton.icon(
                    key: Key("googleLogin"),
                    icon: FaIcon(FontAwesomeIcons.google),
                    label: Text("Sign in with Google"),
                    onPressed: () async {
                      await GoogleSignInProvider().googleLogin();
                      redirectToUserProfile(applicationBloc);
                    },

                  ),
                  SizedBox(height: 10),
                  IconButton(
                    icon: const BackButtonIcon(),
                    color: Colors.black,
                    tooltip: MaterialLocalizations
                        .of(context)
                        .backButtonTooltip,
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      });
  }

  void redirectToUserProfile(ApplicationBloc applicationBloc) {
    if(applicationBloc.getCurrentUser() != null) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) {
            return UserProfile();
          })
      );
    }
  }


}