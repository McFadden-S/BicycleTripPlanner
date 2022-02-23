import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/models/search_types.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_trip_planner/widgets/general/Search.dart';

class IntermediateSearchList extends StatefulWidget {

  final List<TextEditingController> intermediateSearchControllers;

  const IntermediateSearchList({
    Key? key,
    required this.intermediateSearchControllers
  }) : super(key: key);

  @override
  _IntermediateSearchListState createState() => _IntermediateSearchListState();
}

class _IntermediateSearchListState extends State<IntermediateSearchList> {

  RouteManager routeManager = RouteManager();

  List<Widget> stopsList = [];

  bool isShowingIntermediate = false;

  void _addStopWidget() {
    setState(() {
      final TextEditingController searchController = TextEditingController();

      widget.intermediateSearchControllers.add(searchController);
      stopsList.add(
          ListTile(
            title:
              Search(
                  labelTextIn: "Stop ${widget.intermediateSearchControllers.length}",
                  searchController: searchController,
                  searchType: SearchType.intermediate,
                  intermediateID: stopsList.length + 1,
              ),
              trailing: IconButton(
                key: Key("Remove ${widget.intermediateSearchControllers.length}"),
                  onPressed: (){
                    setState(() {
                      int indexPressed = widget.intermediateSearchControllers.indexOf(searchController);

                      for(int i = indexPressed; i < widget.intermediateSearchControllers.length - 1; i++){
                        widget.intermediateSearchControllers[i].text = widget.intermediateSearchControllers[i+1].text;
                      }

                      routeManager.removeIntermediate(indexPressed+1);
                      stopsList.removeLast();
                      widget.intermediateSearchControllers.removeLast();
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
                onPressed: () => {_addStopWidget()},
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
