import 'package:bicycle_trip_planner/managers/MarkerManager.dart';
import 'package:bicycle_trip_planner/managers/PolylineManager.dart';
import 'package:bicycle_trip_planner/models/pathway.dart';
import 'package:bicycle_trip_planner/models/stop.dart';

class RouteManager {
  //********** Fields **********

  final PolylineManager _polylineManager = PolylineManager();
  final MarkerManager _markerManager = MarkerManager();
  final Pathway _pathway = Pathway();

  int _groupsize = 1;

  bool _changed = false;
  bool _optimised = true;

  //********** Singleton **********

  static final RouteManager _routeManager = RouteManager._internal();

  factory RouteManager() => _routeManager;

  RouteManager._internal();

  //********** Private **********

  //********** Public **********

  int getGroupSize() {
    return _groupsize;
  }

  void setGroupSize(int size) {
    if (size > 0) {
      _groupsize = size;
      _changed = true;
    }
  }

  void toggleOptimised() {
    _optimised = !_optimised;
    _changed = true;
  }

  bool ifOptimised() {
    return _optimised;
  }

  //String getStart(){return pathway.getStart().getText();}
  Stop getStart() => _pathway.getStart();

  //String getDestination() => pathway.getDestination().getText();
  Stop getDestination() => _pathway.getDestination();

  List<Stop> getWaypoints() => _pathway.getWaypoints();

  Stop getStop(int id) => _pathway.getStop(id);

<<<<<<< Updated upstream
  bool ifChanged() => _changed;
=======
  Stop getStopByIndex(int index) => _pathway.getStopByIndex(index);

  bool ifChanged(){return _changed;}
>>>>>>> Stashed changes

  bool ifStartSet() => _pathway.getStart().getStop() != "";

  bool ifDestinationSet() => _pathway.getDestination().getStop() != "";

  bool ifWaypointsSet() => getWaypoints().isNotEmpty;

  void changeStart(String start) {
    _pathway.changeStart(start);
    _changed = true;
  }

  void changeDestination(String destination) {
    _pathway.changeDestination(destination);
    _changed = true;
  }

  void changeWaypoint(int id, String waypoint) {
    _pathway.changeStop(id, waypoint);
    _changed = true;
  }

  void changeStop(int id, String stop) {
    _pathway.changeStop(id, stop);
    _changed = true;
  }

  void swapStops(int stop1ID, int stop2ID) {
    _pathway.swapStops(stop1ID, stop2ID);
    _changed = true;
  }

  // Overrides the old destination
  void addDestination(String destination) {
    Stop destinationStop = Stop(destination);
    _pathway.addStop(destinationStop);
    _changed = true;
  }

  // Overrides the new stop
  void addStart(String start) {
    Stop startStop = Stop(start);
    _pathway.addStop(startStop);
    _pathway.moveStop(startStop.getUID(), 0);
    _changed = true;
  }

  // Adds a new waypoint at the end (before destination)
  Stop addWaypoint(String waypoint) {
    Stop destination = getDestination();
    Stop waypointStop = Stop(waypoint);
    _pathway.addStop(waypointStop);
    _pathway.swapStops(destination.getUID(), waypointStop.getUID());
    //Adding a new waypoint with empty string implies no change
    if (waypoint != "") {
      _changed = true;
    }
    return waypointStop;
  }

  void clearStart() {
    _pathway.changeStart("");
    _changed = true;
  }

  void clearDestination() {
    _pathway.changeDestination("");
    _changed = true;
  }

  // Clears a waypoint (doesn't remove)
  void clearStop(int id) {
    _pathway.changeStop(id, "");
    _changed = true;
  }

  void removeStop(int id) {
    _pathway.removeStop(id);
    _changed = true;
  }

  void removeWaypoints() {
    List<int> uids =
        _pathway.getWaypoints().map((waypoint) => waypoint.getUID()).toList();
    for (int id in uids) {
      removeStop(id);
    }
  }

  void clearRouteMarkers() {
    List<int> uids = _pathway.getStops().map((stop) => stop.getUID()).toList();
    for (int id in uids) {
      _markerManager.clearMarker(id);
    }
  }

  void clearChanged() => _changed = false;

  void clear() {
    _polylineManager.clearPolyline();
    clearRouteMarkers();

    removeWaypoints();
    clearStart();
    clearDestination();
  }
}
