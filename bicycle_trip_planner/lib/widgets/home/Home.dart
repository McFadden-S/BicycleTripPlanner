import 'dart:async';
import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/widgets/general/BinaryChoiceDialog.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_trip_planner/widgets/general/MapWidget.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:bicycle_trip_planner/widgets/home/StartIntermediateEndDialog.dart';

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
      if (result == ConnectivityResult.none) {
        // I am not connected at all
          Navigator.pushNamed(context, '/error');
      } else {
        // I am connected to a mobile/wifi network
        // NB: Will pop off the current thing on stack... If
        // error widget is not on top of stack, error will not be
        // popped off.
        if(Navigator.canPop(context)) {
          Navigator.pop(context);
        }
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
              child: applicationBloc.getSelectedScreen()
          ),
        ],
      ),
    );
  }

  void showStartIntermediateEndDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StartIntermediateEndDialog();
        });
  }

  void showBinaryChoiceDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return BinaryChoiceDialog();
        });
  }

  BuildContext getContext() {
    return context;
  }

}
