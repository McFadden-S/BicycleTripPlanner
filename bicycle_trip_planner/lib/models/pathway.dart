import 'package:bicycle_trip_planner/models/place.dart';
import 'package:bicycle_trip_planner/models/stop.dart';
import 'package:flutter/cupertino.dart';

class Pathway {
  Stop _start = Stop();
  Stop _destination = Stop();
  bool _hasFirstWaypoint = false;
  Stop _firstWaypoint = Stop();
  final List<Stop> _stops = [];
  int size = 0;

  // NOTE: TODO ADD EDGE CASE (Pathway MUST have 2 stops at least)
  Pathway() {
    _stops.add(_start);
    _stops.add(_destination);
    size = 2;
    _updatePointers();
  }

  //********** Getters **********

  //Gets start stop
  Stop getStart() => _start;

  //Gets destination stop
  Stop getDestination() => _destination;

  //Gets the first Stop of a specific id
  Stop getStop(int id) {
    if (id == -1) {
      return Stop();
    }
    return _stops.firstWhere((stop) => stop.getUID() == id,
        orElse: () => Stop());
  }

  //Get all waypoints
  List<Stop> getWaypoints() {
    List<Stop> ret = size <= 2 ? [] : _stops.sublist(1, size - 1);
    return ret;
  }

  //Gets the first waypoint in the pathway
  Stop getFirstWaypoint() => _firstWaypoint;

  //Gets stop based of index
  Stop getStopByIndex(int index) {
    return _stops[index];
  }

  //Gets all stops
  List<Stop> getStops() => _stops;

  //********** Private: Update Pointers **********

  void _updatePointers() {
    _updateStart();
    _updateDestination();
  }

  void _updateStart() => _start = _stops.first;

  void _updateDestination() => _destination = _stops.last;

  //********** Public **********

  //Sets first waypoint to given value
  void setHasFirstWaypoint(bool value) {
    _hasFirstWaypoint = value;
  }

  //Toggles first waypoint value
  void toggleHasFirstWaypoint() {
    _hasFirstWaypoint = !_hasFirstWaypoint;
  }

  //Adds stop to pathway
  void addStop(Stop stop) {
    _stops.add(stop);
    size = size + 1;
    _updateDestination();
  }

  //Add waypoint to second last position in pathway
  void addWaypoint(Stop stop) {
    _stops.add(stop);
    swapStops(stop.getUID(), _destination.getUID());
  }

  //Add start to first position in pathway
  void addStart(Stop stop) {
    _stops.insert(0, stop);
    size = size + 1;
    _updateStart();
  }

  //Add first waypoint onto pathway
  void addFirstWayPoint(Stop stop) {
    _firstWaypoint = stop;
    _stops.insert(1, stop);
    size = size + 1;
  }

  //Removes first waypoint
  void removeFirstWayPoint() {
    _firstWaypoint = Stop();
    if (_hasFirstWaypoint) {
      _stops.removeAt(1);
      size = size - 1;
    }
  }

  //Clears start to default value
  void clearStart() {
    _start = Stop();
  }

  //Clears first waypoint to default value
  void clearFirstWaypoint() {
    _hasFirstWaypoint = false;
    _firstWaypoint = Stop();
  }

  //Clears the destination and sets is to default value
  void clearDestination() {
    Stop destinationStop = getDestination();
    _destination = Stop();
    destinationStop.setStop(_destination.getStop());
    _updateDestination();
  }

  //Removes stop by given id
  void removeStop(int id) {
    Stop stop = getStop(id);
    if (stop == _firstWaypoint) {
      clearFirstWaypoint();
    }
    _stops.remove(stop);
    size = size - 1;
    _updatePointers();
  }

  void moveStop(int id, int newIndex) {
    Stop stop = getStop(id);
    int currentIndex = _stops.indexOf(stop);
    if (currentIndex < newIndex) {
      _stops.insert(newIndex, stop);
      _stops.removeAt(currentIndex);
    } else if (newIndex > currentIndex) {
      _stops.removeAt(currentIndex);
      _stops.insert(newIndex, stop);
    }
    _updatePointers();
  }

  //Swaps the position of 2 stops and updates the pointers
  void swapStops(int stop1ID, int stop2ID) {
    Stop stop1 = getStop(stop1ID);
    Stop stop2 = getStop(stop2ID);
    int stop1Index = _stops.indexOf(stop1);
    int stop2Index = _stops.indexOf(stop2);
    _stops[stop1Index] = _stops[stop2Index];
    _stops[stop2Index] = stop1;
    _updatePointers();
  }

  //Changes start stop to given start
  void changeStart(Place start) {
    Stop startStop = getStart();
    startStop.setStop(start);
    _updateStart();
  }

  //Changes destination stop to given destination
  void changeDestination(Place destination) {
    Stop destinationStop = getDestination();
    destinationStop.setStop(destination);
  }

  //Sets a new stop based off of id
  void changeStop(int id, Place newStop) {
    Stop stop = getStop(id);
    stop.setStop(newStop);
    _updatePointers();
  }

  //Returns the stops as a string
  @override
  String toString() {
    return _stops.toString();
  }

  @visibleForTesting
  bool getHasFirstWaypoint(){
   return _hasFirstWaypoint;
  }
}
