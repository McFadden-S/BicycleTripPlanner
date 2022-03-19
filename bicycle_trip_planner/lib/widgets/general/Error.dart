import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// text passed through depending on error
class Error extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<Error> {
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
            SizedBox(height: 25),
            Text('No connection...', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  );

}
