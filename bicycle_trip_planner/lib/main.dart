import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bicycle_trip_planner/services/firebase_options.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'package:bicycle_trip_planner/widgets/general/Loading.dart';
import 'package:bicycle_trip_planner/widgets/home/Home.dart';
import 'package:bicycle_trip_planner/widgets/navigation/Navigation.dart';
import 'package:bicycle_trip_planner/widgets/routeplanning/RoutePlanning.dart';
import 'package:bicycle_trip_planner/widgets/Login/login_home.dart';
import 'package:bicycle_trip_planner/bloc/application_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }catch(e){};

  runApp(ChangeNotifierProvider(
      create: (context) => ApplicationBloc(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (context) => const NavigateWindow(),
        '/login': (context) => const LoginHomeScreen(),
        '/loading': (context) => const Loading(),
        '/home': (context) => const Home(),
        '/navigation': (context) => const Navigation(),
        '/routePlanning': (context) => const RoutePlanning(),
      },
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF0C9CEE),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: buttonTextStyle,
            padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
            primary: const Color(0xFF0C9CEE),
            shadowColor: Colors.grey,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13.0),
            ),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black54,
            elevation: 3,
            splashColor: Colors.transparent,
            extendedPadding: EdgeInsets.all(10)),
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: BorderSide(width: 0.5, color: Color(0xff969393))),
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
