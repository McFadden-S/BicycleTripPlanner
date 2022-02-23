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
          Align(
            alignment: FractionalOffset.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: Search(
                      labelTextIn: 'Search',
                      searchController: searchController,
                      searchType: SearchType.end,
                    ),
                  ),
                  GestureDetector(
                    onTap: (){Navigator.pushNamed(context, '/login');},
                    child: Container(
                        width: 55.0,
                        height: 55.0,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage('assets/signup_image.png'),
                            )
                        )),
                  )
                ],
              ),
            ),
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
