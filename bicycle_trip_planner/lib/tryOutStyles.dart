import 'package:flutter/material.dart';
import 'constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool bike = false;
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

        cardTheme: CardTheme(
          margin: const EdgeInsets.all(5.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9.0),
          ),
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
          child: Column(
            children: [
              Row(
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
                          color: bike ? Colors.red[900] : Colors.white,
                        ),
                        Text('/'),
                        Icon(
                          Icons.directions_bike,
                          color: bike ? Colors.white : Colors.red[900],
                        ),
                      ],
                    ),
                    onPressed: () {
                      print(bike);
                      setState(() {
                        bike = !bike;
                      });
                    },
                  ),
                ],
              ),
              Card(
                child: Container(
                    padding: const EdgeInsets.all(5.0),
                    child: const Text("12 : 02")
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
