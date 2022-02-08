import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/models/place.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PageController stationsPageViewController = PageController();
  List<String> stations = [
    "station 1",
    "station 2",
    "station 3",
    "station 4",
    "station 5",
    "station 1",
    "station 2",
    "station 3",
    "station 4",
    "station 5",
    "station 1",
    "station 2",
    "station 3",
    "station 4",
    "station 5"
  ];

  late GoogleMapController _googleMapController;
  late StreamSubscription locationSubscription;
  TextEditingController searchController = TextEditingController();

  final Set<Marker> _markers = <Marker>{};
  final String _finalDestinationMarkerID = "Final Destination";

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(37.773972, -122.431297),
    zoom: 12.5,
  );

  void _setMarker(LatLng point, String markerIdName) {
    _markers.add(Marker(
      markerId: MarkerId(markerIdName),
      position: point,
    ));
  }

  Future<void> viewPlace(Place place) async {
    final double lat = place.geometry.location.lat;
    final double lng = place.geometry.location.lng;
    _googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(lat, lng),
        zoom: 14.0,
      )),
    );

    _setMarker(LatLng(lat, lng), _finalDestinationMarkerID);
  }

  @override
  void initState() {
    super.initState();

    final applicationBloc =
    Provider.of<ApplicationBloc>(context, listen: false);

    locationSubscription =
        applicationBloc.selectedLocation.stream.listen((place) {
          viewPlace(place);
        });
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    final applicationBloc =
    Provider.of<ApplicationBloc>(context, listen: false);
    applicationBloc.dispose();
    locationSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final applicationBloc =  Provider.of<ApplicationBloc>(context);

    return Scaffold(
      body: SafeArea(
          child: Stack(
            children: [
              GoogleMap(
                mapType: MapType.normal,
                markers: _markers,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                initialCameraPosition: _initialCameraPosition,
                onMapCreated: (controller) => _googleMapController = controller,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: searchController,
                  onChanged: (input) => {applicationBloc.searchDestinations(input)},
                  decoration: const InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(),
                    labelText: 'Search',
                  ),
                ),
              ),
              if (applicationBloc.searchDestinationsResults != null &&
                  applicationBloc.searchDestinationsResults!.isNotEmpty)
                Container(
                  margin: const EdgeInsets.fromLTRB(10.0, 70.0, 10.0, 0.0),
                  child: Card(
                    color: Colors.blueGrey,
                    child: ListView.builder(
                      itemCount:
                      applicationBloc.searchDestinationsResults!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            applicationBloc
                                .searchDestinationsResults![index].description,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onTap: () {
                            searchController.text = applicationBloc
                                .searchDestinationsResults![index].description;
                            applicationBloc.setSelectedLocation(applicationBloc
                                .searchDestinationsResults![index].placeId);
                            applicationBloc.searchDestinationsResults!.clear();
                          },
                        );
                      },
                    ),
                  ),
                ),
            ],
          )
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: const Color(0xff345955),
        child: SizedBox(
            height: 56.0,
            child: Row(
              children: [
                IconButton(
                  onPressed: () => showExpandedList(),
                  icon: const Icon(Icons.menu),
                  color: Colors.white,
                ),
                Flexible(
                  child: PageView.builder(
                      controller: stationsPageViewController,
                      physics: const PageScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: stations.length,
                      itemBuilder: (BuildContext context, int index) =>
                          stationCard(context, index)),
                ),
                SizedBox(
                  width: 30.0,
                  child: IconButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () => stationsPageViewController.jumpTo(0),
                    icon: const Icon(Icons.first_page),
                    color: Colors.white,
                  ),
                ),
              ],
            )),
      ),
    );
  }

  void search(String input) {
    print('This method is triggered when search box is changed');
  }

  void stationClicked(int index) {
    print("Station of index $index was tapped");
  }

  void showExpandedList() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              SizedBox(
                  height: (56 * 6).toDouble(),
                  child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Color(0xff345955),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "Select a station",
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 5),
                          Expanded(
                            child: ListView.builder(
                                itemCount: stations.length,
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                        stationCard(context, index)),
                          ),
                        ],
                      ))),
            ],
          );
        });
  }

  Widget stationCard(BuildContext context, int index) {
    return InkWell(
      onTap: () => stationClicked(index),
      child: SizedBox(
          height: 60,
          child: Card(
              child: Row(
            children: [
              const Spacer(),
              const Text(
                "1.1 mi",
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Container(
                width: 2,
                color: Colors.black54,
              ),
              const Spacer(),
              const Text("River Street , Clerkenwell",
                  style: TextStyle(fontSize: 20.0)),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                child: Row(
                  children: [
                    Column(
                      children: const [
                        Text(
                          "5",
                          style: TextStyle(fontSize: 15.0),
                        ),
                        Icon(
                          Icons.directions_bike,
                          size: 20.0,
                        ),
                      ],
                    ),
                    const SizedBox(width: 5.0),
                    Column(
                      children: const [
                        Text(
                          "8",
                          style: TextStyle(fontSize: 15.0),
                        ),
                        Icon(
                          Icons.chair_alt,
                          size: 20.0,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ))),
    );
  }


}
