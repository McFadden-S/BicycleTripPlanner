import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/managers/DatabaseManager.dart';
import 'package:bicycle_trip_planner/managers/StationManager.dart';
import 'package:bicycle_trip_planner/models/station.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_trip_planner/widgets/settings/FavouriteStationCard.dart';

class FavouriteBar extends StatefulWidget {
  const FavouriteBar({ Key? key }) : super(key: key);

  @override
  _FavouriteBarState createState() => _FavouriteBarState();
}

class _FavouriteBarState extends State<FavouriteBar> {

  PageController stationsPageViewController = PageController();

  StationManager stationManager = StationManager();
  DatabaseManager databaseManager = DatabaseManager();

  List<Station> stations = [];

  Future<List<Station>> getFavouriteStations() async {
    List<Station> stations =[];
    List<int> stationIDs = await databaseManager.getFavouriteStations() ;

    for(int id in stationIDs){
      stations.add(stationManager.getStationById(id));
    }

    return stations;
  }

  @override
  void initState()  {
    super.initState();
    getFavouriteStations().then((value){
      setState(() {
        stations = value;
      });
    });
  }

  void showExpandedList(List<Station> stations) {
    showModalBottomSheet(
        enableDrag: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0))),
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
            decoration: BoxDecoration(
              color: ThemeStyle.cardColor,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          //color: Color(0xff345955),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text("Favourite Stations", style: TextStyle(fontSize: 25.0, color: ThemeStyle.secondaryTextColor)),
                                const Spacer(),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: ListView.builder(
                                  itemCount: stations.length,
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                      FavouriteStationCard(index: index, stations: stations)),
                            ),
                          ],
                        )
                    )
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {

    //final applicationBloc = Provider.of<ApplicationBloc>(context);
     getFavouriteStations();

    return Container(
      padding: const EdgeInsets.only(bottom: 20.0),
      decoration: BoxDecoration(
          color: ThemeStyle.cardColor,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
          boxShadow: [ BoxShadow(color: ThemeStyle.stationShadow, spreadRadius: 8, blurRadius: 6, offset: Offset(0, 0),)]
      ),
      child: SizedBox(
          height: 180.0,
          child: Column(
            children: [
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      children: [
                        Text("Favourite Stations", style: TextStyle(fontSize: 25.0, color: ThemeStyle.secondaryTextColor),),
                        const Spacer(),
                        IconButton(
                          padding: const EdgeInsets.all(0),
                          onPressed: () => stationsPageViewController.jumpTo(0),
                          icon: Icon(Icons.first_page, color: ThemeStyle.secondaryIconColor),
                        ),
                        IconButton(
                          onPressed: () => showExpandedList(stations),
                          icon: Icon(Icons.menu, color: ThemeStyle.secondaryIconColor),
                        ),
                      ],
                    ),
                  )
              ),
              SizedBox(
                height: 120,
                child: Row(
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: ListView.builder(
                            controller: stationsPageViewController,
                            // physics: const PageScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: stations.length,
                            itemBuilder: (BuildContext context, int index) =>
                                FavouriteStationCard(index: index, stations: stations)
                        ),
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