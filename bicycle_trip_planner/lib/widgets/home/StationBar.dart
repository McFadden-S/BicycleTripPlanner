import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/managers/FavouriteRoutesManager.dart';
import 'package:bicycle_trip_planner/managers/StationManager.dart';
import 'package:bicycle_trip_planner/managers/UserSettings.dart';
import 'package:bicycle_trip_planner/models/station.dart';
import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bicycle_trip_planner/widgets/home/StationCard.dart';
import '../../managers/DatabaseManager.dart';
import '../../models/pathway.dart';
import 'RouteCard.dart';
import 'FavouriteRouteCard.dart';

class StationBar extends StatefulWidget {
  const StationBar({Key? key}) : super(key: key);

  @override
  _StationBarState createState() => _StationBarState();
}

class _StationBarState extends State<StationBar> {
  PageController stationsPageViewController = PageController();

  StationManager stationManager = StationManager();
  FavouriteRoutesManager favouriteRoutesManager = FavouriteRoutesManager();

  bool _isFavouriteStations = false;
  bool _isFavouriteRoutes = false;
  bool _isUserLogged = false;

  List<int> _favouriteStations = [];
  Map<String, Pathway> _favouriteRoutes = {};

  getFavouriteStations() async {
    DatabaseManager().getFavouriteStations().then((value) => setState(() {
          _favouriteStations = value;
        }));
  }

  getFavouriteRoutes() async {
    DatabaseManager().getFavouriteRoutes().then((value) => setState(() {
          _favouriteRoutes = value;
        }));
  }

  deleteFavouriteRoute(int index) {
    if (DatabaseManager().isUserLogged()) {
      DatabaseManager()
          .removeFavouriteRoute(FavouriteRoutesManager().getKey(index));
    }
    FavouriteRoutesManager().updateRoutes();
    getFavouriteRoutes();
  }

  toggleFavouriteStation(int id) {
    if (DatabaseManager().isUserLogged() &&
        stationManager.getStations().any((station) => station.id == id)) {
      if (!_favouriteStations.contains(id)) {
        DatabaseManager()
            .addToFavouriteStations(id)
            .then((value) => getFavouriteStations());
      } else {
        DatabaseManager()
            .removeFavouriteStation(id.toString())
            .then((value) => getFavouriteStations());
      }
    }
  }

  @override
  void initState() {
    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);

    FirebaseAuth.instance.authStateChanges().listen((event) {
      setState(() {
        _isUserLogged = event != null && !event.isAnonymous;
      });

      applicationBloc.updateStations();

      if (_isUserLogged == false) {
        UserSettings().setIsFavouriteStationsSelected(false);
        setState(() {
          _isFavouriteStations = false;
        });
      } else {
        getFavouriteStations();
        getFavouriteRoutes();
      }
    });
    super.initState();
  }

  void showExpandedList() {
    showModalBottomSheet(
        enableDrag: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0))),
        context: context,
        builder: (BuildContext context) {
          List<int> favourites = [];
          bool _favouriteStations = _isFavouriteStations;
          bool _favouriteRoutes = _isFavouriteRoutes;
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
            final applicationBloc = Provider.of<ApplicationBloc>(context);

            updateFavouriteStations() {
              if (_isUserLogged) {
                DatabaseManager().getFavouriteStations().then((value) {
                  try {
                    setModalState(() {
                      favourites = value;
                    });
                  } catch (error) {
                    return;
                  }
                });
              }
            }

            updateFavouriteStations();
            return Container(
              padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
              decoration: BoxDecoration(
                color: ThemeStyle.cardColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  _isUserLogged
                                      ? DropdownButton(
                                          dropdownColor: ThemeStyle.cardColor,
                                          value: _favouriteStations
                                              ? "Favourite Stations"
                                              : _favouriteRoutes
                                                  ? "Favourite Routes"
                                                  : "Nearby Stations",
                                          onChanged: (String? newValue) {
                                            setModalState(() {
                                              newValue == "Favourite Stations"
                                                  ? _favouriteStations = true
                                                  : _favouriteStations = false;
                                              newValue == "Favourite Routes"
                                                  ? _favouriteRoutes = true
                                                  : _favouriteRoutes = false;
                                            });
                                            setState(() {
                                              _isFavouriteStations =
                                                  _favouriteStations;
                                              _isFavouriteRoutes =
                                                  _favouriteRoutes;
                                            });
                                            UserSettings()
                                                .setIsFavouriteStationsSelected(
                                                    _favouriteStations);
                                            updateFavouriteStations();
                                            applicationBloc.updateStations();
                                            if (stationsPageViewController
                                                .positions.isNotEmpty)
                                              stationsPageViewController
                                                  .jumpTo(0);
                                          },
                                          items: [
                                            DropdownMenuItem(
                                                child: Text(
                                                  "Nearby Stations",
                                                  style: TextStyle(
                                                      fontSize: 19.0,
                                                      color: ThemeStyle
                                                          .secondaryTextColor),
                                                ),
                                                value: "Nearby Stations"),
                                            DropdownMenuItem(
                                                child: Text(
                                                    "Favourite Stations",
                                                    style: TextStyle(
                                                        fontSize: 19.0,
                                                        color: ThemeStyle
                                                            .secondaryTextColor)),
                                                value: "Favourite Stations"),
                                            DropdownMenuItem(
                                                child: Text("Favourite Routes",
                                                    style: TextStyle(
                                                        fontSize: 19.0,
                                                        color: ThemeStyle
                                                            .secondaryTextColor)),
                                                value: "Favourite Routes"),
                                          ],
                                        )
                                      : Text(
                                          "Nearby Stations",
                                          style: TextStyle(
                                              fontSize: 25.0,
                                              color: ThemeStyle
                                                  .secondaryTextColor),
                                        ),
                                  const Spacer(),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Expanded(
                                  child: _favouriteRoutes
                                      ? ListView.builder(
                                          itemCount: FavouriteRoutesManager()
                                              .getNumberOfRoutes(),
                                          itemBuilder: (BuildContext context,
                                                  int index) =>
                                              SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.15,
                                                  child: FavouriteRouteCard(
                                                    index: index,
                                                    deleteRoute:
                                                        deleteFavouriteRoute,
                                                  )))
                                      : ListView.builder(
                                          itemCount: stationManager
                                              .getNumberOfDisplayedStations(),
                                          itemBuilder: (BuildContext context,
                                                  int index) =>
                                              StationCard(
                                                  index: index,
                                                  isFavourite: favourites
                                                      .contains(stationManager
                                                          .getDisplayedStation(
                                                              index)
                                                          .id),
                                                  toggleFavourite: (int index) {
                                                    toggleFavouriteStation(
                                                        stationManager
                                                            .getDisplayedStation(
                                                                index)
                                                            .id);
                                                    updateFavouriteStations();
                                                  }))),
                              const SizedBox(height: 10),
                              Expanded(
                                  child: _favouriteRoutes
                                      ? ListView.builder(
                                          itemCount: FavouriteRoutesManager()
                                              .getNumberOfRoutes(),
                                          itemBuilder: (BuildContext context,
                                                  int index) =>
                                              SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.15,
                                                  child: FavouriteRouteCard(
                                                    index: index,
                                                    deleteRoute:
                                                        deleteFavouriteRoute,
                                                  )))
                                      : ListView.builder(
                                          itemCount: StationManager()
                                              .getNumberOfStations(),
                                          itemBuilder: (BuildContext context,
                                                  int index) =>
                                              StationCard(
                                                  index: index,
                                                  isFavourite: favourites
                                                      .contains(StationManager()
                                                          .getStationByIndex(
                                                              index)
                                                          .id),
                                                  toggleFavourite: (int index) {
                                                    toggleFavouriteStation(
                                                        index);
                                                    updateFavouriteStations();
                                                  }))),
                            ],
                          ))),
                ],
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context, listen: true);

    _isUserLogged = applicationBloc.isUserLogged();

    return Container(
      padding: const EdgeInsets.only(bottom: 20.0),
      decoration: BoxDecoration(
          color: ThemeStyle.cardColor,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
          boxShadow: [
            BoxShadow(
              color: ThemeStyle.stationShadow,
              spreadRadius: 8,
              blurRadius: 6,
              offset: const Offset(0, 0),
            )
          ]),
      child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.22,
          child: Column(
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    _isUserLogged
                        ? DropdownButton(
                            dropdownColor: ThemeStyle.cardColor,
                            value: _isFavouriteStations
                                ? "Favourite Stations"
                                : _isFavouriteRoutes
                                    ? "Favourite Routes"
                                    : "Nearby Stations",
                            onChanged: (String? newValue) {
                              setState(() {
                                newValue! == "Favourite Stations"
                                    ? _isFavouriteStations = true
                                    : _isFavouriteStations = false;
                                newValue == "Favourite Routes"
                                    ? _isFavouriteRoutes = true
                                    : _isFavouriteRoutes = false;
                              });
                              UserSettings().setIsFavouriteStationsSelected(
                                  _isFavouriteStations);
                              applicationBloc.updateStations();
                              if (stationManager
                                      .getNumberOfDisplayedStations() >
                                  0) stationsPageViewController.jumpTo(0);
                            },
                            items: [
                              DropdownMenuItem(
                                  child: Text(
                                    "Nearby Stations",
                                    style: TextStyle(
                                        fontSize: 19.0,
                                        color: ThemeStyle.secondaryTextColor),
                                  ),
                                  value: "Nearby Stations"),
                              DropdownMenuItem(
                                  child: Text("Favourite Stations",
                                      style: TextStyle(
                                          fontSize: 19.0,
                                          color:
                                              ThemeStyle.secondaryTextColor)),
                                  value: "Favourite Stations"),
                              DropdownMenuItem(
                                  child: Text("Favourite Routes",
                                      style: TextStyle(
                                          fontSize: 19.0,
                                          color:
                                              ThemeStyle.secondaryTextColor)),
                                  value: "Favourite Routes"),
                            ],
                          )
                        : Text(
                            "Nearby Stations",
                            style: TextStyle(
                                fontSize: 25.0,
                                color: ThemeStyle.secondaryTextColor),
                          ),
                    const Spacer(),
                    IconButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () => stationsPageViewController.jumpTo(0),
                      icon: Icon(Icons.first_page,
                          color: ThemeStyle.secondaryIconColor),
                    ),
                    IconButton(
                      onPressed: () => showExpandedList(),
                      //onPressed: () => showExpandedList(stationManager.getStations(), applicationBloc),
                      icon: Icon(Icons.menu,
                          color: ThemeStyle.secondaryIconColor),
                    ),
                  ],
                ),
              )),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.165,
                child: Row(
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: stationManager.getNumberOfDisplayedStations() > 0
                            ? _isFavouriteRoutes
                                ? ListView.builder(
                                    controller: stationsPageViewController,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: favouriteRoutesManager
                                        .getNumberOfRoutes(),
                                    itemBuilder: (BuildContext context,
                                            int index) =>
                                        FavouriteRouteCard(
                                          index: index,
                                          deleteRoute: deleteFavouriteRoute,
                                        ))
                                : ListView.builder(
                                    controller: stationsPageViewController,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: stationManager
                                        .getNumberOfDisplayedStations(),
                                    itemBuilder: (BuildContext context,
                                            int index) =>
                                        StationCard(
                                            index: index,
                                            isFavourite: _favouriteStations
                                                .contains(stationManager
                                                    .getDisplayedStation(index)
                                                    .id),
                                            toggleFavourite:
                                                toggleFavouriteStation(
                                                    stationManager
                                                        .getDisplayedStation(
                                                            index)
                                                        .id)))
                            : _isFavouriteStations
                                ? const Center(
                                    child: Text(
                                        "You don't have any favourite station at the moment."),
                                  )
                                : const Center(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
