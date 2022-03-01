import 'package:bicycle_trip_planner/models/stop.dart';

class Pathway{

  //final List<Search> stops = []; 
  Stop _start = Stop(); 
  Stop _destination = Stop(); 
  final List<Stop> _stops = [];
  int size = 0;
  //late Search _start;
  //late Search _destination; 

  // Pathway({required Search start, required Search destination}){
  //   _start = start;
  //   _destination = destination;
  //   addStop(start); 
  //   addStop(destination); 
  //   size = 2; 
  // }

  // NOTE: TODO ADD EDGE CASE (Pathway MUST have 2 stops at least)
  Pathway(){ 
    _stops.add(_start); 
    _stops.add(_destination);
    size = 2;  
    _updatePointers(); 
  }

  //Search getStart() { return _start;}
  Stop getStart() => _start;

  //Search getDestination() { return stops.last;}
  Stop getDestination() => _destination;

  // List<Search> getWaypoints(){
  //   print(size); 
  //   return stops.sublist(1, size - 1); 
  // }
  Stop getStop(int id){
    if(id == -1){return Stop();} 
    return _stops.firstWhere((stop) => stop.getUID() == id, orElse: () => Stop()); 
  }

  List<Stop> getWaypoints() => _stops.sublist(1, size - 1);

  // Search getStop(int index){
  //   return stops[index]; 
  // }

  void _updatePointers(){
    _updateStart();
    _updateDestination(); 
  }

  void _updateStart(){
    _start = _stops.first; 
  }

  void _updateDestination(){
    _destination = _stops.last; 
  }

  void addStop(Stop stop){
    print(stop.getUID()); 
    _stops.add(stop); 
    size = size + 1; 
    _updateDestination(); 
  }

  void removeStop(int id){
    Stop stop = getStop(id); 
    _stops.remove(stop);
    size = size - 1; 
    _updatePointers(); 
  }

  void moveStop(int id, int newIndex){
    Stop stop = getStop(id); 
    int currentIndex = _stops.indexOf(stop); 
    if(currentIndex < newIndex){
       _stops.insert(newIndex, stop);
       _stops.removeAt(currentIndex); 
    }
     else if(newIndex > currentIndex){
      _stops.removeAt(currentIndex);
      _stops.insert(newIndex, stop);
    }
    _updatePointers();
  }

  void swapStops(int stop1ID, int stop2ID){
    Stop stop1 = getStop(stop1ID);
    Stop stop2 = getStop(stop2ID);
    int stop1Index = _stops.indexOf(stop1); 
    int stop2Index = _stops.indexOf(stop2);
    _stops[stop1Index] = _stops[stop2Index];
    _stops[stop2Index] = stop1; 
    _updatePointers();  
  }

  void changeStart(String start){
    Stop startStop = getStart(); 
    startStop.setStop(start);
  }

  void changeDestination(String destination){
    Stop destinationStop = getDestination(); 
    destinationStop.setStop(destination); 
  }

  void changeStop(int id, String newStop){
    Stop stop = getStop(id);
    stop.setStop(newStop);
  }

  // void addStop(Search search){
  //   stops.add(search); 
  //   size = size + 1;   
  //   print(size);
  //   _updateDestination(); 
  // }

  // void removeStop(Search search){
  //   if(size > 2){
  //     stops.remove(search); 
  //     size = size - 1; 
  //     _updatePointers();
  //   }
  // }

  // void moveStop(int currentStopIndex, int newStopIndex){
  //   Search search = stops[currentStopIndex];
  //   if(currentStopIndex < newStopIndex){
  //     stops.insert(newStopIndex, search);
  //     stops.removeAt(currentStopIndex); 
  //   }
  //   else if(currentStopIndex > newStopIndex){
  //     stops.removeAt(currentStopIndex);
  //     stops.insert(newStopIndex, search);
  //   }
  //   _updatePointers();
  // }

  // void swapStops(int stop1Index, int stop2Index){
  //   Search temp = stops[stop1Index];
  //   stops[stop1Index] = stops[stop2Index];
  //   stops[stop2Index] = temp; 
  //   _updatePointers(); 
  // }


}