import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/widgets/general/buttons/CircleButton.dart';
import 'package:bicycle_trip_planner/widgets/general/buttons/CurrentLocationButton.dart';
import 'package:bicycle_trip_planner/widgets/weather/weather.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_trip_planner/widgets/general/other/Search.dart';
import 'package:bicycle_trip_planner/widgets/home/StationBar.dart';
import 'package:provider/provider.dart';
import '../general/other/GroupSizeSelector.dart';
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
    Size size = MediaQuery.of(context).size;

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
                          key: Key("settingsButton"),
                          icon: Icon(
                            Icons.settings,
                            color: ThemeStyle.primaryTextColor,
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
                ],
              ),
            ),
          ),
          Align(
              key: Key("bottomAlignment"),
              alignment: Alignment.bottomCenter,
              child: Wrap(
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: Weather()),
                                Spacer(),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 15),
                                  child: Column(
                                    children: [
                                      CurrentLocationButton(),
                                      SizedBox(height: 10),
                                      CircleButton(
                                        key: Key("navigateToRoutePlanningScreenButton"),
                                        iconIn: Icons.assistant_direction,
                                        onButtonClicked: () => applicationBloc
                                            .setSelectedScreen('routePlanning'),
                                      ),
                                      SizedBox(height: 10),
                                      GroupSizeSelector(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
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