import 'package:bicycle_trip_planner/widgets/Login/AuthenticationScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../managers/DatabaseManager.dart';
import 'package:bicycle_trip_planner/widgets/login/FavouriteBar.dart';

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
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_auth.currentUser?.email ?? "NO EMAIL"),
                ElevatedButton(
                    onPressed: () async {
                      await _auth.signOut();
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return AuthenticationScreen();
                      }));
                    },
                    child: Text("Log out")),
                IconButton(
                    icon: const BackButtonIcon(),
                    color: ThemeStyle.primaryIconColor,
                    tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop(context);
                    }),
              ],
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: FavouriteBar()),
        ],
      ),

    );
  }
}
