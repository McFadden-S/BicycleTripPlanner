import 'package:flutter/material.dart';
import 'package:prototypes/constants.dart';
import 'package:prototypes/screens/Login/background.dart';
import 'package:prototypes/screens/SignUp/signup_screen.dart';
import 'package:prototypes/screens/Welcome/welcome_screen.dart';
import 'package:prototypes/screens/components/already_have_account.dart';
import 'package:prototypes/screens/components/back_button_to_welcome.dart';
import 'package:prototypes/screens/components/rounded_button.dart';
import 'package:prototypes/screens/components/rounded_input_field.dart';
import 'package:prototypes/screens/components/rounded_password_field.dart';

class Body extends StatelessWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Login", style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: size.height * 0.03),
          Image.asset(
            "assets/images/login_image.png",
            height: size.height * 0.35,
          ),
          SizedBox(height: size.height * 0.03),
          RoundedInputField(
            hintText: "Email",
            onChanged: (value) {},
          ),
          RoundedPasswordField(
            text: "Password",
            onChanged: (value) {},
          ),
          RoundedButton(
              text: "Login",
              press: () {},
          ),
          AlreadyHaveAnAccount(press: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context){
                    return SignUpScreen();
                  }
                ),
            );
          },
          ),
          SizedBox(height: size.height * 0.03),
          back_button()
        ],
      ),
    );
  }
}



