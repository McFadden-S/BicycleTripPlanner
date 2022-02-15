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

  Icon directionIcon(String direction) {
    return Icon(
        direction.toLowerCase().contains('left') ?
            Icons.arrow_back :
        direction.toLowerCase().contains('right') ?
            Icons.arrow_forward_outlined :
        direction.toLowerCase().contains('straight') ?
          Icons.arrow_upward :
        Icons.circle,
      color: buttonPrimaryColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',

      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
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
                    child: const Text("12 : 02")),
              ),
              SizedBox(
                height: 300,
                child: Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 43.0),
                  child: Card(
                      color: Colors.white54,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: ListView.separated(
                          itemCount: 7,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              leading: directionIcon('akfm  adfvga'),
                              trailing: Text('akfm  adfvga'),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const Divider();
                          },
                        ),
                      )
                  ),
                ),
              )
            ],
          ),
          //child:

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
