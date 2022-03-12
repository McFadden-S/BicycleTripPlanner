import 'dart:async';
import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_trip_planner/widgets/general/MapWidget.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late StreamSubscription connectivitySubscription;

  @override
  void initState() {
    super.initState();
    connectivitySubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi) {
        // I am connected to a mobile/wifi network.
        Navigator.pop(context);
      } else {
        // I am not connected at all
        Navigator.pushNamed(context, '/error');

      }
    });

  }

  @override
  Widget build(BuildContext context) {
    double topPaddingHeight = MediaQuery.of(context).padding.top;
    final applicationBloc = Provider.of<ApplicationBloc>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          MapWidget(),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              color: Colors.grey.withOpacity(0.4),
              child: SizedBox(height: topPaddingHeight, width: MediaQuery.of(context).size.width)
            ),
          ),
          AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: applicationBloc.getSelectedScreen()),
        ],
      ),
    );
  }
}

