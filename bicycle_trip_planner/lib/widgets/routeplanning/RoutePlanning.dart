import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/managers/DatabaseManager.dart';
import 'package:bicycle_trip_planner/managers/DialogManager.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/widgets/general/buttons/CircleButton.dart';
import 'package:bicycle_trip_planner/widgets/general/other/CustomBottomSheet.dart';
import 'package:bicycle_trip_planner/widgets/general/other/GroupSizeSelector.dart';
import 'package:bicycle_trip_planner/widgets/general/buttons/OptimisedButton.dart';
import 'package:bicycle_trip_planner/widgets/general/buttons/ViewRouteButton.dart';
import 'package:bicycle_trip_planner/widgets/general/other/DistanceETACard.dart';
import 'package:bicycle_trip_planner/widgets/general/buttons/CustomBackButton.dart';
import 'package:bicycle_trip_planner/widgets/general/buttons/CurrentLocationButton.dart';
import 'package:bicycle_trip_planner/managers/UserSettings.dart';
import 'package:bicycle_trip_planner/widgets/routeplanning/RecentRouteCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:bicycle_trip_planner/widgets/general/buttons/OptimiseCostButton.dart';

import '../../constants.dart';
import '../../models/search_types.dart';
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
  final DialogManager _dialogManager = DialogManager();

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
                            _routeManager.ifRouteSet() &&
                                    _routeManager.getWaypoints().length > 1 &&
                                    !_routeManager.ifCostOptimised()
                                ? Column(
                                    children: [
                                      OptimisedButton(),
                                      SizedBox(height: 10),
                                    ],
                                  )
                                : SizedBox.shrink(),
                            OptimiseCostButton(),
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
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                    Column(
                      children: [
                        DatabaseManager().isUserLogged()
                            ? CircleButton(
                            iconIn: Icons.star,
                            iconColor: ThemeStyle.primaryIconColor,
                            onButtonClicked: () => saveRoute(context))
                            : SizedBox.shrink(),
                        SizedBox(height: 10),
                        _recentRoutesCount != 0
                            ? CircleButton(
                            iconIn: Icons.history,
                            iconColor: ThemeStyle.primaryIconColor,
                            onButtonClicked: () => showRecentRoutes())
                            : const SizedBox.shrink(),
                      ],
                    ),
                    Spacer(),
                    CustomBackButton(context: context, backTo: 'home'),
                  ]),
                ),
                CustomBottomSheet(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 10),
                          Expanded(
                              child: DistanceETACard()),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: ElevatedButton(
                                  child: Icon(Icons.directions_bike),
                                  onPressed: () => startJourney(applicationBloc),
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Colors.green)
                                  ),
                              ),
                            ),
                          ),
                        ]),
                  ),
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
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0))),
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.only(bottom: 20.0),
            decoration: BoxDecoration(
                color: ThemeStyle.cardColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0)),
                boxShadow: [
                  BoxShadow(
                    color: ThemeStyle.stationShadow,
                    spreadRadius: 8,
                    blurRadius: 6,
                    offset: const Offset(0, 0),
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
    _recentRoutesCount = 0;
    int recentRoutesCount = await _userSettings.getNumberOfRoutes();
    setState(() {
      _recentRoutesCount = recentRoutesCount;
    });
  }

  startJourney(ApplicationBloc applicationBloc) {
    if (_routeManager.ifRouteSet()) {
      if (_routeManager
          .getStart()
          .getStop()
          .description !=
          SearchType.current.description) {
        _dialogManager.setBinaryChoice(
          "Do you want to walk to start or be routed to it?",
          "Walk",
              () {
            _routeManager
                .setWalkToFirstWaypoint(true);
          },
          "Route",
              () {
            _routeManager
                .setWalkToFirstWaypoint(false);
          },
        );

        applicationBloc.showBinaryDialog();
      }

      applicationBloc.startNavigation();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(
        content: Text("No route could be found!"),
      ));
    }
  }
}

// Note: This is outside of the state class...
saveRoute(context) async {
  final databaseManager = DatabaseManager();
  final routeManager = RouteManager();

  bool successfullyAdded = await databaseManager
      .addToFavouriteRoutes(
          routeManager.getStart().getStop(),
          routeManager.getDestination().getStop(),
          routeManager
              .getWaypoints()
              .map((waypoint) => waypoint.getStop())
              .toList())
      .then((v) {
    return v;
  });
  ;
  if (successfullyAdded) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Route saved correctly!"),
    ));
  } else {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Error while saving the route!"),
    ));
  }
}
