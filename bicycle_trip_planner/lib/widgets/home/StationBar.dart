import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/managers/StationManager.dart';
import 'package:bicycle_trip_planner/managers/UserSettings.dart';
import 'package:bicycle_trip_planner/models/station.dart';
import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bicycle_trip_planner/widgets/home/StationCard.dart';
import '../../managers/DatabaseManager.dart';
import '../../models/pathway.dart';
import 'FavouriteRouteCard.dart';

class StationBar extends StatefulWidget {
  final auth;

  @visibleForTesting
  const StationBar({Key? key, this.auth}) : super(key: key);

  @override
  _StationBarState createState() => _StationBarState();
}

class _StationBarState extends State<StationBar> {
  late var auth;

  PageController stationsPageViewController = PageController();

  StationManager stationManager = StationManager();

  bool _isFavouriteStations = false;
  bool _isFavouriteRoutes = false;
  bool _isUserLogged = false;

  List<int> _favouriteStations = [];
  Map<String, Pathway> _favouriteRoutes = {};

  late final firebaseSubscription;

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

  deleteFavouriteRoute(String key) {
    if (DatabaseManager().isUserLogged()) {
      DatabaseManager().removeFavouriteRoute(key);
    }
    getFavouriteRoutes();
  }

  toggleFavouriteStation(Station station) {
    if (!_favouriteStations.contains(station.id)) {
      DatabaseManager()
          .addToFavouriteStations(station.id)
          .then((value) => getFavouriteStations());
    } else {
      DatabaseManager()
          .removeFavouriteStation(station.id.toString())
          .then((value) => getFavouriteStations());
    }
  }

  @override
  void initState() {
    firebaseSubscription =
        FirebaseAuth.instance.authStateChanges().listen((event) {
      _isUserLogged = event != null && !event.isAnonymous;
      setState(() {
        if (!_isUserLogged) {
          _isFavouriteStations = false;
          _isFavouriteRoutes = false;
        } else {
          getFavouriteStations();
          getFavouriteRoutes();
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    firebaseSubscription.cancel();
    super.dispose();
  }

  Widget dropdownButtons(StateSetter setState) {
    return DropdownButton(
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

        if (stationsPageViewController.positions.isNotEmpty)
          stationsPageViewController.jumpTo(0);
      },
      items: [
        DropdownMenuItem(
            child: Text(
              "Nearby Stations",
              style: TextStyle(
                  fontSize: 19.0, color: ThemeStyle.secondaryTextColor),
            ),
            value: "Nearby Stations"),
        DropdownMenuItem(
            child: Text("Favourite Stations",
                style: TextStyle(
                    fontSize: 19.0, color: ThemeStyle.secondaryTextColor)),
            value: "Favourite Stations"),
        DropdownMenuItem(
            child: Text("Favourite Routes",
                style: TextStyle(
                    fontSize: 19.0, color: ThemeStyle.secondaryTextColor)),
            value: "Favourite Routes"),
      ],
    );
  }

  Widget stationListBuilder(List<Station> stations, String errorMessage,
      [Axis scrollDirection = Axis.vertical]) {
    return stations.isNotEmpty
        ? ListView.builder(
            scrollDirection: scrollDirection,
            itemCount: stations.length,
            itemBuilder: (BuildContext context, int index) {
              Station station = stations[index];
              return StationCard(
                  station: station,
                  isFavourite: _favouriteStations.contains(station.id),
                  toggleFavourite: (Station station) {
                    toggleFavouriteStation(station);
                  });
            })
        : Center(
            child: Text(errorMessage,
                style: TextStyle(color: ThemeStyle.primaryTextColor)),
          );
  }

  Widget favouriteRouteListBuilder(String errorMessage,
      [Axis scrollDirection = Axis.vertical]) {
    return FutureBuilder<Map<String, Pathway>>(
        future: DatabaseManager().getFavouriteRoutes(),
        builder: (context, snapshot) {
          Map<String, Pathway> routes = {};
          if (snapshot.data != null) {
            routes = snapshot.data!;
          } else {
            return centeredLoadingKit();
          }
          return routes.isNotEmpty
              ? ListView.builder(
                  scrollDirection: scrollDirection,
                  itemCount: routes.length,
                  itemBuilder: (BuildContext context, int index) {
                    Pathway valueRoute = routes[routes.keys.toList()[index]]!;
                    String keyRoute = routes.keys.toList()[index];
                    return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.15,
                        child: FavouriteRouteCard(
                          keyRoute: keyRoute,
                          valueRoute: valueRoute,
                          deleteRoute: deleteFavouriteRoute,
                        ));
                  })
              : Center(
                  child: Text(errorMessage,
                      style: TextStyle(color: ThemeStyle.primaryTextColor)),
                );
        });
  }

  Widget centeredLoadingKit() {
    return Center(
      child: CircularProgressIndicator(color: ThemeStyle.primaryTextColor),
    );
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
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
            final applicationBloc = Provider.of<ApplicationBloc>(context);

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
                                      ? dropdownButtons(setModalState)
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
                                  child: _isFavouriteRoutes
                                      ? favouriteRouteListBuilder(
                                          "You don't have any favourite routes currently.")
                                      : _isFavouriteStations
                                          ? FutureBuilder<List<Station>>(
                                              future: stationManager
                                                  .getFavouriteStations(),
                                              builder: (context, snapshot) {
                                                List<Station>
                                                    favouriteStations = [];
                                                if (snapshot.data != null) {
                                                  favouriteStations =
                                                      snapshot.data!;
                                                } else {
                                                  return centeredLoadingKit();
                                                }
                                                return stationListBuilder(
                                                    favouriteStations,
                                                    "You don't have any favourite stations.");
                                              })
                                          : FutureBuilder<double>(
                                              future: UserSettings()
                                                  .nearbyStationsRange(),
                                              builder: (context, snapshot) {
                                                List<Station> nearbyStations =
                                                    [];
                                                int groupSize = RouteManager()
                                                    .getGroupSize();
                                                if (snapshot.data != null) {
                                                  nearbyStations =
                                                      StationManager()
                                                          .getNearStations(
                                                              snapshot.data!);
                                                  nearbyStations =
                                                      stationManager
                                                          .getStationsWithBikes(
                                                              groupSize,
                                                              nearbyStations);
                                                } else {
                                                  return centeredLoadingKit();
                                                }
                                                return stationListBuilder(
                                                  nearbyStations,
                                                  "You don't have any nearby stations,"
                                                      "\ntry changing the range in the settings.",
                                                );
                                              })
                              )
                            ],
                          )
                      )
                  ),
                ],
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context, listen: true);

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
                        ? dropdownButtons(setState)
                        : Text(
                            "Nearby Stations",
                            style: TextStyle(
                                fontSize: 25.0,
                                color: ThemeStyle.secondaryTextColor),
                          ),
                    const Spacer(),
                    IconButton(
                      key: Key("first_page"),
                      padding: const EdgeInsets.all(0),
                      onPressed: () => stationsPageViewController.jumpTo(0),
                      icon: Icon(Icons.first_page,
                          color: ThemeStyle.secondaryIconColor),
                    ),
                    IconButton(
                      key: Key("menu"),
                      onPressed: () => showExpandedList(),
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
                        child: stationManager.getNumberOfStations() > 0
                            ? _isFavouriteRoutes
                                ? favouriteRouteListBuilder(
                                    "You don't have any favourite routes currently.",
                                    Axis.horizontal)
                                : _isFavouriteStations
                                    ? FutureBuilder<List<Station>>(
                                        future: stationManager
                                            .getFavouriteStations(),
                                        builder: (context, snapshot) {
                                          List<Station> favouriteStations = [];
                                          if (snapshot.data != null) {
                                            favouriteStations = snapshot.data!;
                                          } else {
                                            return centeredLoadingKit();
                                          }
                                          return stationListBuilder(
                                              favouriteStations,
                                              "You don't have any favourite stations at the moment.",
                                              Axis.horizontal);
                                        })
                                    : FutureBuilder<double>(
                                        future: UserSettings()
                                            .nearbyStationsRange(),
                                        builder: (context, snapshot) {
                                          List<Station> nearbyStations = [];
                                          if (snapshot.data != null) {
                                            nearbyStations = StationManager()
                                                .getNearStations(
                                                    snapshot.data!);
                                            int groupSize =
                                                RouteManager().getGroupSize();
                                            nearbyStations = stationManager
                                                .getStationsWithBikes(
                                                    groupSize, nearbyStations);
                                          } else {
                                            return centeredLoadingKit();
                                          }
                                          return stationListBuilder(
                                              nearbyStations,
                                              "You don't have any nearby stations,"
                                                  "\ntry changing the range in the settings.",
                                              Axis.horizontal);
                                        })
                            : const Center(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
      ),
    );
  }
}
