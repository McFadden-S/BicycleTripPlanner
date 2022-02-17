import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bicycle_trip_planner/services/firebase_options.dart';
import 'package:provider/provider.dart';
import 'widgets/Loading.dart';
import 'widgets/Home.dart';
import 'widgets/Navigation.dart';
import 'widgets/RoutePlanning.dart';
import 'bloc/application_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
      ChangeNotifierProvider(
          create: (context) => ApplicationBloc(),
          child: const MyApp()
      )
  );
}

class MyApp extends StatelessWidget{
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/': (context) => const NavigateWindow(),
          '/loading': (context) => const Loading(),
          '/home': (context) => const Home(),
          '/navigation': (context) => const Navigation(),
          '/routePlanning': (context) => const RoutePlanning(),
        });
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
                onPressed: () => {}),
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
