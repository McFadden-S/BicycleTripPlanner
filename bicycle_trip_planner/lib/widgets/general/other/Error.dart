import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/// Displays a error when there is no connection to the internet
class Error extends StatefulWidget {
  @override
  _ErrorState createState() => _ErrorState();
}

  //WillPop stops the user from leaving the error page
class _ErrorState extends State<Error> {
  @override
  Widget build(BuildContext context) => WillPopScope(
    onWillPop: () async {
      return false;
    },
    child: Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SpinKitFadingCube(
              color: Colors.white,
              size: 50.0,
            ),
            SizedBox(height: 25, key: Key("SizedBox")),
            Text('No connection...', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    ),
  );

}
