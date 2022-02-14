import 'package:flutter/material.dart';
import 'constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF0C9CEE),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: buttonTextStyle,
            padding: EdgeInsets.fromLTRB(15, 8, 15, 8),
            primary: const Color(0xFF0C9CEE),
            shadowColor: Colors.grey,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13.0),
            ),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.white,
          hoverColor: Colors.red,
          elevation: 3,
          splashColor: Colors.transparent,
        ),
        fontFamily: 'Outfit',
        textTheme: const TextTheme(
          headline6: TextStyle(fontSize: 36.0),
          button: TextStyle(fontSize: 18.0),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome to Flutter'),
        ),
        body: Center(
          child: Row(
            children: [
              ElevatedButton(
                child: Text(
                  'Hello Worlds',
                ),
                onPressed: () {
                  print("Hi");
                },
              ),
              FloatingActionButton(onPressed: () => print('float')),
              ElevatedButton(
                child: Icon(
                  Icons.directions_bike,
                  color: Colors.white,
                ),
                onPressed: () {
                  print("Go");
                },
              ),
              ElevatedButton(
                child: Row(
                  children: [
                    Icon(
                      Icons.directions_walk,
                      color: Colors.white,
                    ),
                    Text('/'),
                    Icon(
                      Icons.directions_bike,
                      color: Colors.white,
                    ),
                  ],
                ),
                onPressed: () {
                  print("Go");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
