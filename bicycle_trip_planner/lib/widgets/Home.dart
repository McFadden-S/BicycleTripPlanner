import 'dart:async';

import 'package:bicycle_trip_planner/models/station.dart';
import 'package:bicycle_trip_planner/widgets/Search.dart';
import 'package:bicycle_trip_planner/widgets/StationCard.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/widgets/Map.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  //********** Controllers **********

  PageController stationsPageViewController = PageController();

  //********** Station **********

  void showExpandedList(List<Station> stations) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              SizedBox(
                  height: (56 * 6).toDouble(),
                  child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Color(0xff345955),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "Select a station",
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 5),
                          Expanded(
                            child: ListView.builder(
                                itemCount: stations.length,
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                    StationCard(index: index)),
                          ),
                        ],
                      ))),
            ],
          );
        });
  }

  //********** Widget **********

  @override
  Widget build(BuildContext context) {

    final applicationBloc = Provider.of<ApplicationBloc>(context);

    return Scaffold(
      body: SafeArea(
          child: Stack(
            children: [
              MapWidget(),
              Search(),
            ],
          )
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: const Color(0xff345955),
        child: SizedBox(
            height: 56.0,
            child: Row(
              children: [
                IconButton(
                  onPressed: () => showExpandedList(applicationBloc.stations),
                  icon: const Icon(Icons.menu),
                  color: Colors.white,
                ),
                Flexible(
                  child: PageView.builder(
                      controller: stationsPageViewController,
                      physics: const PageScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: applicationBloc.stations.length,
                      itemBuilder: (BuildContext context, int index) =>
                          StationCard(index: index)),
                ),
                SizedBox(
                  width: 30.0,
                  child: IconButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () => stationsPageViewController.jumpTo(0),
                    icon: const Icon(Icons.first_page),
                    color: Colors.white,
                  ),
                ),
              ],
            )),
      ),
    );
  }

}
