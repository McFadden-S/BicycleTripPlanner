import 'package:bicycle_trip_planner/models/place.dart';
import 'package:bicycle_trip_planner/models/stop.dart';

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

  /**
   * @return Stop the start Stop
   */
  Stop getStart() => _start;

  /**
   * @return Stop the destination Stop
   */
  Stop getDestination() => _destination;

  /**
   * @return Stop of specified id
   */
  Stop getStop(int id) {
    if (id == -1) {
      return Stop();
    }
    return _stops.firstWhere((stop) => stop.getUID() == id,
        orElse: () => Stop());
  }

  /**
   * @return List<Stop> of the waypoints in the list
   */
  List<Stop> getWaypoints() =>
      _stops.isEmpty ? [] : _stops.sublist(1, size - 1);

  /**
   * @return Stop first waypoint
   */
  Stop getFirstWaypoint() => _firstWaypoint;

  /**
   * @return Stop of the specified index
   */
  Stop getStopByIndex(int index) {
    return _stops[index];
  }

  /**
   * @return List<Stop> of all the stops
   */
  List<Stop> getStops() => _stops;

  //********** Private: Update Pointers **********

  /**
   * method updates both the start and destination pointer
   */
  void _updatePointers() {
    _updateStart();
    _updateDestination();
  }

  /**
   * method sets the start pointer to the first stop
   */
  void _updateStart() => _start = _stops.first;

  /**
   * method sets the end pointer to the last stop
   */
  void _updateDestination() => _destination = _stops.last;

  //********** Public **********

  /**
   * method sets if has first way points based on parameter
   * @param bool true or false
   */
  void setHasFirstWaypoint(bool value) {
    _hasFirstWaypoint = value;
  }

  /**
   * method alters the _hasFirstWaypoint field to the opposite of what it is
   */
  void toggleHasFirstWaypoint() {
    _hasFirstWaypoint = !_hasFirstWaypoint;
  }

  /**
   * method adds the specified stop to the list and updates the destination
   * @param Stop requested add stop
   */
  void addStop(Stop stop) {
    _stops.add(stop);
    size = size + 1;
    _updateDestination();
  }

  /**
   * method adds a start stop specified and updates the start
   * @param Stop start stop
   */
  void addStart(Stop stop) {
    _stops.insert(0, stop);
    size = size + 1;
    _updateStart();
  }

  /**
   * method adds first waypoint into the list of stops
   * @param Stop first waypoint
   */
  void addFirstWayPoint(Stop stop) {
    _firstWaypoint = stop;
    _stops.insert(1, stop);
    size = size + 1;
  }

  /**
   * method removes first waypoint from the list of stops
   */
  void removeFirstWayPoint() {
    _firstWaypoint = Stop();
    _stops.removeAt(1);
    size = size - 1;
  }

  /**
   * method clears the start by setting _start to a empty Stop
   */
  void clearStart() {
    _start = Stop();
  }

  /**
   * method clears the first waypoint by setting _start to a empty Stop
   */
  void clearFirstWaypoint() {
    _hasFirstWaypoint = false;
    _firstWaypoint = Stop();
  }

  /**
   * method clears destination waypoint by setting _start to a empty Stop
   */
  void clearDestination() {
    _destination = Stop();
  }

  /**
   * method removes stop from the list based on id specified
   * @param int id
   */
  void removeStop(int id) {
    Stop stop = getStop(id);
    if (stop == _firstWaypoint) {
      clearFirstWaypoint();
    }
    _stops.remove(stop);
    size = size - 1;
    _updatePointers();
  }

  /**
   * method moves stop of specified id to a specified index in the list
   * @param int id, int new index
   */
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

  /**
   * method swaps two stops positions of specified id's
   * @param int first stop, int second stop
   */
  void swapStops(int stop1ID, int stop2ID) {
    Stop stop1 = getStop(stop1ID);
    Stop stop2 = getStop(stop2ID);
    int stop1Index = _stops.indexOf(stop1);
    int stop2Index = _stops.indexOf(stop2);
    _stops[stop1Index] = _stops[stop2Index];
    _stops[stop2Index] = stop1;
    _updatePointers();
  }

  /**
   * method changes the start place
   * @param Place start place
   */
  void changeStart(Place start) {
    Stop startStop = getStart();
    startStop.setStop(start);
    _updateStart();
  }

  /**
   * method changes the destination place
   * @param Place destination
   */
  void changeDestination(Place destination) {
    Stop destinationStop = getDestination();
    destinationStop.setStop(destination);
  }

  /**
   * method changes the Stop based on id specified
   * @param int id, Place new stop
   */
  void changeStop(int id, Place newStop) {
    Stop stop = getStop(id);
    stop.setStop(newStop);
  }

  /**
   * method override the toString method
   * @return String of the toString of the object
   */
  @override
  String toString() {
    return _stops.toString();
  }
}
