import 'dart:async';
import 'dart:io';
import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/managers/LocationManager.dart';
import 'package:bicycle_trip_planner/widgets/general/dialogs/BinaryChoiceDialog.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_trip_planner/widgets/general/other/MapWidget.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:bicycle_trip_planner/widgets/general/dialogs/SelectStationDialog.dart';

import '../../managers/DialogManager.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late StreamSubscription connectivitySubscription;
  late StreamSubscription<ServiceStatus> serviceStatusStream;
  final DialogManager _dialogManager = DialogManager();
  LocationManager locationManager = LocationManager();

  @override
  void initState() {
    super.initState();
    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        // I am not connected at all
        Navigator.pushNamed(context, '/error');
      } else {
        // I am connected to a mobile/wifi network
        // NB: Will pop off the current widget on stack... If
        // error widget is not on top of stack, error will not be
        // popped off.
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      }
    });

    // check location service is constantly on
    serviceStatusStream = Geolocator.getServiceStatusStream().listen(
            (ServiceStatus status) async {
          if (status == ServiceStatus.disabled) {
            // location requested and if denied twice, app is closed
            if (!(await locationManager.requestPermission())) {
              await locationManager.openLocationSettingsOnDevice();
              if (!(await locationManager.requestPermission())) {
                exit(0);
              }
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
                child: SizedBox(
                    height: topPaddingHeight,
                    width: MediaQuery.of(context).size.width)),
          ),
          AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: applicationBloc.getSelectedScreen()
          ),
          SelectStationDialog(),
          BinaryChoiceDialog(),
        ],
      ),
    );
  }

}
