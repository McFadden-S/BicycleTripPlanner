import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Loading.dart';
import 'Home.dart';
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
                child: const Text("Page1"),
                onPressed: () => {
                  Navigator.pushNamed(context, '/loading')
                }
            ),
          ],
        ),
      ),
    );
  }
}

