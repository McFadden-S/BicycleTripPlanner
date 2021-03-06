import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/widgets/settings/ForgotPasswordScreen.dart';
import 'package:bicycle_trip_planner/widgets/settings/SignUpScreen.dart';
import 'package:bicycle_trip_planner/widgets/settings/components/RoundedTextButton.dart';
import 'package:bicycle_trip_planner/widgets/settings/components/InputField.dart';
import 'package:bicycle_trip_planner/widgets/settings/components/PasswordField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../settings/GoogleSignIn.dart';
import 'components/ErrorSnackbar.dart';


/// Login screen is used to allow the user to log into their accounts either
/// using an email and password or through google sign in
class LoginScreen extends StatefulWidget {

  var auth;
  var email;
  var password;

  @override
  State<LoginScreen> createState() => _LoginScreenState();

  // Default constructor
  LoginScreen({Key? key, this.auth, this.email, this.password}) : super(key:key);

}

class _LoginScreenState extends State<LoginScreen> {
  late var _auth;
  late String email;
  late String password;


  // Assigns values to variables, if value not passed in default values are assigned
  @override
  void initState() {
    super.initState();
    email = widget.email ?? "!";
    password = widget.password ?? "!";
    _auth = widget.auth ?? FirebaseAuth.instance;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
            color: ThemeStyle.cardColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Login",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: ThemeStyle.primaryTextColor,
                  ),
                ),
                Flexible(
                  child: Image.asset(
                    "assets/login_image.png",
                    height: size.height * 0.4,
                  ),
                  flex: 1,
                ),
                // Field to pass in user email
                Flexible(
                  child: RoundedInputField(
                    key: Key("emailField"),
                    hintText: "Email",
                    onChanged: (value) {
                      email = value;
                    },
                  ),
                  flex: 2,
                ),
                // Field to pass in user password
                RoundedPasswordField(
                    key: Key("passwordField"),
                    text: "Password",
                    onChanged: (value) {
                      password = value;
                    }
                ),
                // Button to log user in
                RoundedTextButton(
                  key: Key("login"),
                  text: "Login",
                  press: () async {
                    try {
                      await _auth.signInWithEmailAndPassword(email: email, password: password);
                      Navigator.pop(context, true);
                    } catch (e) {
                      ErrorSnackBar.buildErrorSnackbar(context, e.toString());
                    }
                  },
                ),
                Text("OR",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ThemeStyle.primaryTextColor,
                  ),),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  width: size.width * 0.6,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: ElevatedButton.icon(
                      key: Key("googleLogin"),
                      icon: FaIcon(FontAwesomeIcons.google),
                      label: Text("Login with Google"),
                      // Logs user in via google
                      onPressed: () async {
                        await GoogleSignInProvider().googleLogin();
                        if(_auth.currentUser != null){
                          Navigator.pop(context, true);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          primary: ThemeStyle.buttonPrimaryColor,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          textStyle: TextStyle(
                              color: ThemeStyle.primaryTextColor, fontSize: 14, fontWeight: FontWeight.w500)),
                    ),
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Do not have an Account? ",
                    style: TextStyle(color: ThemeStyle.primaryTextColor),
                  ),
                  // Directs user to sign up page
                  GestureDetector(
                    key: Key("signUp"),
                    onTap: (){
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return SignUpScreen();
                        }),
                      );
                    },
                    child: Text(
                      " Sign Up",
                      style: TextStyle(
                        color: ThemeStyle.kPrimaryLightColor,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
                SizedBox(height: size.height * 0.01),
                // Directs user to reset password page
                GestureDetector(
                  key: Key("resetPassword"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return ForgotPasswordScreen();
                      }),
                    );
                  },
                  child: Text(
                    "Reset Password",
                    style: TextStyle(
                      color: ThemeStyle.kPrimaryLightColor,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                BackButton(
                  color: ThemeStyle.secondaryIconColor,
                  key: Key("back"),
                )
              ],
            ),
          ),
        ),
    );
  }
}
