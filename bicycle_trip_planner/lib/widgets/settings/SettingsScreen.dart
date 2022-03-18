import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/models/distance_types.dart';
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
  List<double> nearbyStationsRangeOptions = <double>[
    0.5,
    1.0,
    1.5,
    2.0,
    2.5,
    3.0,
    3.5,
    4.0,
    4.5,
    5.0
  ];
  List<String> distanceUnitOptions = <String>['miles', 'kilometres'];

  int stationsRefreshRate = 30;
  double nearbyStationsRange = 0.5;
  String distanceUnit = 'miles';
  bool settingsChanged = false;

  @override
  void initState() {
    super.initState();
    updateVariables();
  }

  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;

    return Scaffold(
      backgroundColor: ThemeStyle.cardColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          SafeArea(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, left: 5.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Account",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: ThemeStyle.primaryTextColor,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.info_outline,
                                color: ThemeStyle.secondaryIconColor),
                            onPressed: () {
                              // set up the AlertDialog
                              AlertDialog alert = AlertDialog(
                                backgroundColor: ThemeStyle.cardColor,
                                title: Text("Account advantages",
                                    style: TextStyle(
                                      color: ThemeStyle.primaryTextColor,
                                    )),
                                content: Text(
                                    "Add your favourite stations and routes\n"
                                    "to your account to start your journey faster\n"
                                    "and from different devices!",
                                    style: TextStyle(
                                      color: ThemeStyle.primaryTextColor,
                                    )),
                              );

                              // show the dialog
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return alert;
                                },
                              );
                            },
                          )
                        ],
                      ),
                    ),
                    Divider(color: ThemeStyle.cardOutlineColor),
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
                                  ))),
                          SizedBox(height: 10),
                          _auth.currentUser != null
                              ? Column(
                                  children: [
                                    Text(
                                      _auth.currentUser?.email ??
                                          "USER IS NULL",
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
                                        setState(() {});
                                      },
                                    ),
                                  ],
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      right: 10.0, left: 10.0, top: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10.0, right: 5.0),
                                          child: ElevatedButton(
                                            child: Text("Login"),
                                            onPressed: () async {
                                              if (_auth.currentUser == null) {
                                                // The result will be true when logged in successfully,
                                                // False otherwise
                                                bool success =
                                                    await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) {
                                                      return LoginScreen();
                                                    },
                                                  ),
                                                );
                                                if (success) {
                                                  updateScreen();
                                                }
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10.0, right: 5.0),
                                          child: ElevatedButton(
                                            child: Text("Sign up"),
                                            onPressed: () async {
                                              if (_auth.currentUser == null) {
                                                // The result will be true when logged in successfully,
                                                // False otherwise
                                                bool success =
                                                    await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) {
                                                      return SignUpScreen();
                                                    },
                                                  ),
                                                );
                                                if (success) {
                                                  updateScreen();
                                                }
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
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, left: 5.0),
                      child: Text(
                        "Settings",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: ThemeStyle.primaryTextColor,
                        ),
                      ),
                    ),
                    Divider(color: ThemeStyle.cardOutlineColor),
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 10.0, left: 10.0, top: 10.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Stations update rate",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: ThemeStyle.primaryTextColor,
                                      ),
                                    ),
                                    Text(
                                      "The periodic time for which the stations\nlist will be updated"
                                      " in seconds\n(lower values might consume more battery)",
                                      style: TextStyle(
                                        color: ThemeStyle.primaryTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              DropdownButton<int>(
                                alignment: AlignmentDirectional.topEnd,
                                dropdownColor: ThemeStyle.cardColor,
                                value: stationsRefreshRate,
                                icon: const Icon(Icons.arrow_drop_down),
                                elevation: 16,
                                style: TextStyle(
                                    color: ThemeStyle.mainFontColor,
                                    fontSize: 16),
                                underline: Container(
                                  height: 2,
                                ),
                                onChanged: (int? newValue) async {
                                  userSettings.setStationsRefreshRate(newValue);
                                  await updateVariables();
                                  settingsChanged = true;
                                },
                                items: stationsRefreshRateOptions
                                    .map<DropdownMenuItem<int>>((int value) {
                                  return DropdownMenuItem<int>(
                                    value: value,
                                    child: Text(
                                      value.toString(),
                                      style: TextStyle(
                                          color: ThemeStyle.primaryTextColor,
                                          fontSize: 16),
                                    ),
                                  );
                                }).toList(),
                              )
                            ],
                          ),
                          Divider(color: ThemeStyle.cardOutlineColor),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Nearby Stations range",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: ThemeStyle.primaryTextColor,
                                      ),
                                    ),
                                    Text(
                                      "The maximum distance range for nearby stations in miles/km",
                                      style: TextStyle(
                                        color: ThemeStyle.primaryTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              DropdownButton<double>(
                                alignment: AlignmentDirectional.topEnd,
                                dropdownColor: ThemeStyle.cardColor,
                                value: nearbyStationsRange,
                                icon: const Icon(Icons.arrow_drop_down),
                                elevation: 16,
                                style: TextStyle(
                                    color: ThemeStyle.mainFontColor,
                                    fontSize: 16),
                                underline: Container(
                                  height: 2,
                                  // color: Colors.deepPurpleAccent,
                                ),
                                onChanged: (double? newValue) async {
                                  userSettings.setNearbyStationsRange(newValue);
                                  await updateVariables();
                                  settingsChanged = true;
                                },
                                items: nearbyStationsRangeOptions
                                    .map<DropdownMenuItem<double>>(
                                        (double value) {
                                  return DropdownMenuItem<double>(
                                    value: value,
                                    child: Text(
                                      value.toString(),
                                      style: TextStyle(
                                          color: ThemeStyle.primaryTextColor,
                                          fontSize: 16),
                                    ),
                                  );
                                }).toList(),
                              )
                            ],
                          ),
                          Divider(color: ThemeStyle.cardOutlineColor),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Distance unit",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: ThemeStyle.primaryTextColor,
                                      ),
                                    ),
                                    Text(
                                      "Distance unit to be used",
                                      style: TextStyle(
                                        color: ThemeStyle.primaryTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              DropdownButton<String>(
                                alignment: AlignmentDirectional.topEnd,
                                dropdownColor: ThemeStyle.cardColor,
                                value: distanceUnit,
                                icon: const Icon(Icons.arrow_drop_down),
                                elevation: 16,
                                style: TextStyle(
                                    color: ThemeStyle.mainFontColor,
                                    fontSize: 16),
                                underline: Container(
                                  height: 2,
                                  // color: Colors.deepPurpleAccent,
                                ),
                                onChanged: (String? newValue) async {
                                  userSettings.setDistanceUnit(newValue);
                                  await updateVariables();
                                  settingsChanged = true;
                                },
                                items: distanceUnitOptions
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                          color: ThemeStyle.primaryTextColor,
                                          fontSize: 16),
                                    ),
                                  );
                                }).toList(),
                              )
                            ],
                          ),
                          Divider(color: ThemeStyle.cardOutlineColor),
                          SizedBox(height: 10),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
                color: Colors.grey.withOpacity(0.4),
                child: SizedBox(
                    height: MediaQuery.of(context).padding.top,
                    width: MediaQuery.of(context).size.width)),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, settingsChanged);
        },
        backgroundColor: ThemeStyle.buttonPrimaryColor,
        child: Icon(Icons.arrow_back, color: ThemeStyle.primaryIconColor),
      ),
    );
  }

  updateVariables() async {
    stationsRefreshRate = await userSettings.stationsRefreshRate();
    nearbyStationsRange = await userSettings.nearbyStationsRange();
    distanceUnit = (await userSettings.distanceUnit()).unitsLong;
    updateScreen();
  }

  updateScreen() {
    setState(() {
      // update screen
    });
  }
}
