import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/models/search_types.dart';
import 'package:flutter/material.dart';

import 'package:bicycle_trip_planner/widgets/general/Search.dart';
import 'package:bicycle_trip_planner/widgets/general/MapWidget.dart';
import 'package:bicycle_trip_planner/widgets/home/StationBar.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  @override
  Widget build(BuildContext context) {

    final TextEditingController searchController = TextEditingController();

    return Scaffold(
      body: SafeArea(
          child: Stack(
            children: [
              MapWidget(),
              Search(
                  labelTextIn: 'Search',
                  searchController: searchController,
                  searchType: SearchType.end,
              ),
            ],
          )
      ),
      bottomNavigationBar: StationBar(),
    );
  }
}
