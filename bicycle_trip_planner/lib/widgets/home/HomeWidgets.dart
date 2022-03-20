import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/widgets/general/CircleButton.dart';
import 'package:bicycle_trip_planner/widgets/general/CurrentLocationButton.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_trip_planner/widgets/general/Search.dart';
import 'package:bicycle_trip_planner/widgets/home/StationBar.dart';
import 'package:provider/provider.dart';
import '../general/GroupSizeSelector.dart';
import '../settings/SettingsScreen.dart';

class HomeWidgets extends StatefulWidget {
  const HomeWidgets({Key? key}) : super(key: key);

  @override
  _HomeWidgetsState createState() => _HomeWidgetsState();
}

class _HomeWidgetsState extends State<HomeWidgets> {
  final RouteManager routeManager = RouteManager();

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);

    return SafeArea(
      bottom: false,
      child: Stack(
        children: [
          Align(
            key: Key("topAlignment"),
            alignment: FractionalOffset.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: ThemeStyle.cardColor,
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Search(
                            labelTextIn: 'Search',
                            searchController: TextEditingController(),
                            uid: routeManager.getDestination().getUID(),
                          ),
                        ),
                        IconButton(
                          key: Key('settingsButton'),
                          icon: Icon(
                            Icons.settings,
                            color: ThemeStyle.buttonPrimaryColor,
                          ),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return SettingsScreen();
                                },
                              ),
                            );
                          },
                          iconSize: 50,
                        )
                      ],
                    ),
                  ),
                  Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/weather'),
                      child: Container(
                          margin: EdgeInsets.only(top: 5),
                          width: 60.0,
                          height: 60.0,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage('assets/weather.png'),
                              ))),
                    )
                  ]),
                ],
              ),
            ),
          ),
          Align(
              key: Key("bottomAlignment"),
              alignment: FractionalOffset.bottomCenter,
              child: Wrap(
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                              margin: EdgeInsets.only(bottom: 20),
                              child: Column(
                                children: [
                                  CurrentLocationButton(),
                                  SizedBox(height: 10),
                                  GroupSizeSelector(),
                                  SizedBox(height: 10),
                                  CircleButton(
                                    key: Key("navigateToRoutePlanningScreenButton"),
                                      iconIn: Icons.assistant_direction,
                                      onButtonClicked: () => applicationBloc.setSelectedScreen('routePlanning'),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ],
                  ),
                  StationBar(),
                ],
              )),
        ],
      ),
    );
  }
}
