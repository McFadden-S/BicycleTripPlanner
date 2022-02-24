import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/widgets/general/CircleButton.dart';
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
    final applicationBloc = Provider.of<ApplicationBloc>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          MapWidget(),
          applicationBloc.previousScreen == null ? Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0, bottom: 80.0),
                    child: CircleButton(
                        iconIn: Icons.arrow_back,
                        onButtonClicked: () => applicationBloc.goBack()
                    ),
                  ),
                ],
              ),
            ],
          ) : SizedBox.shrink(),
          applicationBloc.getSelectedScreen()
        ],
      ),
    );
  }
}
