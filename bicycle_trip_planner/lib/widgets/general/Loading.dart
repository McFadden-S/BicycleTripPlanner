import 'package:bicycle_trip_planner/managers/LocationManager.dart';
import 'package:bicycle_trip_planner/managers/StationManager.dart';
import 'package:bicycle_trip_planner/models/place.dart';
import 'package:bicycle_trip_planner/widgets/general/MapWidget.dart';
import 'package:bicycle_trip_planner/widgets/home/StationBar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  void setUpMap() async {
    await MapWidget();
    await LocationManager().getCurrentLocation() != const Place.placeNotFound();
    await StationManager().getNumberOfStations() > 0;
    await StationBar();
    await Future.delayed(Duration(seconds: 3));
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  void initState(){
    super.initState();
    setUpMap();
  }

  @override
  Widget build(BuildContext context)  => WillPopScope(
    onWillPop: () async {
      return false;
    },
    child: Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Column(
          children: [
            SpinKitFadingCube(
              color: Colors.white,
              size: 50.0,
            ),
            Text('No connection... Please wait')
          ],
        ),
      ),
    ),
  );
  }






