import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/managers/MarkerManager.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';
import 'package:bicycle_trip_planner/models/search_types.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {

  final String labelTextIn;
  final TextEditingController searchController;

  final SearchType searchType;
  final int intermediateIndex;

  const Search({
    Key? key,
    required this.labelTextIn,
    required this.searchController,
    required this.searchType,
    this.intermediateIndex = 0,
  }) : super(key: key);

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

  getText(){
    switch (widget.searchType){
      case SearchType.start:
        return routeManager.getStart();
      case SearchType.end:
        return routeManager.getDestination();
      case SearchType.intermediate:
        return routeManager.getIntermediate(widget.intermediateIndex);
    }
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
                      applicationBloc.setSelectedLocation(
                          applicationBloc.searchResults[index].placeId,
                          applicationBloc.searchResults[index].description,
                          widget.searchType, widget.intermediateIndex);

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
                    applicationBloc.clearSelectedLocation(widget.searchType, widget.intermediateIndex);
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
