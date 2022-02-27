import 'package:bicycle_trip_planner/managers/DirectionManager.dart';
import 'package:bicycle_trip_planner/managers/MarkerManager.dart';
import 'package:bicycle_trip_planner/managers/PolylineManager.dart';
import 'package:bicycle_trip_planner/models/search_types.dart';

class RouteManager{

  //********** Fields **********

  final DirectionManager _directionManager = DirectionManager();
  final MarkerManager _markerManager = MarkerManager();
  final PolylineManager _polylineManager = PolylineManager();


  String _start = "";
  String _destination = "";

  final List<String> _intermediates = <String>[];

  bool _changed = false;

  //********** Singleton **********

  static final RouteManager _routeManager = RouteManager._internal();

  factory RouteManager() {return _routeManager;}

  RouteManager._internal();

  //********** Private **********

  //********** Public **********

  String getStart(){return _start;}

  String getDestination(){return _destination;}

  List<String> getIntermediates(){return _intermediates;}

  String getIntermediate(int index){
    if(_intermediates.length > index && _intermediates.isNotEmpty){
      return _intermediates[index];
    }
    return "";
  }

  bool ifChanged(){return _changed;}

  bool ifStartSet(){return _start != "";}

  bool ifDestinationSet(){return _destination != "";}

  bool ifIntermediatesSet(){return _intermediates.isNotEmpty;} 

  void setStart(String start){
    _start = start;
    _changed = true;
  }

  void clearStart(){
    setStart("");
    _markerManager.clearMarker(SearchType.start);
  }

  void setDestination(String destination){
    _destination = destination;
    _changed = true;
  }

  void clearDestination(){
    setDestination("");
    _markerManager.clearMarker(SearchType.end);
  }

  void setIntermediate(String intermediate, int index){
    print("Set Intermediate index: ${index.toString()}"); 
    if(_intermediates.length > index && _intermediates.isNotEmpty){
      _intermediates[index] = intermediate;
    } else{
      _intermediates.add(intermediate);
    }
    _changed = true;
  }

  void removeIntermediate(int index){
    print("Remove Intermediate index: ${index.toString()}"); 
    if(_intermediates.length > index && _intermediates.isNotEmpty){
      _intermediates.removeAt(index);
      _markerManager.clearMarker(SearchType.intermediate, index);
    }else{print("Wasn't removed");}
    _changed = true;
  }

  void clearIntermediates(){
    for(int i = _intermediates.length-1; i >= 0; i--){
      removeIntermediate(i);
    }
  }

  void clearChanged(){
    _changed = false;
  }

  void endRoute() {
    _directionManager.clear();
    _polylineManager.clearPolyline();

    clearIntermediates();
    clearStart();
    clearDestination();
  }

}