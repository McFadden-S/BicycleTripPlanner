import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prototypes/constants.dart';
import 'package:prototypes/screens/SignUp/signup_screen.dart';
import 'package:prototypes/screens/Welcome/background.dart';
import 'package:prototypes/screens/components/elavated_button_with_icon.dart';
import 'package:prototypes/screens/components/or_divider.dart';
import 'package:prototypes/screens/components/rounded_button.dart';
import 'package:prototypes/screens/Login/login_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:prototypes/google_sign_in.dart';

//welcome screen body
class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // Gives height and width of screen

    final _auth = FirebaseAuth.instance;
    return Background(
        child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Welcome to Bike Planner",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: size.height * 0.03),
          RoundedButton(
            text: "Login",
            press: () {
              if (_auth.currentUser == null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              } else {
                print("You are already logged in");
              }
            },
          ),
          if (_auth.currentUser != null)
            RoundedButton(
              text: "Logout",
              press: () {
                _auth.signOut();
                setState(() => _auth.currentUser);
                print("Log out successful");
              },
            ),
          SizedBox(height: size.height * 0.05),
          RoundedButton(
            text: "Sign Up",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return SignUpScreen();
                }),
              );
            },
            color: kPrimaryLightColor,
            textColor: Colors.black,
          ),
          OrDivider(),
          ElavatedButtonWithIcon(
            text: "Sign Up/Log In With Google",
            press: () {
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.googleLogin();
            },
            icon: FaIcon(FontAwesomeIcons.google),
          ),
          ElavatedButtonWithIcon(
            text: "Temp Log Out",
            press: () {
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.logout();
            },
            icon: FaIcon(FontAwesomeIcons.google),
          ),
        ],
      ),
    ));
  }
}


// class Body extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size; // Gives height and width of screen
//
//     final _auth = FirebaseAuth.instance;
//     return Background(
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Text(
//                 "Welcome to Bike Planner",
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: size.height * 0.03),
//               RoundedButton(
//                 text: "Login",
//                 press: () {Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder:(context) {
//                       return LoginScreen();
//                     },
//                   ),
//                 );
//                 },
//               ),
//               if (_auth.currentUser != null) Text("IM HERE"),
//               RoundedButton(
//                 text: "Logout",
//                 press: () {
//                   setState(() => _auth.signOut());
//                   print("Log out successful");
//                 },
//               ),
//               SizedBox(height: size.height * 0.05),
//               RoundedButton(
//                 text: "Sign Up",
//                 press: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context){
//                           return SignUpScreen();
//                         }
//                     ),
//                   );
//                 },
//                 color: kPrimaryLightColor,
//                 textColor: Colors.black,
//               ),
//               OrDivider(),
//               ElavatedButtonWithIcon(
//                 text: "Sign Up/Log In With Google",
//                 press: () {
//                   final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
//                   provider.googleLogin();
//                 },
//                 icon: FaIcon(FontAwesomeIcons.google),
//               ),
//               ElavatedButtonWithIcon(
//                 text: "Temp Log Out",
//                 press: () {
//                   final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
//                   provider.logout();
//                 },
//                 icon: FaIcon(FontAwesomeIcons.google),
//               ),
//             ],
//           ),
//         )
//     );
//   }
// }