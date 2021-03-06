import 'dart:io';

import 'package:bicycle_trip_planner/managers/LocationManager.dart';
import 'package:bicycle_trip_planner/widgets/settings/SettingsScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'package:bicycle_trip_planner/widgets/general/other/Loading.dart';
import 'package:bicycle_trip_planner/widgets/home/Home.dart';
import 'package:bicycle_trip_planner/widgets/navigation/Navigation.dart';
import 'package:bicycle_trip_planner/widgets/routeplanning/RoutePlanning.dart';
import 'package:bicycle_trip_planner/widgets/general/other/weather.dart';
import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/widgets/general/other/Error.dart';

Future<void> main() async {
  ThemeStyle();
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: Ensure firebase initialization only occurs once
  try {
    await Firebase.initializeApp();
  } catch (e) {};

  LocationManager locationManager = LocationManager();

  // location requested and if denied send to settings and close
  if (!(await locationManager.requestPermission())) {
    await locationManager.openLocationSettingsOnDevice();
    exit(0);
  }

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
      (value) => runApp(ChangeNotifierProvider(
          create: (context) => ApplicationBloc(), child: const MyApp())));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      initialRoute: '/loading',
      routes: <String, WidgetBuilder>{
        // '/': (context) => const NavigateWindow(),
        '/settings': (context) => SettingsScreen(),
        '/loading': (context) => const Loading(),
        '/home': (context) => const Home(),
        '/navigation': (context) => Navigation(),
        '/routePlanning': (context) => RoutePlanning(),
        '/weather': (context) => Weather(),
        '/error': (context) => Error(),
      },
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: ThemeStyle.buttonPrimaryColor,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: ThemeStyle.buttonTextStyle,
            padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
            primary: ThemeStyle.buttonPrimaryColor,
            shadowColor: ThemeStyle.boxShadow,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13.0),
            ),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: ThemeStyle.buttonSecondaryColor,
            foregroundColor: ThemeStyle.secondaryTextColor,
            elevation: 3,
            splashColor: Colors.transparent,
            extendedPadding: EdgeInsets.all(10)),
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: BorderSide(width: 0.5, color: ThemeStyle.cardOutlineColor)),
          elevation: 3,
        ),
        fontFamily: 'Outfit',
        textTheme: const TextTheme(
          headline6: TextStyle(fontSize: 36.0),
          button: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }
}

class NavigateWindow extends StatefulWidget {
  const NavigateWindow({Key? key}) : super(key: key);

  @override
  _NavigateWindowState createState() => _NavigateWindowState();
}

class _NavigateWindowState extends State<NavigateWindow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                child: const Text("Login"),
                onPressed: () => {Navigator.pushNamed(context, '/login')}),
            TextButton(
                child: const Text("Loading"),
                onPressed: () => {Navigator.pushNamed(context, '/loading')}),
            TextButton(
                child: const Text("Home"),
                onPressed: () => {Navigator.pushNamed(context, '/home')}),
            TextButton(
                child: const Text("Navigation"),
                onPressed: () => {Navigator.pushNamed(context, '/navigation')}),
            TextButton(
                child: const Text("RoutePlanning"),
                onPressed: () =>
                    {Navigator.pushNamed(context, '/routePlanning')}),
          ],
        ),
      ),
    );
  }
}
