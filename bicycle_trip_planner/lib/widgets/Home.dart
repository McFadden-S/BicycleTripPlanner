import 'dart:async';

import 'package:bicycle_trip_planner/models/station.dart';
import 'package:bicycle_trip_planner/widgets/Search.dart';
import 'package:bicycle_trip_planner/widgets/StationCard.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/widgets/Map.dart';
import 'package:provider/provider.dart';

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
