import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
          child:

          // destination textfield widget styled:

          // Padding(
          //   padding: EdgeInsets.all(8.0),
          //   child: TextField(
          //     style: TextStyle(
          //       fontFamily: 'Outfit',
          //       fontSize: 36.0,
          //     ),
          //     decoration: InputDecoration(
          //       hintText: 'Destination',
          //       hintStyle: TextStyle(color: Color.fromRGBO(38, 36, 36, 0.6)),
          //       border: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(30.0),
          //         borderSide: BorderSide(color: Color.fromRGBO(12, 156, 238, 1.0), width: 1.0),
          //       ),
          //       fillColor: Colors.white,
          //       filled: true,
          //       labelText: null,
          //     ),
          //   ),
          // )

          // expandable card styled:

          // SizedBox(
          //   height: 212,
          //   child: Container(
          //     decoration: new BoxDecoration(
          //       boxShadow: [
          //         new BoxShadow(
          //           color: Color.fromRGBO(38, 36, 36, 0.5),
          //           blurRadius: 20.0,
          //         ),
          //       ],
          //     ),
          //     child: Card(
          //       color: Colors.white,
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(30.0),
          //         side: BorderSide(color: Color.fromRGBO(38, 36, 36, 1.0), width: 1.0),
          //       ),
          //       child: ListView(
          //         shrinkWrap: true,
          //         children: [
          //           Padding(
          //             padding: EdgeInsets.all(8.0),
          //             child: TextField(
          //               textAlign: TextAlign.center,
          //               style: TextStyle(
          //                 fontFamily: 'Outfit',
          //                 fontSize: 36.0,
          //               ),
          //               decoration: InputDecoration(
          //                 hintText: '----START----',
          //                 hintStyle: TextStyle(color: Color.fromRGBO(38, 36, 36, 0.6)),
          //                 border: OutlineInputBorder(
          //                   borderRadius: BorderRadius.circular(30.0),
          //                   borderSide: BorderSide(color: Color.fromRGBO(12, 156, 238, 1.0), width: 1.0),
          //                 ),
          //                 fillColor: Colors.white,
          //                 filled: true,
          //                 labelText: null,
          //               ),
          //             ),
          //           ),
          //           Padding(
          //             padding: EdgeInsets.all(8.0),
          //             child: TextField(
          //               textAlign: TextAlign.center,
          //               style: TextStyle(
          //                 fontFamily: 'Outfit',
          //                 fontSize: 36.0,
          //               ),
          //               decoration: InputDecoration(
          //                 hintText: '----END----',
          //                 hintStyle: TextStyle(color: Color.fromRGBO(38, 36, 36, 0.6)),
          //                 border: OutlineInputBorder(
          //                   borderRadius: BorderRadius.circular(30.0),
          //                   borderSide: BorderSide(color: Color.fromRGBO(12, 156, 238, 1.0), width: 10000.0),
          //                 ),
          //                 fillColor: Colors.white,
          //                 filled: true,
          //                 labelText: null,
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          
          // add stops button styled:
          
          // TextButton(
          //   onPressed: () {} ,
          //   child: const Text(
          //     'Add Stop(s)',
          //     style: TextStyle(
          //       fontFamily: 'Outfit',
          //       fontSize: 16.0,
          //       color: Colors.white,
          //     ),
          //   ),
          //   style: ButtonStyle(
          //     backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(12, 156, 238, 1.0)),
          //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          //       RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(30.0),
          //         side: BorderSide(color: Color.fromRGBO(12, 156, 238, 1.0))
          //       ),
          //     ),
          //   ),
          // )

          // current location button styled:

          // ElevatedButton(
          //   onPressed: () => {},
          //   style: ElevatedButton.styleFrom(
          //     shape: const CircleBorder(),
          //     padding: const EdgeInsets.all(10),
          //     primary: Color.fromRGBO(12, 156, 238, 1.0),
          //   ),
          //   child: const Icon(
          //       Icons.location_searching,
          //       color: Colors.white,
          //   ),
          // )

          // group button styled:

          // ElevatedButton(
          //   onPressed: () => {},
          //   style: ElevatedButton.styleFrom(
          //     shape: const CircleBorder(),
          //     padding: const EdgeInsets.all(10),
          //     primary: Color.fromRGBO(12, 156, 238, 1.0),
          //   ),
          //   child: const Icon(
          //     Icons.group,
          //     color: Colors.white,
          //   ),
          // )

          // bike button styled:

          // ElevatedButton(
          //   onPressed: () => {},
          //   style: ElevatedButton.styleFrom(
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(17.0),
          //     ),
          //     padding: const EdgeInsets.all(10),
          //     primary: Colors.green,
          //   ),
          //   child: const Icon(
          //     Icons.directions_bike,
          //     color: Colors.white,
          //   ),
          // )

          // timer/distance card styled:

          // Card(
          //     color: Color.fromRGBO(12, 156, 238, 1.0),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(30.0),
          //       side: BorderSide(color: Colors.black, width: 1.0),
          //     ),
          //     child:
          //     Container(
          //       padding: const EdgeInsets.all(5.0),
          //       child: Row(
          //         children: [
          //           Column(
          //               children: const [
          //                 Icon(
          //                     Icons.timer,
          //                     color: Colors.white,
          //                 ),
          //                 Text(
          //                   "[ETA]",
          //                   style: TextStyle(
          //                     fontFamily: 'Outfit',
          //                     fontSize: 16.0,
          //                     color: Colors.white,
          //                   ),
          //                 )
          //               ]
          //           ),
          //           const Text(
          //             "3.5 miles",
          //             style: TextStyle(
          //               fontFamily: 'Outfit',
          //               fontSize: 16.0,
          //               color: Colors.white,
          //             ),
          //           )
          //         ],
          //       ),
          //     )
          // ),

        ),
      ),
    );
  }
}
