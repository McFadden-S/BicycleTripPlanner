import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/managers/FavouriteRoutesManager.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/models/stop.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_trip_planner/widgets/general/other/Search.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../managers/DatabaseManager.dart';
import '../../models/place.dart';

class IntermediateSearchList extends StatefulWidget {
  const IntermediateSearchList({
    Key? key,
  }) : super(key: key);

  @override
  _IntermediateSearchListState createState() => _IntermediateSearchListState();
}

class _IntermediateSearchListState extends State<IntermediateSearchList> {
  List<TextEditingController> intermediateSearchControllers =
      <TextEditingController>[];

  RouteManager routeManager = RouteManager();

  List<Widget> stopsList = [];

  bool isShowingIntermediate = false;

  void _addStopWidget(ApplicationBloc applicationBloc, Stop stopIn,
      [bool showIntermediate = true]) {
    TextEditingController searchController = TextEditingController();
    intermediateSearchControllers.add(searchController);

    Stop waypoint = routeManager.getWaypoints().firstWhere(
        (stop) => stop == stopIn,
        orElse: () => routeManager.addWaypoint(const Place.placeNotFound()));

    stopsList.add(ListTile(
        key: Key("Stop ${stopsList.length + 1}"),
        title: Search(
            labelTextIn: "Stop",
            searchController: searchController,
            uid: waypoint.getUID()),
        trailing: Wrap(spacing: 12, children: <Widget>[
          IconButton(
              color: ThemeStyle.secondaryIconColor,
              key: Key("Remove ${intermediateSearchControllers.length}"),
              onPressed: () {
                setState(() {
                  int indexPressed =
                      intermediateSearchControllers.indexOf(searchController);
                  applicationBloc.clearLocationMarker(waypoint.getUID());
                  applicationBloc.clearSelectedLocation(waypoint.getUID());
                  stopsList.removeAt(indexPressed);
                  intermediateSearchControllers.removeAt(indexPressed);
                  routeManager.removeStop(waypoint.getUID());
                });
              },
              icon: Icon(Icons.remove_circle_outline,
                  color: ThemeStyle.secondaryIconColor)),
          Icon(
            Icons.drag_handle,
            color: ThemeStyle.secondaryIconColor,
          ),
        ])));

    if (!showIntermediate) return;
    isShowingIntermediate = true;
  }

  void toggleShowingIntermediate() {
    setState(() => {isShowingIntermediate = !isShowingIntermediate});
  }

  @override
  Widget build(BuildContext context) {
    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);

    stopsList.clear();
    intermediateSearchControllers.clear();

    List<Stop> stops = routeManager.getWaypoints();
    stops.forEach((stop) {
      _addStopWidget(applicationBloc, stop, false);
    });

    return InkWell(
        splashColor: Colors.deepPurple.withAlpha(30),
        onTap: toggleShowingIntermediate,
        child: Column(children: [
          Wrap(
            children: [
              TextButton(
                child: Text(
                  'Add Stop(s)',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 16.0,
                    color: ThemeStyle.primaryTextColor,
                  ),
                ),
                onPressed: () => setState(() {
                  _addStopWidget(applicationBloc, Stop());
                }),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      ThemeStyle.buttonPrimaryColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side: BorderSide(color: ThemeStyle.buttonPrimaryColor)),
                  ),
                ),
              ),
            ],
          ),
          LimitedBox(
            maxHeight: MediaQuery.of(context).size.height * 0.2,
            child: AnimatedSizeAndFade(
              fadeDuration: const Duration(milliseconds: 300),
              sizeDuration: const Duration(milliseconds: 300),
              child: isShowingIntermediate && stopsList.isNotEmpty
                  ? ReorderableListView(
                      shrinkWrap: true,
                      children: stopsList.toList(growable: true),
                      onReorder: (oldIndex, newIndex) => setState(() {
                        newIndex =
                            newIndex > oldIndex ? newIndex - 1 : newIndex;

                        routeManager.swapStops(
                            routeManager.getStopByIndex(oldIndex + 1).getUID(),
                            routeManager.getStopByIndex(newIndex + 1).getUID());

                        applicationBloc.notifyListeningWidgets();
                      }),
                    )
                  : SizedBox.shrink(),
            ),
          ),
          stopsList.isNotEmpty && isShowingIntermediate
              ? Icon(Icons.keyboard_arrow_up,
                  color: ThemeStyle.secondaryIconColor)
              : stopsList.isNotEmpty
                  ? Icon(Icons.keyboard_arrow_down,
                      color: ThemeStyle.secondaryIconColor)
                  : SizedBox.shrink(),
        ]));
  }
}
