import 'package:flutter/material.dart';
import 'package:prototypes/constants.dart';
import 'package:prototypes/screens/ForgotPassword/forgot_password_screen.dart';
import 'package:prototypes/screens/Login/background.dart';
import 'package:prototypes/screens/SignUp/signup_screen.dart';
import 'package:prototypes/screens/Welcome/welcome_screen.dart';
import 'package:prototypes/screens/components/already_have_account.dart';
import 'package:prototypes/screens/components/back_button_to_welcome.dart';
import 'package:prototypes/screens/components/rounded_button.dart';
import 'package:prototypes/screens/components/rounded_input_field.dart';
import 'package:prototypes/screens/components/rounded_password_field.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Body extends StatefulWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final _auth = FirebaseAuth.instance;
    late String email;
    late String password;
    return Background(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Login",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: mainFontColor,
            ),
          ),
          SizedBox(height: size.height * 0.03),
          Image.asset(
            "assets/images/login_image.png",
            height: size.height * 0.35,
          ),
          SizedBox(height: size.height * 0.03),
          RoundedInputField(
            hintText: "Email",
            onChanged: (value) {
              email = value;
            },
          ),
          RoundedPasswordField(
              text: "Password",
              onChanged: (value) {
                password = value;
              }
          ),
          RoundedButton(
            text: "Login",
            press: () async {
              try{
                await _auth.signInWithEmailAndPassword(
                    email: email, password: password);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return WelcomeScreen();
                  }),
                );
              }catch(e){
                _showSnackBar(e.toString());
              }
            },
          ),
          AlreadyHaveAnAccount(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return SignUpScreen();
                }),
              );
            },
          ),
          SizedBox(height: size.height * 0.01),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {

                  return ForgotPassword();
                }),
              );
            },
            child: Text(
               "Reset Password",
                style: TextStyle(
                  color: secondaryFontColor,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
              ),
            ),
          ),
          SizedBox(height: size.height * 0.02),
          back_button()
        ],
      ),
    );
  }

  Future<void> _showSnackBar(String m) async {
    final snackBar = SnackBar(
      content: Text(m),
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.blue,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
