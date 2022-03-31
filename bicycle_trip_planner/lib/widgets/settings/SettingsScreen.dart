import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/models/distance_types.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../bloc/application_bloc.dart';
import '../../managers/UserSettings.dart';
import '../settings/LoginScreen.dart';
import '../settings/SignUpScreen.dart';


/// Settings screen displays settings that the user can change. This includes
/// the radius of stations they want to see near them, how often the stations list
/// is updated and what unit of distance they prefer.
/// Settings screen also allows the user to log in, sign up and log out,
/// depending on their login status
class SettingsScreen extends StatefulWidget {
  var settings;
  var auth;
  var bloc;

  SettingsScreen({Key? key, this.auth, this.settings, this.bloc}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}
// List of distance
// Used to find the maximum distance range for nearby stations
class _SettingsScreenState extends State<SettingsScreen> {
  late UserSettings userSettings;
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

  // Default values
  int stationsRefreshRate = 30;
  double nearbyStationsRange = 0.5;
  String distanceUnit = 'miles';
  late var _auth;
  late var applicationBloc;

  @override
  void initState() {
    super.initState();
    userSettings = widget.settings ?? UserSettings();
    _auth = widget.auth ?? FirebaseAuth.instance;
    applicationBloc = widget.bloc ?? Provider.of<ApplicationBloc>(context, listen: false);
    updateVariables();
  }

  @override
  Widget build(BuildContext context) {
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
                          // Creates info button that displays a descriptive text
                          // which explains the advantages of having an account
                          IconButton(
                            key: Key("infoButton"),
                            icon: Icon(Icons.info_outline,
                                color: ThemeStyle.secondaryIconColor),
                            onPressed: () {
                              // set up the AlertDialog
                              AlertDialog alert = AlertDialog(
                                key: Key("informationText"),
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
                                      key: Key("logOut"),
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
                                            key: Key("logIn"),
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
                                            key: Key("signUp"),
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
                                key: Key("stationUpdate"),
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
                                  applicationBloc.updateSettings();
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
                                key: Key("nearbyStation"),
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
                                ),
                                onChanged: (double? newValue) async {
                                  userSettings.setNearbyStationsRange(newValue);
                                  await updateVariables();
                                  applicationBloc.updateSettings();
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
                                key: Key("distance"),
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
                                ),
                                onChanged: (String? newValue) async {
                                  userSettings.setDistanceUnit(newValue);
                                  await updateVariables();
                                  applicationBloc.updateSettings();
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
          Navigator.pop(context);
        },
        backgroundColor: ThemeStyle.buttonPrimaryColor,
        child: Icon(Icons.arrow_back, color: ThemeStyle.primaryIconColor),
      ),
    );
  }

  // Updates variables when there is a value change
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
