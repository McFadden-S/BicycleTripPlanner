import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/models/stop.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_trip_planner/widgets/general/Search.dart';
import 'package:provider/provider.dart';

class IntermediateSearchList extends StatefulWidget {

  const IntermediateSearchList({
    Key? key,
  }) : super(key: key);

  @override
  _IntermediateSearchListState createState() => _IntermediateSearchListState();
}

class _IntermediateSearchListState extends State<IntermediateSearchList> {

  List<TextEditingController> intermediateSearchControllers = <TextEditingController>[];

  RouteManager routeManager = RouteManager();

  List<Widget> stopsList = [];

  bool isShowingIntermediate = false;

  void _addStopWidget(ApplicationBloc applicationBloc) {

    setState(() {
      TextEditingController searchController = TextEditingController();
      intermediateSearchControllers.add(searchController);
      Stop waypoint = routeManager.addWaypoint(""); 

      stopsList.add(
          ListTile(
            title:
              Search(
                  labelTextIn: "Stop",
                  searchController: searchController,
                  uid: waypoint.getUID()
              ),
              trailing: IconButton(
                key: Key("Remove ${intermediateSearchControllers.length}"),
                  onPressed: (){
                    setState(() {
                      int indexPressed = intermediateSearchControllers.indexOf(searchController); 
                      applicationBloc.clearLocationMarker(waypoint.getUID());
                      applicationBloc.clearSelectedLocation(waypoint.getUID());
                      stopsList.removeAt(indexPressed);
                      intermediateSearchControllers.removeAt(indexPressed);
                    });
                  },
                  icon: const Icon(
                      Icons.remove_circle_outline))
          )
      );

      isShowingIntermediate = true;
    });
  }

  void toggleShowingIntermediate(){
    setState(()=> {isShowingIntermediate = !isShowingIntermediate});
  }

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context, listen: false);
    return InkWell(
        splashColor: Colors.deepPurple.withAlpha(30),
        onTap: toggleShowingIntermediate,
        child: Column(
            children: [
              TextButton(
                child: const Text(
                  'Add Stop(s)',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
                onPressed: () => {_addStopWidget(applicationBloc)},
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(12, 156, 238, 1.0)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side: const BorderSide(color: Color.fromRGBO(12, 156, 238, 1.0))
                    ),
                  ),
                ),
              ),
              if(isShowingIntermediate)
                LimitedBox(
                  maxHeight: MediaQuery.of(context).size.height * 0.2,
                  child: ListView(
                    shrinkWrap: true,
                    children: stopsList.toList(growable: true),
                  ),
                ),
              const Icon(Icons.expand_more),
            ]
        )
    );
  }
}
