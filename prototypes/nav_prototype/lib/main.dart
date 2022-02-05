import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nav_prototype_test/bloc/application_bloc.dart';
import 'package:nav_prototype_test/models/place.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ApplicationBloc(),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,

        theme: ThemeData(
          primaryColor: Colors.white,
        ),
        home: MapScreen(),
      ),
    );
  }
}

class MapScreen extends StatefulWidget {

  @override
  _MapScreenState createState() => _MapScreenState();
}


class _MapScreenState extends State<MapScreen> {

  @override
  void initState() {
    super.initState();

    _setMarker(LatLng(37.773972, -122.431297));

    final applicationBloc = Provider.of<ApplicationBloc>(context, listen: false);

    locationSubscription = applicationBloc.selectedLocation.stream.listen((place) {
      if (place != null) {
        _goToPlace(place);
      }
    });

  }

  void _setMarker(LatLng point) {
    setState(() {
      _markers.add(
          Marker(
            markerId: MarkerId('marker_$_markerIdCounter'),
            position: point,
          )
      );
    });
  }

  void _setPolygon() {
    final String polygonIdVal = 'polygon_$_polygonIdCounter';
    _polygonIdCounter++;

    _polygons.add(
        Polygon(
          polygonId: PolygonId(polygonIdVal),
          points: polygonLatLngs,
          strokeWidth: 2,
          fillColor: Colors.transparent,
        )
    );
  }

  Set<Marker> _markers = Set<Marker>();
  Set<Polygon> _polygons = Set<Polygon>();
  List<LatLng> polygonLatLngs = <LatLng>[];

  int _markerIdCounter = 1;
  int _polygonIdCounter = 1;


  static const _initialCameraPosition = CameraPosition(
    target: LatLng(37.773972, -122.431297),
    zoom: 12.5,
  );

  static final _markerA = Marker(
      markerId: MarkerId('markerA'),
      position: LatLng(37.773392, -122.331297)
  );
  static final _markerB = Marker(
      markerId: MarkerId('markerB'),
      position: LatLng(37.773932, -122.331297),
  );

  GoogleMapController _googleMapController;
  StreamSubscription locationSubscription;
  TextEditingController searchController = TextEditingController();
  @override
  void dispose() {
    _googleMapController.dispose();
    final applicationBloc = Provider.of<ApplicationBloc>(context, listen: false);
    applicationBloc.dispose();
    locationSubscription.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              markers: _markers,
              polygons: _polygons,
              myLocationButtonEnabled: false,
              zoomGesturesEnabled: false,
              initialCameraPosition: _initialCameraPosition,
              onMapCreated: (controller) => _googleMapController = controller,
              onTap: (point) {
                setState(() {
                  polygonLatLngs.add(point);
                  _setPolygon();
                });
              },
            ),
            Card(
              margin: EdgeInsets.all(10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search location',
                    suffixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) => applicationBloc.searchPlaces(value),
                ),
              ),
            ),
            if (applicationBloc.searchResults != null
                && applicationBloc.searchResults.length != 0)
              Container(
                margin: EdgeInsets.fromLTRB(10.0, 75.0, 10.0, 0.0),
                child: Card(
                  color: Colors.blueGrey,
                  child: ListView.builder(
                    itemCount: applicationBloc.searchResults.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          applicationBloc.searchResults[index].description,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          searchController.text = applicationBloc.searchResults[index].description;
                          applicationBloc.setSelectedLocation(
                              applicationBloc.searchResults[index].placeId
                          );
                          applicationBloc.searchResults.clear();
                        },
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        onPressed: () => _googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(_initialCameraPosition),
        ),
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }
  Future<void> _goToPlace(Place place) async {
    final double lat = place.geometry.locaiton.lat;
    final double lng = place.geometry.locaiton.lng;

    _googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(lat, lng),
            zoom: 14.0,
          )
      ),
    );

    _setMarker(LatLng(lat, lng));
  }
}
