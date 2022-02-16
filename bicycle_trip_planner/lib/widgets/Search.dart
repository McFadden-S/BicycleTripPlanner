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

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 28.0,
            ),
            controller: widget.searchController,
            onChanged: (input) => {applicationBloc.searchPlaces(input)},
            onTap: (){isSearching = true;},
            decoration: InputDecoration(
              hintText: widget.labelTextIn,
              hintStyle: TextStyle(color: Color.fromRGBO(38, 36, 36, 0.6)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(color: Color.fromRGBO(12, 156, 238, 1.0), width: 1.0),
              ),
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(),
              labelText: widget.labelTextIn,
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  setState(() {
                    widget.searchController.clear();
                  });
                },
              ),
            ),
          ),
        ),
        if (applicationBloc.ifSearchResult() && isSearching)
          Container(
            margin: const EdgeInsets.fromLTRB(10.0, 65.0, 10.0, 0.0),
            child: Card(
              color: Colors.grey[850],
              child: ListView.builder(
                shrinkWrap: true,
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
                      widget.searchController.text = applicationBloc
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
