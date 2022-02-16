import 'package:flutter/material.dart';
import 'Search.dart';

class IntermediateSearchList extends StatefulWidget {

  const IntermediateSearchList({Key? key}) : super(key: key);

  @override
  _IntermediateSearchListState createState() => _IntermediateSearchListState();
}

class _IntermediateSearchListState extends State<IntermediateSearchList> {

  List<Widget> stopsList = [];
  List<TextEditingController> stopsControllers = [];

  bool isShowingIntermediate = false;

  void addStopWidget() {
    setState(() {
      final TextEditingController searchController = TextEditingController();

      stopsControllers.add(searchController);
      stopsList.add(
          Search(
              labelTextIn: "Stop ${stopsControllers.length}",
              searchController: searchController));

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
                child: const Text("Add Stop(s)"),
                onPressed: () => {addStopWidget()},
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
