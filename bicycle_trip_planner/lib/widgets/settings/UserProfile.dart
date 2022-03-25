import 'package:bicycle_trip_planner/widgets/settings/AuthenticationScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import 'package:bicycle_trip_planner/widgets/settings/FavouriteBar.dart';

import '../general/buttons/CircleButton.dart';

class UserProfile extends StatefulWidget {
  UserProfile({Key? key}) : super(key: key);

  @override
  _StationCardState createState() => _StationCardState();
}

class _StationCardState extends State<UserProfile> {
  // final databaseManager = DatabaseManager();
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeStyle.cardColor,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'Profile',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: ThemeStyle.primaryTextColor,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Container(
                    margin: EdgeInsets.only(top: 5),
                    width: 60.0,
                    height: 60.0,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage('assets/profile.png'),
                        )
                    )),
                SizedBox(height: 10),
                Text(
                  _auth.currentUser?.email ?? "NO EMAIL",
                  style: TextStyle(
                    fontSize: 22,
                    color: ThemeStyle.primaryTextColor,
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Wrap(
                children: [
                  Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: Column(children: [
                            CircleButton(
                              key: Key("Logout"),
                              iconIn: Icons.logout,
                              onButtonClicked: () async {
                                await _auth.signOut();
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                  return AuthenticationScreen();
                                }));
                              },
                            ),
                            SizedBox(height: 10),
                            CircleButton(
                                key: Key("Back"),
                                iconIn: Icons.arrow_back,
                                onButtonClicked: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop(context);
                                }),
                          ]),
                        ),
                      ],
                    ),
                  ]),
                  FavouriteBar()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
