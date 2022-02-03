import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Loading.dart';
import 'Home.dart';
import 'Navigation.dart';
import 'RoutePlanning.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const NavigateWindow(),
        '/loading': (context) => const Loading(),
        '/home': (context) => const Home(),
        '/navigation': (context) => const Navigation(),
        '/routePlanning': (context) => const RoutePlanning(),
      }
  ));
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
                child: const Text("Loading"),
                onPressed: () => {
                  Navigator.pushNamed(context, '/loading')
                }
            ),
            TextButton(
                child: const Text("Home"),
                onPressed: () => {
                  Navigator.pushNamed(context, '/home')
                }
            ),
            TextButton(
                child: const Text("Navigation"),
                onPressed: () => {
                  Navigator.pushNamed(context, '/navigation')
                }
            ),
            TextButton(
                child: const Text("RoutePlanning"),
                onPressed: () => {
                  Navigator.pushNamed(context, '/routePlanning')
                }
            ),
          ],
        ),
      ),
    );
  }
}

