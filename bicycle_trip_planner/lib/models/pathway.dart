import 'package:bicycle_trip_planner/models/stop.dart';

class Pathway {
  Stop _start = Stop();
  Stop _destination = Stop();
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

  Stop getStart() => _start;

  Stop getDestination() => _destination;

  Stop getStop(int id) => (id == -1)
      ? Stop()
      : _stops.firstWhere((stop) => stop.getUID() == id, orElse: () => Stop());

  Stop getStopByIndex(int index){
    return _stops[index];
  }

  List<Stop> getWaypoints() => _stops.sublist(1, size - 1);

  List<Stop> getStops() => _stops;

  //********** Private: Update Pointers **********

  void _updatePointers() {
    _updateStart();
    _updateDestination();
  }

  void _updateStart() => _start = _stops.first;

  void _updateDestination() => _destination = _stops.last;

  //********** Public **********

  void addStop(Stop stop) {
    _stops.add(stop);
    size = size + 1;
    _updateDestination();
  }

  void removeStop(int id) {
    Stop stop = getStop(id);
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

  void swapStops(int stop1ID, int stop2ID) {
    Stop stop1 = getStop(stop1ID);
    Stop stop2 = getStop(stop2ID);
    int stop1Index = _stops.indexOf(stop1);
    int stop2Index = _stops.indexOf(stop2);
    _stops[stop1Index] = _stops[stop2Index];
    _stops[stop2Index] = stop1;
    _updatePointers();
  }

  void changeStart(String start) {
    Stop startStop = getStart();
    startStop.setStop(start);
  }

  void changeDestination(String destination) {
    Stop destinationStop = getDestination();
    destinationStop.setStop(destination);
  }

  void changeStop(int id, String newStop) {
    Stop stop = getStop(id);
    stop.setStop(newStop);
  }
}
