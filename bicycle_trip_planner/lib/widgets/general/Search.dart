import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/models/search_types.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {

  final String labelTextIn;
  final TextEditingController searchController;

  final SearchType searchType;
  final intermediateIndex;

  const Search({
    Key? key,
    required this.labelTextIn,
    required this.searchController,
    required this.searchType,
    this.intermediateIndex = 0
  }) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  bool isSearching = false;

  hideSearch() {
    isSearching = false;
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  String getSearchName(){
    if(widget.intermediateIndex == 0){
      return widget.searchType.toString() + widget.intermediateIndex;
    }
    return widget.searchType.toString();
  }

   @override
  Widget build(BuildContext context) {

    final applicationBloc = Provider.of<ApplicationBloc>(context);

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Stack(
        children: [
          if (applicationBloc.ifSearchResult() && isSearching)
            Card(
              color: Colors.white,
              child: Container(
                padding: const EdgeInsets.fromLTRB(0.0, 60.0, 0.0, 10.0),
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
                        widget.searchController.text = applicationBloc
                            .searchResults[index].description;
                        applicationBloc.setSelectedLocation(applicationBloc
                            .searchResults[index].placeId);
                        hideSearch();
                      },
                    );
                  },
                ),
              ),
            ),
          Container(
            padding: EdgeInsets.fromLTRB(4, 4, 4, 0),
            child: TextField(
              controller: widget.searchController,
              onChanged: (input) {
                if(input=="")
                  hideSearch();

                else
                  isSearching = true;
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
                      widget.searchController.clear();
                    }
                    );
                    hideSearch();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
