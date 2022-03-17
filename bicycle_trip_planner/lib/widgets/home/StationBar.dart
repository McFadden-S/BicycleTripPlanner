import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/managers/StationManager.dart';
import 'package:bicycle_trip_planner/models/station.dart';
import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bicycle_trip_planner/widgets/home/StationCard.dart';

class StationBar extends StatefulWidget {
  const StationBar({ Key? key }) : super(key: key);

  @override
  _StationBarState createState() => _StationBarState();
}

class _StationBarState extends State<StationBar> {

  PageController stationsPageViewController = PageController();

  StationManager stationManager = StationManager();

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
                                Text("Nearby Stations", style: TextStyle(fontSize: 25.0, color: ThemeStyle.secondaryTextColor)),
                                const Spacer(),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: ListView.builder(
                                  itemCount: stations.length,
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                      StationCard(index: index)),
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

    final applicationBloc = Provider.of<ApplicationBloc>(context);

    return Container(
      padding: const EdgeInsets.only(bottom: 20.0),
      decoration: BoxDecoration(
          color: ThemeStyle.cardColor,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
          boxShadow: [ BoxShadow(color: ThemeStyle.stationShadow, spreadRadius: 8, blurRadius: 6, offset: Offset(0, 0),)]
      ),
      child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
          child: Column(
            children: [
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      children: [
                        Text("Nearby Stations", style: TextStyle(fontSize: 25.0, color: ThemeStyle.secondaryTextColor),),
                        const Spacer(),
                        IconButton(
                          padding: const EdgeInsets.all(0),
                          onPressed: () => stationsPageViewController.jumpTo(0),
                          icon: Icon(Icons.first_page, color: ThemeStyle.secondaryIconColor),
                        ),
                        IconButton(
                          onPressed: () => showExpandedList(stationManager.getStations()),
                          icon: Icon(Icons.menu, color: ThemeStyle.secondaryIconColor),
                        ),
                      ],
                    ),
                  )
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.13,
                child: Row(
                  children: [
                    Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: ListView.builder(
                              controller: stationsPageViewController,
                              // physics: const PageScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: stationManager.getNumberOfStations(),
                              itemBuilder: (BuildContext context, int index) =>
                                  StationCard(index: index)
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