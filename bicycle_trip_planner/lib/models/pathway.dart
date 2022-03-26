import 'package:bicycle_trip_planner/models/place.dart';
import 'package:bicycle_trip_planner/models/stop.dart';
import 'package:flutter/cupertino.dart';

/// Class Comment:
/// Pathway is a model which stores the stops taken in a route

class Pathway {
  /// Start and End Stops
  Stop _start = Stop();
  Stop _destination = Stop();

  /// A check to see if Pathway includes the first waypoint
  bool _hasFirstWaypoint = false;
  Stop _firstWaypoint = Stop();

  /// A list of all stops in this pathway
  final List<Stop> _stops = [];
  int size = 0;

  /// Initialize pathway such that you always have a start and a end stop
  Pathway() {
    _stops.add(_start);
    _stops.add(_destination);
    size = 2;
    _updatePointers();
  }

  //********** Getters **********

  /// @param void
  /// @return Stop - Gets start stop
  Stop getStart() => _start;

  /// @param void
  /// @return - Gets destination stop
  Stop getDestination() => _destination;

  /// @param -
  ///   id - int; specific id of a stop
  /// @return Stop - Gets the first Stop of a specific id
  Stop getStop(int id) {
    if (id == -1) {
      return Stop();
    }
    return _stops.firstWhere((stop) => stop.getUID() == id,
        orElse: () => Stop());
  }

  /// @param void
  /// @return List<Stop>
  ///   - Returns all waypoints in pathway
  List<Stop> getWaypoints() {
    List<Stop> ret = size <= 2 ? [] : _stops.sublist(1, size - 1);
    return ret;
  }

  /// @param void
  /// @return Stop - Gets first waypoint in pathway
  Stop getFirstWaypoint() => _firstWaypoint;

  /// @param
  ///   int - index; index to get stop
  /// @return Stop - Gets stop based of index
  Stop getStopByIndex(int index) {
    return _stops[index];
  }

  /// @param void
  /// @return List<Stop> - Gets all stops
  List<Stop> getStops() => _stops;

  //********** Private: Update Pointers **********

  /// @param void
  /// @return void
  /// @effects - updates start and destination stops
  void _updatePointers() {
    _updateStart();
    _updateDestination();
  }

  /// @param void
  /// @return void
  /// @effects - Updates start to first stop in list
  void _updateStart() => _start = _stops.first;

  /// @param void
  /// @return void
  /// @effects - Updates destination to last stop in list
  void _updateDestination() => _destination = _stops.last;

  //********** Public **********

  /// @param -
  ///   value - int; choice of what firstWaypoint value should be
  /// @effects - Sets first waypoint to given value
  void setHasFirstWaypoint(bool value) {
    _hasFirstWaypoint = value;
  }

  /// @param void
  /// @return void
  /// @effects - Toggles first waypoint value
  void toggleHasFirstWaypoint() {
    _hasFirstWaypoint = !_hasFirstWaypoint;
  }

  /// @param -
  ///   stop - Stop; stop to be added
  /// @return void
  /// @effects adds stop to stops list
  void addStop(Stop stop) {
    _stops.add(stop);
    size = size + 1;
    _updateDestination();
  }

  /// @param -
  ///   stop - Stop; stop to be added
  /// @return void
  /// @effects adds waypoint to stops list
  void addWaypoint(Stop stop) {
    _stops.add(stop);
    swapStops(stop.getUID(), _destination.getUID());
  }

  /// @param -
  ///   stop - Stop; stop to be added
  /// @return void
  /// @effects adds stop to stops list at the first position
  void addStart(Stop stop) {
    _stops.insert(0, stop);
    size = size + 1;
    _updateStart();
  }

  /// @param -
  ///   stop - Stop; stop to be added
  /// @return void
  /// @effects adds stop to stops list at the second position
  void addFirstWayPoint(Stop stop) {
    _firstWaypoint = stop;
    _stops.insert(1, stop);
    size = size + 1;
  }

  /// @param void
  /// @return void
  /// @effects makes firstWaypoint = default Stop
  ///          If _hasFirstWaypoint then the original firstWaypoint is removed from stops
  void removeFirstWayPoint() {
    _firstWaypoint = Stop();
    if (_hasFirstWaypoint) {
      _stops.removeAt(1);
      size = size - 1;
    }
  }

  /// @param void
  /// @return void
  /// @effects - Clears start to default value
  void clearStart() {
    _start = Stop();
  }

  /// @param void
  /// @return void
  /// @effects - Clears first waypoint to default value
  void clearFirstWaypoint() {
    _hasFirstWaypoint = false;
    _firstWaypoint = Stop();
  }

  /// @param void
  /// @return void
  /// @effects - Clears the destination and sets is to default value
  void clearDestination() {
    Stop destinationStop = getDestination();
    _destination = Stop();
    destinationStop.setStop(_destination.getStop());
    _updateDestination();
  }

  /// @param -
  ///   id - int; id to get specific stop
  /// @return void
  /// @effects - Removes stop by given id
  void removeStop(int id) {
    Stop stop = getStop(id);
    if (stop == _firstWaypoint) {
      clearFirstWaypoint();
    }
    _stops.remove(stop);
    size = size - 1;
    _updatePointers();
  }

  /// @param -
  ///   id - int; id of stop
  ///   newIndex - int; index to move stop to
  /// @return void
  /// @effects - Moves stop to specified index
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

  /// @param -
  ///   int - stop1ID; id of first stop
  ///   int - stop2ID; id of second stop
  /// @return void
  /// @effects - Swaps the position of 2 stops and updates the pointers
  void swapStops(int stop1ID, int stop2ID) {
    Stop stop1 = getStop(stop1ID);
    Stop stop2 = getStop(stop2ID);
    int stop1Index = _stops.indexOf(stop1);
    int stop2Index = _stops.indexOf(stop2);
    _stops[stop1Index] = _stops[stop2Index];
    _stops[stop2Index] = stop1;
    _updatePointers();
  }

  /// @param -
  ///   start - Place; new Place for start to be set to
  /// @return void
  /// @effects - Changes start stop to given start
  void changeStart(Place start) {
    Stop startStop = getStart();
    startStop.setStop(start);
    _updateStart();
  }

  /// @param -
  ///   destination - Place;new Place for destination to be set to
  /// @return void
  /// @effects - Changes destination stop to given destination
  void changeDestination(Place destination) {
    Stop destinationStop = getDestination();
    destinationStop.setStop(destination);
  }

  /// @param -
  ///   id; int - id of stop
  ///   newStop; Place - new Place for stop
  /// @return void
  /// @effects - Sets a new stop based off of id
  void changeStop(int id, Place newStop) {
    Stop stop = getStop(id);
    stop.setStop(newStop);
    _updatePointers();
  }

  /// @param void
  /// @return String - when pathway.toString is called, the stops are returned as a string
  //Returns the stops as a string
  @override
  String toString() {
    return _stops.toString();
  }

  /// @param void
  /// @return bool - get _hasFirstWaypoint
  @visibleForTesting
  bool getHasFirstWaypoint(){
   return _hasFirstWaypoint;
  }

  /// @param void
  /// @clear void
  /// @effects - resets values to original values
  @visibleForTesting
  void clear(){
    clearFirstWaypoint();
    clearDestination();
    clearStart();
    _hasFirstWaypoint = false;
    _stops.clear();
    size = 0;

    _stops.add(_start);
    _stops.add(_destination);

    size = 2;
    _updatePointers();
  }
}
