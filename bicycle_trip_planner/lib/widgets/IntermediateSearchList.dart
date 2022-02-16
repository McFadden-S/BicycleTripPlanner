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
          ListTile(
            title:
              Search(
                  labelTextIn: "Stop ${stopsControllers.length}",
                  searchController: searchController),
              trailing: IconButton(
                  onPressed: (){
                    setState(() {
                      int indexPressed = stopsControllers.indexOf(searchController);

                      for(int i = indexPressed; i < stopsControllers.length - 1; i++){
                        stopsControllers[i].text = stopsControllers[i+1].text;
                      }

                      stopsList.removeLast();
                      stopsControllers.removeLast();
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
                onPressed: () => {addStopWidget()},
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(12, 156, 238, 1.0)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side: BorderSide(color: Color.fromRGBO(12, 156, 238, 1.0))
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
