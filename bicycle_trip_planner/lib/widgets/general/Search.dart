import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/constants.dart';
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

   @override
  Widget build(BuildContext context) {

    final applicationBloc = Provider.of<ApplicationBloc>(context);

    if(!isSearching){
        widget.searchController.text = getText();
    }

    return Stack(
      children: [
        if (applicationBloc.ifSearchResult() && isSearching)
          Card(
            color: ThemeStyle.cardColor,
            child: Container(
              padding: const EdgeInsets.only(top: 60),
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
                    trailing: Visibility(child: Icon(Icons.my_location), visible: (index == 0)),
                    title: Text(
                      applicationBloc
                          .searchResults[index].description,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: ThemeStyle.secondaryTextColor),
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

                      //TODO Potential Side effect
                      //TODO Used in home -> routeplanning
                      //TODO should be changed to appropriate scope
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
            style: TextStyle(color: ThemeStyle.secondaryTextColor),
            controller: widget.searchController,
            onChanged: (input) {
              isSearching = true;
              applicationBloc.searchPlaces(input);
              },
            onTap: (){
              isSearching = true;
              applicationBloc.getDefaultSearchResult();
              },
            decoration: InputDecoration(
              hintText: widget.labelTextIn,
              hintStyle: TextStyle(color: ThemeStyle.secondaryTextColor),
              fillColor: ThemeStyle.cardColor,
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                borderSide: BorderSide(width: 0.5, color: ThemeStyle.cardOutlineColor),
              ),
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                borderSide: BorderSide(width: 0.5, color: ThemeStyle.cardOutlineColor),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  setState(() {
                    applicationBloc.clearLocationMarker(widget.uid); 
                    if(widget.uid != -1){
                      applicationBloc.clearSelectedLocation(widget.uid);
                    }
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
