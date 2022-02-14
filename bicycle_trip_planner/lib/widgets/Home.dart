import 'package:bicycle_trip_planner/widgets/Search.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_trip_planner/widgets/Map.dart';


import 'StationBar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
          child: Stack(
            children: [
              MapWidget(),
              Search(labelTextIn: 'Search',),
            ],
          )
      ),
      bottomNavigationBar: StationBar(),
    );
  }
}
