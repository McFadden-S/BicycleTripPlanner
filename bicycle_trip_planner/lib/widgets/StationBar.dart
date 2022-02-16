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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0))),
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
            decoration: const BoxDecoration(
                color: Colors.white,
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
                              children: const [
                                Text("Nearby Stations", style: TextStyle(fontSize: 25.0)),
                                Spacer(),
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
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
          boxShadow: [ BoxShadow(color: Colors.grey, spreadRadius: 8, blurRadius: 6, offset: Offset(0, 0),)]
      ),
      child: SizedBox(
          height: 180.0,
          child: Column(
            children: [
              Expanded(
                  child: Row(
                    children: [
                      const Text("Nearby Stations", style: TextStyle(fontSize: 25.0)),
                      const Spacer(),
                      IconButton(
                        onPressed: () => showExpandedList(applicationBloc.stations),
                        icon: const Icon(Icons.menu),
                      ),
                    ],
                  )
              ),
              SizedBox(
                height: 110,
                child: Row(
                  children: [

                    Flexible(
                        child: ListView.builder(
                            controller: stationsPageViewController,
                            physics: const PageScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: applicationBloc.stations.length,
                            itemBuilder: (BuildContext context, int index) =>
                                StationCard(index: index)
                        ),
                    ),
                    SizedBox(
                      width: 30.0,
                      child: IconButton(
                        padding: const EdgeInsets.all(0),
                        onPressed: () => stationsPageViewController.jumpTo(0),
                        icon: const Icon(Icons.first_page),
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