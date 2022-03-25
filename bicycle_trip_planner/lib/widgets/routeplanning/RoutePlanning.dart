import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/managers/DatabaseManager.dart';
import 'package:bicycle_trip_planner/managers/FavouriteRoutesManager.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/managers/UserSettings.dart';
import 'package:bicycle_trip_planner/widgets/general/CircleButton.dart';
import 'package:bicycle_trip_planner/widgets/general/CustomBottomSheet.dart';
import 'package:bicycle_trip_planner/widgets/general/GroupSizeSelector.dart';
import 'package:bicycle_trip_planner/widgets/general/OptimisedButton.dart';
import 'package:bicycle_trip_planner/widgets/general/ViewRouteButton.dart';
import 'package:bicycle_trip_planner/widgets/general/WalkToFirstButton.dart';
import 'package:bicycle_trip_planner/widgets/general/DistanceETACard.dart';
import 'package:bicycle_trip_planner/widgets/general/CustomBackButton.dart';
import 'package:bicycle_trip_planner/widgets/general/RoundedRectangleButton.dart';
import 'package:bicycle_trip_planner/widgets/general/CurrentLocationButton.dart';
import 'package:bicycle_trip_planner/widgets/routeplanning/RecentRouteCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import 'RecentRouteCard.dart';
import 'RoutePlanningCard.dart';

class RoutePlanning extends StatefulWidget {
  RoutePlanning({Key? key}) : super(key: key);

  @override
  _RoutePlanningState createState() => _RoutePlanningState();
}

class _RoutePlanningState extends State<RoutePlanning> {
  bool showRouteCard = true;
  bool isOptimised = false;
  late int _recentRoutesCount;

  final RouteManager _routeManager = RouteManager();
  final UserSettings _userSettings = UserSettings();

  @override
  void initState() {
    super.initState();
    _recentRoutesCount = 0;
    getRecentRoutesCount();
  }

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);

    return SafeArea(
      bottom: false,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Visibility(
                    child: RoutePlanningCard(),
                    maintainState: true,
                    visible: showRouteCard),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    setState(() {
                      showRouteCard = false;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Column(
                          children: [
                            !showRouteCard
                                ? CircleButton(
                                    iconIn: Icons.search,
                                    iconColor: ThemeStyle.primaryIconColor,
                                    onButtonClicked: () {
                                      setState(() {
                                        showRouteCard = true;
                                      });
                                    })
                                : Container(),
                            !showRouteCard ? SizedBox(height: 10) : Container(),
                            CurrentLocationButton(
                              key: Key("currentLocationButton")
                            ),
                            SizedBox(height: 10),
                            ViewRouteButton(),
                            SizedBox(height: 10),
                            OptimisedButton(),
                            SizedBox(height: 10),
                            WalkToFirstButton(),
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
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Row(children: [
                    _recentRoutesCount != 0
                        ? CircleButton(
                            iconIn: Icons.history,
                            iconColor: ThemeStyle.primaryIconColor,
                            onButtonClicked: () => showRecentRoutes())
                        : SizedBox.shrink(),
                    Spacer(),
                    CustomBackButton(context: context, backTo: 'home'),
                  ]),
                ),
                CustomBottomSheet(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Wrap(
                          children: [DistanceETACard()],
                        ),
                        Spacer(),
                        DatabaseManager().isUserLogged()
                            ? SizedBox(
                                width: 50,
                                child: ElevatedButton(
                                    onPressed: () {
                                      saveRoute(context);
                                    },
                                    child: Icon(
                                      Icons.save,
                                      color: ThemeStyle.secondaryFontColor,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(17.0),
                                      ),
                                      primary: ThemeStyle.buttonSecondaryColor,
                                    )))
                            : Container(),
                        Spacer(),
                        Expanded(
                          flex: 20,
                          child: RoundedRectangleButton(
                              iconIn: Icons.directions_bike,
                              buttonColor: ThemeStyle.goButtonColor,
                              onButtonClicked: () {
                                if (_routeManager.ifRouteSet()) {
                                  // TODO: call method here that stores the route
                                  applicationBloc.startNavigation();
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text("No route could be found!"),
                                  ));
                                }
                              }),
                        )
                      ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showRecentRoutes() async {
    showModalBottomSheet(
        enableDrag: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0))),
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.only(bottom: 20.0),
            decoration: BoxDecoration(
                color: ThemeStyle.cardColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0)),
                boxShadow: [
                  BoxShadow(
                    color: ThemeStyle.stationShadow,
                    spreadRadius: 8,
                    blurRadius: 6,
                    offset: Offset(0, 0),
                  )
                ]),
            child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text("Recent Journeys",
                          style: TextStyle(
                              fontSize: 25.0,
                              color: ThemeStyle.secondaryTextColor)),
                    ),
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: _recentRoutesCount, // number of cards
                              itemBuilder: (BuildContext context, int index) =>
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.15,
                                      child: RecentRouteCard(
                                          index: _recentRoutesCount -
                                              1 -
                                              index)))),
                    ),
                  ],
                )),
          );
        });
  }

  getRecentRoutesCount() async {
    int recentRoutesCount = await _userSettings.getNumberOfRoutes();
    setState(() {
      _recentRoutesCount = recentRoutesCount;
    });
  }
}

saveRoute(context) async {
  final databaseManager = DatabaseManager();
  final routeManager = RouteManager();
  final FavouriteRoutesManager favouriteRoutesManager =
      FavouriteRoutesManager();

  bool successfullyAdded = await databaseManager
      .addToFavouriteRoutes(
          routeManager.getStart().getStop(),
          routeManager.getDestination().getStop(),
          routeManager
              .getWaypoints()
              .map((waypoint) => waypoint.getStop())
              .toList())
      .then((v) {
    favouriteRoutesManager.updateRoutes();
    return v;
  });
  ;
  if (successfullyAdded) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Route saved correctly!"),
    ));
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Error while saving the route!"),
    ));
  }
}
