import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nav_prototype/bloc/application_bloc.dart';
import 'package:nav_prototype/models/place.dart';
import 'package:nav_prototype/models/steps.dart';
import 'package:provider/provider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;

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
            _goToPlace(direction.legs.startLocation.lat,
                direction.legs.startLocation.lng, direction.bounds.northeast,
                direction.bounds.southwest);
            _setPolyline(direction.polyline.points);

            _setDirection(direction.legs.steps);

            _setDuration(direction.legs.duration);
            _setDistance(direction.legs.distance);
          }
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

  Set<Marker> _markers = Set<Marker>();
  Set<Polyline> _polylines = Set<Polyline>();
  int _markerIdCounter = 1;
  int _polylineIdCounter = 1;

  bool directionVisibility = false;
  List<Steps> _directions = <Steps>[];

  bool detailsVisibility = false;
  String journeyDuration;
  String journeyDistance;

  LatLng originCamera;
  Map<String, dynamic> routeBoundsSW;
  Map<String, dynamic> routeBoundsNE;

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

  int fieldCount = 0;
  int nextIndex = 0;
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
            maxLength: 20,
            decoration: InputDecoration(
              labelText: "Destination $displayNumber",
              counterText: "",
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
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
              print(value);
            }
        );
      }).toList(); // convert to a list
    }

    final List<Widget> children = _buildList();

    children.add(
      GestureDetector(
        onTap: () {
          setState(() {
            if(fieldCount < 3){ //max amount of destinations
              fieldCount++;
            }
          });
        },
        child: Container(
          color: Colors.blue,
          child: Padding(
            padding: const EdgeInsets.all(16),
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
                  ListView(
                    padding: EdgeInsets.all(0),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: children,
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
                              applicationBloc.searchOriginsResults[index]
                                  .description;
                          applicationBloc.setSelectedLocation(
                              applicationBloc.searchOriginsResults[index]
                                  .placeId);
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
                          /*TODO: Change this from destination Controller to the correct controller
                             from controllers line 173 to update text*/
                          destinationController.text =
                              applicationBloc.searchDestinationsResults[index]
                                  .description;
                          applicationBloc.setSelectedLocation(
                              applicationBloc.searchDestinationsResults[index]
                                  .placeId);
                          applicationBloc.searchDestinationsResults.clear();
                        },
                      );
                    },
                  ),
                ),
              ),
            if (detailsVisibility)
              Container(
                alignment: Alignment.bottomLeft,
                margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 43.0),
                child: Card(
                    color: Theme
                        .of(context)
                        .primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                          "Duration: $journeyDuration; Distance: $journeyDistance"),
                    )
                ),
              ),
            if (directionVisibility)
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 43.0),
                child: Card(
                    color: Theme
                        .of(context)
                        .primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ListView.separated(
                        itemCount: _directions.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                              leading: Text("${index + 1}."),
                              trailing: Text(
                                  "${_directions[index].distance} m"
                              ),
                              title: Html(
                                data: _directions[index].instruction,
                              )
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider();
                        },
                      ),
                    )
                ),
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
              backgroundColor: Theme
                  .of(context)
                  .primaryColor,
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
              backgroundColor: Theme
                  .of(context)
                  .primaryColor,
              foregroundColor: Colors.black,
              onPressed: () =>
                  _googleMapController.animateCamera(
                    CameraUpdate.newCameraPosition(_initialCameraPosition),
                  ),
              child: const Icon(Icons.my_location_rounded),
            ),
          ),
          Positioned(
            top: 370,
            right: 30,
            child: FloatingActionButton(
              backgroundColor: Theme
                  .of(context)
                  .primaryColor,
              foregroundColor: Colors.black,
              onPressed: () {
                setState(() {
                  detailsVisibility = !detailsVisibility;
                });
                print(detailsVisibility);
              },
              child: const
              Icon(Icons.timer),
            ),
          ),
          Positioned(
            top: 370,
            right: 30,
            child: FloatingActionButton(
              backgroundColor: Theme
                  .of(context)
                  .primaryColor,
              foregroundColor: Colors.black,
              onPressed: () {
                setState(() {
                  directionVisibility = !directionVisibility;
                });
              },
              child: const
              Icon(Icons.directions),
            ),
          ),
          Positioned(
            top: 440,
            right: 30,
            child: FloatingActionButton(
              backgroundColor: Theme
                  .of(context)
                  .primaryColor,
              foregroundColor: Colors.black,
              onPressed: () => _viewRoute(),
              child: const
              Icon(Icons.zoom_out_map_sharp),
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
        target:
        LatLng(lat, lng),
        zoom: 14.0,
      )),
    );

    _setMarker(
        LatLng(lat, lng));
  }

  Future<void> _goToPlace(double lat, double lng, Map<String, dynamic> boundsNe,
      Map<String, dynamic> boundsSw) async {
    _setRouteCamera(LatLng(lat, lng), boundsSw, boundsNe);
    _viewRoute();

    _setMarker(
        LatLng(lat, lng));
  }

  Future<void> _viewRoute() async {
    if(originCamera != null && routeBoundsNE != null && routeBoundsSW != null){
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