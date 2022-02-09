import 'dart:async';

import 'package:bicycle_trip_planner/widgets/Search.dart';
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

  List<String> stations = [
    "station 1",
    "station 2",
    "station 3",
    "station 4",
    "station 5",
    "station 1",
    "station 2",
    "station 3",
    "station 4",
    "station 5",
    "station 1",
    "station 2",
    "station 3",
    "station 4",
    "station 5"
  ];

  void showExpandedList() {
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
                                    stationCard(context, index)),
                          ),
                        ],
                      ))),
            ],
          );
        });
  }

  Widget stationCard(BuildContext context, int index) {
    return InkWell(
      onTap: () => stationClicked(index),
      child: SizedBox(
          height: 60,
          child: Card(
              child: Row(
                children: [
                  const Spacer(),
                  const Text(
                    "1.1 mi",
                    style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Container(
                    width: 2,
                    color: Colors.black54,
                  ),
                  const Spacer(),
                  const Text("River Street , Clerkenwell",
                      style: TextStyle(fontSize: 20.0)),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                    child: Row(
                      children: [
                        Column(
                          children: const [
                            Text(
                              "5",
                              style: TextStyle(fontSize: 15.0),
                            ),
                            Icon(
                              Icons.directions_bike,
                              size: 20.0,
                            ),
                          ],
                        ),
                        const SizedBox(width: 5.0),
                        Column(
                          children: const [
                            Text(
                              "8",
                              style: TextStyle(fontSize: 15.0),
                            ),
                            Icon(
                              Icons.chair_alt,
                              size: 20.0,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                ],
              ))),
    );
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
                  onPressed: () => showExpandedList(),
                  icon: const Icon(Icons.menu),
                  color: Colors.white,
                ),
                Flexible(
                  child: PageView.builder(
                      controller: stationsPageViewController,
                      physics: const PageScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: stations.length,
                      itemBuilder: (BuildContext context, int index) =>
                          stationCard(context, index)),
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

  void stationClicked(int index) {
    print("Station of index $index was tapped");
  }

}
