import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_trip_planner/widgets/general/MapWidget.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

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
              color: Colors.white.withOpacity(0.4),
              child: SizedBox(height: topPaddingHeight, width: MediaQuery.of(context).size.width)
            ),
          ),
          applicationBloc.getSelectedScreen()
        ],
      ),
    );
  }
}

