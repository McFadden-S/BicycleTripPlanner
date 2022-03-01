import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/managers/MarkerManager.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {

  final String labelTextIn;
  final TextEditingController searchController;
  int uid; 

  Search({
    Key? key,
    required this.labelTextIn,
    required this.searchController,
    this.uid = -1
  }): super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  bool isSearching = false;

  RouteManager routeManager = RouteManager();
  MarkerManager markerManager = MarkerManager();

  hideSearch() {
    isSearching = false;
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  String getText(){
    return routeManager.getStop(widget.uid).getStop(); 
  }

  // getText(){
  //   switch (widget.searchType){
  //     case SearchType.start:
  //       return routeManager.getStart();
  //     case SearchType.end:
  //       return routeManager.getDestination();
  //     case SearchType.intermediate:
  //       return routeManager.getIntermediate(searchIndex);
  //   }
  // }

  // @override 
  // void initState(){
  //   super.initState();
  //   if(widget.searchType == SearchType.intermediate){
  //     intermediateManager.intermediateSearches.add(widget);
  //     //TODO:  Put these as a separate method
  //     searchIndex = intermediateManager.intermediateSearches.indexOf(widget);
  //     intermediateManager.setIDToSearch(widget.intermediateIndex, searchIndex);
  //     routeManager.setIntermediate("", widget.intermediateIndex); 
  //   }
  //   print(widget.intermediateIndex); 
  // }


   @override
  Widget build(BuildContext context) {

    final applicationBloc = Provider.of<ApplicationBloc>(context);

    // if(widget.searchType == SearchType.intermediate){
    //   searchIndex = intermediateManager.intermediateSearches.indexOf(widget);
    //   intermediateManager.setIDToSearch(widget.intermediateIndex, searchIndex);
    // }

    if(!isSearching){
        widget.searchController.text = getText();
    }

    return Stack(
      children: [
        if (applicationBloc.ifSearchResult() && isSearching)
          Card(
            color: Colors.white,
            child: Container(
              // padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                shrinkWrap: true,
                itemCount:
                applicationBloc.searchResults.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                    title: Text(
                      applicationBloc
                          .searchResults[index].description,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                      ),
                    ),
                    onTap: () {
                      // TODO: This will create a marker that cannot be removed IF it's the home page one. 
                      // Possible solution: we don't move to routeplanning when search is tapped   
                      // Pass in an argument that holds this search as a placeholder in routemanager so we 
                      // Have access to it and to pass onto destination OR have home search take a unique id/
                      // Make a search type enum of search and route (search enum = has unique id only for marker
                      // No need for any getText for this search) (route enum = behaves as it does currently i.e.
                      // will have a unique id for marker + WILL also getText for this search)~
                      applicationBloc.setLocationMarker(applicationBloc.searchResults[index].placeId, widget.uid); 
                      if(widget.uid != -1){
                        applicationBloc.setSelectedLocation(applicationBloc.searchResults[index].description, widget.uid);
                      }
                      // if(!routeManager.ifPathwayInitialized()){
                      //   if (widget.labelTextIn.contains("Start")){
                      //     routeManager.setStart(applicationBloc.searchResults[index].description); 
                      //   }
                      //   else if(widget.labelTextIn.contains("Destination")){
                      //     routeManager.setDestination(applicationBloc.searchResults[index].description);
                      //     if (!routeManager.ifStartSet()){
                      //       applicationBloc.setSelectedCurrentLocation(SearchType.start); 
                      //     }
                      //   }
                      // }

                      // if(routeManager.ifPathwayInitialized()){
                      //   routeManager.pathway.addStop(widget); 
                      // }

                          // applicationBloc.searchResults[index].placeId,
                          // applicationBloc.searchResults[index].description,
                          // widget.searchType, widget.intermediateIndex);

                      //TODO Potential Side effect
                      //TODO Used in home -> routeplanning
                      //TODO should be changed to appropriate scope
                      //TODO Remove this and instead make a button to change screen 
                      applicationBloc.setSelectedScreen('routePlanning');

                      hideSearch();
                    },
                  );
                },
              ),
            ),
          ),
        Container(
          padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
          child: TextField(
            controller: widget.searchController,
            onChanged: (input) {
              if(input=="") {
                hideSearch();
              } else {
                isSearching = true;
              }
              applicationBloc.searchPlaces(input);
              },
            onTap: (){isSearching = true;},
            decoration: InputDecoration(
              hintText: widget.labelTextIn,
              hintStyle: const TextStyle(color: Color.fromRGBO(38, 36, 36, 0.6)),
              fillColor: Colors.white,
              filled: true,
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                borderSide: BorderSide(width: 0.5, color: Color(0xff969393)),
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                borderSide: BorderSide(width: 0.5, color: Color(0xff969393)),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  setState(() {
                    applicationBloc.clearLocationMarker(widget.uid); 
                    if(widget.uid != -1){
                      applicationBloc.clearSelectedLocation(widget.uid);
                    }
                    //applicationBloc.clearLocationMarker(widget._UID);
                    // widget.searchType, widget.intermediateIndex);
                    //       print(widget.searchController.text);
                    //       print(widget.intermediateIndex);
                  }
                );
                  hideSearch();
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
