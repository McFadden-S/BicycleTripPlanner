import 'package:bicycle_trip_planner/models/search_types.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_trip_planner/widgets/general/Search.dart';
import 'package:bicycle_trip_planner/widgets/home/StationBar.dart';

class HomeWidgets extends StatefulWidget {
  const HomeWidgets({Key? key}) : super(key: key);

  @override
  _HomeWidgetsState createState() => _HomeWidgetsState();
}

class _HomeWidgetsState extends State<HomeWidgets> {

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    return SafeArea(
      bottom: false,
      child: Stack(
        children: [
          Search(
            labelTextIn: 'Search',
            searchController: searchController,
            searchType: SearchType.end,
          ),

          const Align(
              alignment: FractionalOffset.bottomCenter,
              child: StationBar()
          ),
        ],
      ),
    );
  }
}
