import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/models/search_types.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_trip_planner/widgets/general/Search.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

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
      final TextEditingController searchController = TextEditingController();

      intermediateSearchControllers.add(searchController);
      stopsList.add(
          ListTile(
            title:
              Search(
                  labelTextIn: "Stop ${intermediateSearchControllers.length}",
                  searchController: searchController,
                  searchType: SearchType.intermediate,
                  intermediateIndex: stopsList.length,
              ),
              trailing: IconButton(
                key: Key("Remove ${intermediateSearchControllers.length}"),
                  onPressed: (){
                    setState(() {
                      int indexPressed = intermediateSearchControllers.indexOf(searchController);

                      for(int i = indexPressed; i < intermediateSearchControllers.length - 1; i++){
                        intermediateSearchControllers[i].text = intermediateSearchControllers[i+1].text;
                      }

                      applicationBloc.clearSelectedLocation(SearchType.intermediate, indexPressed);
                      routeManager.removeIntermediate(indexPressed+1);
                      stopsList.removeLast();
                      intermediateSearchControllers.removeLast();
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
                child: Text(
                  'Add Stop(s)',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 16.0,
                    color: ThemeStyle.primaryTextColor,
                  ),
                ),
                onPressed: () => {_addStopWidget(applicationBloc)},
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(ThemeStyle.buttonPrimaryColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side: BorderSide(color: ThemeStyle.buttonPrimaryColor)
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
