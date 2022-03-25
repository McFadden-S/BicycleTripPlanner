import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/managers/FavouriteRoutesManager.dart';
import 'package:bicycle_trip_planner/managers/StationManager.dart';
import 'package:bicycle_trip_planner/managers/UserSettings.dart';
import 'package:bicycle_trip_planner/models/station.dart';
import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/models/station.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  toggleFavouriteStation(Station station) {
    // Check if user is logged in...
    if (!_favouriteStations.contains(station.id)) {
      DatabaseManager()
          .addToFavouriteStations(station.id)
          .then((value) => getFavouriteStations());
    } else {
      DatabaseManager()
          .removeFavouriteStation(station.id.toString())
          .then((value) => getFavouriteStations());
    }
    //appBloc!.notifyListeningWidgets();
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

  Widget routeListBuilder(String errorMessage,
      [Axis scrollDirection = Axis.vertical]) {
    return FavouriteRoutesManager().getNumberOfRoutes() > 0
        ? ListView.builder(
            scrollDirection: scrollDirection,
            itemCount: FavouriteRoutesManager().getNumberOfRoutes(),
            itemBuilder: (BuildContext context, int index) => SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
                child: FavouriteRouteCard(
                  index: index,
                  deleteRoute: deleteFavouriteRoute,
                )))
        : Center(
            child: Text(errorMessage,
                style: TextStyle(color: ThemeStyle.primaryTextColor)),
          );
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
                                      ? routeListBuilder(
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
                                                    "You don't have any favourite stations currently.");
                                              })
                                          // Currently gets all stations. Can be changed to only nearby
                                          : stationListBuilder(
                                              stationManager.getStations(),
                                              "There are no stations currently.")),
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
                        ? dropdownButtons(setState)
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
                        child: stationManager.getNumberOfStations() > 0
                            ? _isFavouriteRoutes
                                ? routeListBuilder(
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
                                          } else {
                                            return centeredLoadingKit();
                                          }
                                          return stationListBuilder(
                                              nearbyStations,
                                              "You don't have any nearby stations at the moment.",
                                              Axis.horizontal);
                                        })
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
