import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  final TextEditingController searchController = TextEditingController();
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {

    final applicationBloc = Provider.of<ApplicationBloc>(context);

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            controller: searchController,
            onChanged: (input) => {applicationBloc.searchPlaces(input)},
            onTap: (){isSearching = true;},
            decoration: const InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(),
              labelText: 'Search',
            ),
          ),
        ),
        if (applicationBloc.ifSearchResult() && isSearching)
          Container(
            margin: const EdgeInsets.fromLTRB(10.0, 70.0, 10.0, 0.0),
            child: Card(
              color: Colors.blueGrey,
              child: ListView.builder(
                itemCount:
                applicationBloc.searchResults.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      applicationBloc
                          .searchResults[index].description,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      searchController.text = applicationBloc
                          .searchResults[index].description;
                      applicationBloc.setSelectedLocation(applicationBloc
                          .searchResults[index].placeId);
                      isSearching = false;
                    },
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}
