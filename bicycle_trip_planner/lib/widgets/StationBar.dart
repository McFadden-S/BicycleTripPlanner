import 'package:bicycle_trip_planner/models/station.dart';
import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'StationCard.dart';

class StationBar extends StatefulWidget {
  const StationBar({ Key? key }) : super(key: key);

  @override
  _StationBarState createState() => _StationBarState();
}

class _StationBarState extends State<StationBar> {

  PageController stationsPageViewController = PageController();

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
                            child: SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  for(int i = 0; i < stations.length; i++) StationCard(index: i)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ))),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {

    final applicationBloc = Provider.of<ApplicationBloc>(context);

    return BottomAppBar(
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
      );
  }
}