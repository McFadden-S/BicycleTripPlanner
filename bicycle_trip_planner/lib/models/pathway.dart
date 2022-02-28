import 'package:bicycle_trip_planner/widgets/general/Search.dart';

class Pathway{

  final List<Search> stops = []; 
  int size = 0;
  late Search _start;
  late Search _destination; 

  Pathway({required Search start, required Search destination}){
    _start = start;
    _destination = destination;
    addStop(start); 
    addStop(destination); 
    size = 2; 
  }

  Search getStart() { return _start;}

  Search getDestination() { return stops.last;}

  List<Search> getWaypoints(){
    print(size); 
    return stops.sublist(1, size - 1); 
  }

  Search getStop(int index){
    return stops[index]; 
  }

  void _updatePointers(){
    _updateStart();
    _updateDestination(); 
  }

  void _updateStart(){
    _start = stops.first; 
  }

  void _updateDestination(){
    _destination = stops.last; 
  }

  void addStop(Search search){
    stops.add(search); 
    size = size + 1;   
    print(size);
    _updateDestination(); 
  }

  void removeStop(Search search){
    if(size > 2){
      stops.remove(search); 
      size = size - 1; 
      _updatePointers();
    }
  }

  void moveStop(int currentStopIndex, int newStopIndex){
    Search search = stops[currentStopIndex];
    if(currentStopIndex < newStopIndex){
      stops.insert(newStopIndex, search);
      stops.removeAt(currentStopIndex); 
    }
    else if(currentStopIndex > newStopIndex){
      stops.removeAt(currentStopIndex);
      stops.insert(newStopIndex, search);
    }
    _updatePointers();
  }

  void swapStops(int stop1Index, int stop2Index){
    Search temp = stops[stop1Index];
    stops[stop1Index] = stops[stop2Index];
    stops[stop2Index] = temp; 
    _updatePointers(); 
  }


}