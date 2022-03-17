import 'package:bicycle_trip_planner/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../settings/LoginScreen.dart';
import '../settings/SignUpScreen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Account"),
                Divider(),
                Center(
                  child: Column(
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 5),
                          width: 70.0,
                          height: 70.0,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage('assets/profile.png'),
                              )
                          )
                      ),
                      _auth.currentUser != null
                      ? Column(
                        children: [
                          Text(_auth.currentUser?.email ?? "USER IS NULL"),
                          ElevatedButton(
                            child: Text("Log out"),
                            onPressed: () async {
                              await _auth.signOut();
                              setState(() {
                              });
                            },
                          ),
                        ],
                      )
                      : Padding(
                        padding: const EdgeInsets.only(right: 10.0, left: 10.0, top: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0, right: 5.0),
                                child: ElevatedButton(
                                    child: Text("Login"),
                                    onPressed: () async {
                                      if (_auth.currentUser == null) {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return LoginScreen();
                                            },
                                          ),
                                        );
                                        if (_auth.currentUser != null) {
                                          setState(() {
                                            // update screen
                                          });
                                        }
                                      }
                                    },
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0, right: 5.0),                            child: ElevatedButton(
                                  child: Text("Sign up"),
                                  onPressed: () async {
                                    if (_auth.currentUser == null) {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return SignUpScreen();
                                          },
                                        ),
                                      );
                                      setState(() {
                                        // update screen
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height:10),
                Text("Settings"),
                Divider(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true)
              .pop(context);
    },
    backgroundColor: ThemeStyle.buttonPrimaryColor,
         child: const Icon(Icons.arrow_back),
    ),
    );
  }
}
