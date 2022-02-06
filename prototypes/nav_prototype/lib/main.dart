import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nav_prototype/bloc/application_bloc.dart';
import 'package:nav_prototype/models/place.dart';
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
        title: 'BoJo Nav App',
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

    final applicationBloc =
    Provider.of<ApplicationBloc>(context, listen: false);

    locationSubscription =
        applicationBloc.selectedLocation.stream.listen((place) {
          if (place != null) {
            viewPlace(place);
          }
        });
    directionSubscription =
        applicationBloc.currentDirection.stream.listen((direction) {
          if (direction != null) {
            _goToPlace(direction.legs.startLocation.lat, direction.legs.startLocation.lng, direction.bounds.northeast, direction.bounds.southwest);
            _setPolyline(direction.polyline.points);
          }
        });
  }

  void _setMarker(LatLng point) {
    _markerIdCounter++;

    _markers.add(Marker(
      markerId: MarkerId('marker_$_markerIdCounter'),
      position: point,
      // onTap: () {
      //   _googleMapController.animateCamera(
      //     CameraUpdate.newCameraPosition(CameraPosition(
      //       target: point,
      //       zoom: 14.0,
      //     )),
      //   );
      // }
    ));
  }

  void _setPolyline(List<PointLatLng> points) {
    final String polylineIdVal = 'polyline_$_polylineIdCounter';
    _polylineIdCounter++;

    _polylines.add(
      Polyline(
        polylineId: PolylineId(polylineIdVal),
        width: 2,
        color: Colors.blue,
        points: points
            .map(
              (point) => LatLng(point.latitude, point.longitude),
            )
            .toList(),
      )
    );
  }

  Set<Marker> _markers = Set<Marker>();
  Set<Polyline> _polylines = Set<Polyline>();
  int _markerIdCounter = 1;
  int _polylineIdCounter = 1;

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(37.773972, -122.431297),
    zoom: 12.5,
  );

  // static final _markerA = Marker(
  //     markerId: MarkerId('markerA'), position: LatLng(37.773392, -122.331297));
  // static final _markerB = Marker(
  //   markerId: MarkerId('markerB'),
  //   position: LatLng(37.773932, -122.333297),
  // );

  GoogleMapController _googleMapController;
  StreamSubscription locationSubscription;
  StreamSubscription directionSubscription;
  TextEditingController originController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  @override
  void dispose() {
    _googleMapController.dispose();
    final applicationBloc =
    Provider.of<ApplicationBloc>(context, listen: false);
    applicationBloc.dispose();
    locationSubscription.cancel();
    directionSubscription.cancel();
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
              polylines: _polylines,
              myLocationButtonEnabled: false,
              // zoomGesturesEnabled: false,
              initialCameraPosition: _initialCameraPosition,
              onMapCreated: (controller) => _googleMapController = controller,
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: Colors.blueGrey.withOpacity(0.5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Card(
                    margin: EdgeInsets.all(10.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                          controller: originController,
                          decoration: InputDecoration(
                            hintText: 'Search for start',
                            suffixIcon: Icon(Icons.search),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            applicationBloc.searchOrigins(value);
                            print(value);
                          }),
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.all(10.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                          controller: destinationController,
                          decoration: InputDecoration(
                            hintText: 'Search for destination',
                            suffixIcon: Icon(Icons.search),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            applicationBloc.searchDestinations(value);
                            print(value);
                          }),
                    ),
                  ),
                ],
              ),
            ),
            if (applicationBloc.searchOriginsResults != null &&
                applicationBloc.searchOriginsResults.length != 0)
              Container(
                margin: EdgeInsets.fromLTRB(10.0, 80.0, 10.0, 0.0),
                child: Card(
                  color: Colors.blueGrey,
                  child: ListView.builder(
                    itemCount: applicationBloc.searchOriginsResults.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          applicationBloc
                              .searchOriginsResults[index].description,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          originController.text =
                              applicationBloc.searchOriginsResults[index].description;
                          applicationBloc.setSelectedLocation(
                              applicationBloc.searchOriginsResults[index].placeId);
                          applicationBloc.searchOriginsResults.clear();
                        },
                      );
                    },
                  ),
                ),
              ),
            if (applicationBloc.searchDestinationsResults != null &&
                applicationBloc.searchDestinationsResults.length != 0)
              Container(
                margin: EdgeInsets.fromLTRB(10.0, 165.0, 10.0, 0.0),
                child: Card(
                  color: Colors.blueGrey,
                  child: ListView.builder(
                    itemCount: applicationBloc.searchDestinationsResults.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          applicationBloc
                              .searchDestinationsResults[index].description,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          destinationController.text =
                              applicationBloc.searchDestinationsResults[index].description;
                          applicationBloc.setSelectedLocation(
                              applicationBloc.searchDestinationsResults[index].placeId);
                          applicationBloc.searchDestinationsResults.clear();
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
        onPressed: () async {
          applicationBloc.findRouteDirection(
              originController.text, destinationController.text);
        },
        child: const Icon(Icons.directions_bike_rounded),
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Theme.of(context).primaryColor,
      //   foregroundColor: Colors.black,
      //   onPressed: () => _googleMapController.animateCamera(
      //     CameraUpdate.newCameraPosition(_initialCameraPosition),
      //   ),
      //   child: const Icon(Icons.center_focus_strong),
      // ),
    );
  }

  Future<void> viewPlace(Place place) async {
    final double lat = place.geometry.location.lat;
    final double lng = place.geometry.location.lng;
    _googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(
        target:
        LatLng(lat, lng),
        zoom: 14.0,
      )),
    );

    _setMarker(
        LatLng(lat, lng));
  }

  Future<void> _goToPlace(double lat, double lng, Map<String, dynamic> boundsNe, Map<String, dynamic> boundsSw) async {

    _googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(
        target:
        LatLng(lat, lng),
        zoom: 14.0,
      )),
    );

    _googleMapController.animateCamera(
      CameraUpdate.newLatLngBounds(
          LatLngBounds(
              southwest: LatLng(boundsSw['lat'], boundsSw['lng']),
              northeast: LatLng(boundsNe['lat'], boundsNe['lng']),
          ),
          25),
    );

    _setMarker(
        LatLng(lat, lng));
  }
}
