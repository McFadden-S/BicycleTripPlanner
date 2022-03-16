import 'package:bicycle_trip_planner/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../managers/UserSettings.dart';
import '../settings/LoginScreen.dart';
import '../settings/SignUpScreen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  UserSettings userSettings = UserSettings();
  List<int> stationsRefreshRateOptions = <int>[30, 40, 50, 60];
  List<double> nearbyStationsRangeOptions = <double>[0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0];
  List<String> distanceUnitOptions = <String>['miles', 'km'];

  int stationsRefreshRate = 30;
  double nearbyStationsRange = 0.5;
  String distanceUnit = 'miles';


  @override
  void initState() {
    updateVariables();
  }

  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: ThemeStyle.cardColor,
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Account",
                    style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: ThemeStyle.primaryTextColor,
                ),
                ),
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
                      SizedBox(height: 10),
                      _auth.currentUser != null
                      ? Column(
                        children: [
                          Text(_auth.currentUser?.email ?? "USER IS NULL",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: ThemeStyle.primaryTextColor,
                            ),
                          ),
                          SizedBox(height: 10),
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
                SizedBox(height:20),
                Text("Settings",
                  style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: ThemeStyle.primaryTextColor,
                ),),
                Divider(),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0, left: 10.0, top: 10.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Stations update rate",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: ThemeStyle.primaryTextColor,
                                  ),
                                ),
                                Text("The time for which the stations list is updated in seconds",
                                  style: TextStyle(
                                    color: ThemeStyle.primaryTextColor,
                                  ),),
                              ],
                            ),
                          ),
                          DropdownButton<int>(
                            dropdownColor: ThemeStyle.cardColor,
                            value: stationsRefreshRate,
                            icon: const Icon(Icons.arrow_drop_down),
                            elevation: 16,
                            style: TextStyle(
                                color: ThemeStyle.mainFontColor,
                                fontSize: 16
                            ),
                            underline: Container(
                              height: 2,
                              // color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (int? newValue) async {
                              userSettings.setStationsRefreshRate(newValue);
                              await updateVariables();
                            },
                            items: stationsRefreshRateOptions
                                .map<DropdownMenuItem<int>>((int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text(
                                    value.toString(),
                                    style: TextStyle(
                                      color: ThemeStyle.primaryTextColor,
                                      fontSize: 16
                                  ),
                                ),
                              );
                            }).toList(),
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Nearby Stations range",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: ThemeStyle.primaryTextColor,
                                  ),
                                ),
                                Text("The maximum distance range for nearby stations in miles/km",
                                  style: TextStyle(
                                    color: ThemeStyle.primaryTextColor,
                                  ),),
                              ],
                            ),
                          ),
                          DropdownButton<double>(
                            dropdownColor: ThemeStyle.cardColor,
                            value: nearbyStationsRange,
                            icon: const Icon(Icons.arrow_drop_down),
                            elevation: 16,
                            style: TextStyle(
                                color: ThemeStyle.mainFontColor,
                                fontSize: 16
                            ),
                            underline: Container(
                              height: 2,
                              // color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (double? newValue) async {
                              userSettings.setNearbyStationsRange(newValue);
                              await updateVariables();
                            },
                            items: nearbyStationsRangeOptions
                                .map<DropdownMenuItem<double>>((double value) {
                              return DropdownMenuItem<double>(
                                value: value,
                                child: Text(value.toString(),
                                    style: TextStyle(
                                        color: ThemeStyle.primaryTextColor,
                                        fontSize: 16),
                                ),
                              );
                            }).toList(),
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Distance unit",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: ThemeStyle.primaryTextColor,
                                  ),
                                ),
                                Text("Distance unit to be used",
                                  style: TextStyle(
                                    color: ThemeStyle.primaryTextColor,
                                  ),),
                              ],
                            ),
                          ),
                          DropdownButton<String>(
                            dropdownColor: ThemeStyle.cardColor,
                            value: distanceUnit,
                            icon: const Icon(Icons.arrow_drop_down),
                            elevation: 16,
                            style: TextStyle(
                                color: ThemeStyle.mainFontColor,
                                fontSize: 16
                            ),
                            underline: Container(
                              height: 2,
                              // color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (String? newValue) async {
                              userSettings.setDistanceUnit(newValue);
                              await updateVariables();
                            },
                            items: distanceUnitOptions
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,
                                  style: TextStyle(
                                      color: ThemeStyle.primaryTextColor,
                                      fontSize: 16
                                  ),
                                ),
                              );
                            }).toList(),
                          )
                        ],
                      ),
                    ],
                  ),
                )
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

  updateVariables() async {
    stationsRefreshRate = await userSettings.stationsRefreshRate();
    nearbyStationsRange = await userSettings.nearbyStationsRange();
    distanceUnit = await userSettings.distanceUnit();
    setState(() {
      // update screen
    });
  }
}
