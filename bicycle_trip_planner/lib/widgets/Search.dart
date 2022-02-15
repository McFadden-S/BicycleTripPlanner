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

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Stack(
        children: [
          if (applicationBloc.ifSearchResult() && isSearching)
            Card(
              color: Colors.white,
              child: Container(
                padding: const EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
                child: ListView.builder(
                  itemCount:
                  applicationBloc.searchResults.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            applicationBloc
                                .searchResults[index].description,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(),
                          ),
                          const Divider()
                        ],
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
          Card(
            child: TextField(
              controller: searchController,
              onChanged: (input) => {applicationBloc.searchPlaces(input)},
              onTap: (){isSearching = true;},
              decoration: const InputDecoration(
                fillColor: Colors.white,
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  borderSide: BorderSide(width: 0.5, color: Color(0xff969393)),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    borderSide: BorderSide(width: 0.5, color: Color(0xff969393)),
                ),
                hintText: 'Search your destination here',
              ),
            ),
          ),
          //if (applicationBloc.ifSearchResult() && isSearching)

        ],
      ),
    );
  }
}
