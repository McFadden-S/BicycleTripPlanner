import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  final String labelTextIn;
  final TextEditingController searchController;

  const Search({
    Key? key,
    required this.labelTextIn,
    required this.searchController
  }) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  bool isSearching = false;

  @override
  Widget build(BuildContext context) {

    final applicationBloc = Provider.of<ApplicationBloc>(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
      child: Stack(
        children: [
          if (applicationBloc.ifSearchResult() && isSearching)
            Card(
              color: Colors.white,
              child: Container(
                padding: const EdgeInsets.fromLTRB(0.0, 60.0, 0.0, 10.0),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount:
                  applicationBloc.searchResults.length,
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                  itemBuilder: (context, index) {
                    return ListTile(
                        visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                      title: Text(
                        applicationBloc
                            .searchResults[index].description,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 15),
                      ),
                      onTap: () {
                        widget.searchController.text = applicationBloc
                            .searchResults[index].description;
                        applicationBloc.setSelectedLocation(applicationBloc
                            .searchResults[index].placeId);
                        isSearching = false;
                        },
                        dense : true
                    );
                  },
                ),
              ),
            ),
          Card(
            child: TextField(
              controller: widget.searchController,
              onChanged: (input) => {applicationBloc.searchPlaces(input)},
              onTap: (){isSearching = true;},
              decoration: InputDecoration(
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
                hintText: widget.labelTextIn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
