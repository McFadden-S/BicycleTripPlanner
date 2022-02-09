import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bicycle_trip_planner/bloc/application_bloc.dart';
import 'package:bicycle_trip_planner/models/place.dart';
import 'package:bicycle_trip_planner/models/steps.dart';
import 'package:provider/provider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;

// Main From Navigation Prototype
// Used for integration

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
        home: const MapScreen(),
      ),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({
    this.initialCount = 0,
  });
  final int initialCount;
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  void initState() {
    super.initState();

    fieldCount = widget.initialCount;
    _setMarker(const LatLng(37.773972, -122.431297));

    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);

    locationSubscription =
        applicationBloc.selectedLocation.stream.listen((place) {
      viewPlace(place);
    });
    directionSubscription =
        applicationBloc.currentDirection.stream.listen((direction) {
      _goToPlace(
          direction.legs.startLocation.lat,
          direction.legs.startLocation.lng,
          direction.bounds.northeast,
          direction.bounds.southwest);
      _setPolyline(direction.polyline.points);

      _setDirection(direction.legs.steps);

      _setDuration(direction.legs.duration);
      _setDistance(direction.legs.distance);
    });
  }

  void _setMarker(LatLng point) {
    _markerIdCounter++;

    _markers.add(Marker(
      markerId: MarkerId('marker_$_markerIdCounter'),
      position: point,
    ));
  }

  void _setPolyline(List<PointLatLng> points) {
    final String polylineIdVal = 'polyline_$_polylineIdCounter';
    _polylineIdCounter++;
    _polylines.clear();

    _polylines.add(Polyline(
      polylineId: PolylineId(polylineIdVal),
      width: 2,
      color: Colors.blue,
      points: points
          .map(
            (point) => LatLng(point.latitude, point.longitude),
          )
          .toList(),
    ));
  }

  void _setDuration(int seconds) {
    int minutes = (seconds / 60).ceil();
    journeyDuration = "$minutes min";
  }

  void _setDistance(int metre) {
    int km = (metre / 1000).ceil();
    journeyDistance = "$km km";
  }

  void _setDirection(List<Steps> steps) {
    _directions = steps;
  }

  void _setRouteCamera(LatLng origin, Map<String, dynamic> boundsSw,
      Map<String, dynamic> boundsNe) {
    routeBoundsNE = boundsNe;
    routeBoundsSW = boundsSw;

    originCamera = origin;
  }

  final Set<Marker> _markers = <Marker>{};
  final Set<Polyline> _polylines = <Polyline>{};
  int _markerIdCounter = 1;
  int _polylineIdCounter = 1;

  bool directionVisibility = false;
  List<Steps> _directions = <Steps>[];

  bool detailsVisibility = false;
  late String journeyDuration;
  late String journeyDistance;

  late LatLng originCamera;
  late Map<String, dynamic> routeBoundsSW;
  late Map<String, dynamic> routeBoundsNE;

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(37.773972, -122.431297),
    zoom: 12.5,
  );

  late GoogleMapController _googleMapController;
  late StreamSubscription locationSubscription;
  late StreamSubscription directionSubscription;
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

  int fieldCount = 0;
  int nextIndex = 0;
  int indexPressed = 0;
  List<TextEditingController> controllers = <TextEditingController>[];

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);

    List<Widget> _buildList() {
      int i;
      // fill in keys if the list is not long enough (in case we added one)
      if (controllers.length < fieldCount) {
        for (i = controllers.length; i < fieldCount; i++) {
          controllers.add(TextEditingController());
        }
      }
      i = 0;
      // cycle through the controllers, and recreate each, one per available controller
      return controllers.map<Widget>((TextEditingController controller) {
        int displayNumber = i + 1;
        i++;
        return TextField(
            controller: controller,
            maxLength: 50,
            decoration: InputDecoration(
              labelText: "Destination $displayNumber",
              counterText: "",
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  setState(() {
                    fieldCount--;
                    controllers.remove(controller);
                  });
                },
              ),
            ),
            onChanged: (value) {
              applicationBloc.searchDestinations(value);
              indexPressed = i - 1;
              print(value);
            });
      }).toList(); // convert to a list
    }

    final List<Widget> children = _buildList();

    children.add(
      GestureDetector(
        onTap: () {
          setState(() {
            if (fieldCount < 3) {
              //max amount of destinations
              fieldCount++;
            }
          });
        },
        child: Container(
          color: Colors.blue,
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'add destination',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );

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
              zoomControlsEnabled: false,
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
                    margin: const EdgeInsets.all(10.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                          controller: originController,
                          decoration: const InputDecoration(
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
                  ListView(
                    padding: const EdgeInsets.all(0),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: children,
                  ),
                ],
              ),
            ),
            if (applicationBloc.searchOriginsResults != null &&
                applicationBloc.searchOriginsResults!.isNotEmpty)
              Container(
                margin: const EdgeInsets.fromLTRB(10.0, 80.0, 10.0, 0.0),
                child: Card(
                  color: Colors.blueGrey,
                  child: ListView.builder(
                    itemCount: applicationBloc.searchOriginsResults!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          applicationBloc
                              .searchOriginsResults![index].description,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          originController.text = applicationBloc
                              .searchOriginsResults![index].description;
                          applicationBloc.setSelectedLocation(applicationBloc
                              .searchOriginsResults![index].placeId);
                          applicationBloc.searchOriginsResults!.clear();
                        },
                      );
                    },
                  ),
                ),
              ),
            if (applicationBloc.searchDestinationsResults != null &&
                applicationBloc.searchDestinationsResults!.isNotEmpty)
              Container(
                margin: const EdgeInsets.fromLTRB(10.0, 165.0, 10.0, 0.0),
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
                          controllers[indexPressed].text = applicationBloc
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
            if (detailsVisibility)
              Container(
                alignment: Alignment.bottomLeft,
                margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 43.0),
                child: Card(
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                          "Duration: $journeyDuration; Distance: $journeyDistance"),
                    )),
              ),
            if (directionVisibility)
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 43.0),
                child: Card(
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ListView.separated(
                        itemCount: _directions.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                              leading: Text("${index + 1}."),
                              trailing:
                                  Text("${_directions[index].distance} m"),
                              title: Html(
                                data: _directions[index].instruction,
                              ));
                        },
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                      ),
                    )),
              ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            bottom: 20,
            right: 30,
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.black,
              onPressed: () async {
                applicationBloc.findRouteDirection(
                    originController.text, destinationController.text);
              },
              child: const Icon(Icons.directions_bike_rounded),
            ),
          ),
          Positioned(
            top: 300,
            right: 30,
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.black,
              onPressed: () => _googleMapController.animateCamera(
                CameraUpdate.newCameraPosition(_initialCameraPosition),
              ),
              child: const Icon(Icons.my_location_rounded),
            ),
          ),
          Positioned(
            top: 370,
            right: 30,
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.black,
              onPressed: () {
                setState(() {
                  detailsVisibility = !detailsVisibility;
                });
                print(detailsVisibility);
              },
              child: const Icon(Icons.timer),
            ),
          ),
          Positioned(
            top: 370,
            right: 30,
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.black,
              onPressed: () {
                setState(() {
                  directionVisibility = !directionVisibility;
                });
              },
              child: const Icon(Icons.directions),
            ),
          ),
          Positioned(
            top: 440,
            right: 30,
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.black,
              onPressed: () => _viewRoute(),
              child: const Icon(Icons.zoom_out_map_sharp),
            ),
          ),
        ],
      ),
    );
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

    _setMarker(LatLng(lat, lng));
  }

  Future<void> _goToPlace(double lat, double lng, Map<String, dynamic> boundsNe,
      Map<String, dynamic> boundsSw) async {
    _setRouteCamera(LatLng(lat, lng), boundsSw, boundsNe);
    _viewRoute();

    _setMarker(LatLng(lat, lng));
  }

  Future<void> _viewRoute() async {
    if (originCamera != null &&
        routeBoundsNE != null &&
        routeBoundsSW != null) {
      _googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(CameraPosition(
          target: originCamera,
          zoom: 14.0,
        )),
      );

      _googleMapController.animateCamera(
        CameraUpdate.newLatLngBounds(
            LatLngBounds(
              southwest: LatLng(routeBoundsSW['lat'], routeBoundsSW['lng']),
              northeast: LatLng(routeBoundsNE['lat'], routeBoundsNE['lng']),
            ),
            25),
      );
    }
  }

  @override
  void didUpdateWidget(MapScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
}
