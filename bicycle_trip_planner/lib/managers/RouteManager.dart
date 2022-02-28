import 'package:bicycle_trip_planner/managers/DirectionManager.dart';
import 'package:bicycle_trip_planner/managers/IntermediateManager.dart';
import 'package:bicycle_trip_planner/managers/MarkerManager.dart';
import 'package:bicycle_trip_planner/managers/PolylineManager.dart';
import 'package:bicycle_trip_planner/models/pathway.dart';
import 'package:bicycle_trip_planner/models/search_types.dart';
import 'package:bicycle_trip_planner/widgets/general/Search.dart';

class RouteManager{

  //********** Fields **********

  final DirectionManager _directionManager = DirectionManager();
  final MarkerManager _markerManager = MarkerManager();
  final PolylineManager _polylineManager = PolylineManager();
  final IntermediateManager _intermediateManager = IntermediateManager();


  String _start = "";
  String _destination = "";

  static int _currentUID = 0; 
  final List<String> _intermediates = <String>[];
  late Pathway pathway; 

  bool _pathwayInitialised = false; 
  bool _changed = false;

  //********** Singleton **********

  static final RouteManager _routeManager = RouteManager._internal();

  factory RouteManager() {return _routeManager;}

  RouteManager._internal();

  //********** Private **********

  //********** Public **********

  String getStart(){return pathway.getStart().getText();}

  String getDestination() => pathway.getDestination().getText();

  List<String> getWaypoints() {
    return pathway
      .getWaypoints()
      .map((waypoint) => waypoint.getText()).toList();
  }

  String getStop(int index) => pathway.getStop(index).getText();

  int generateUID(){return ++_currentUID;}

  bool ifChanged(){return _changed;}

  bool ifStartSet(){return _start != "";}

  bool ifDestinationSet(){return _destination != "";}

  bool ifWaypointsSet(){return getWaypoints().isNotEmpty;} 

  bool ifPathwayInitialized() => _pathwayInitialised;

  void initPathway(Search start, Search end){
    pathway = Pathway(start: start, destination: end); 
    _pathwayInitialised = true; 
  }

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

  void setIntermediate(String intermediate, int id){
    print("Set id: ${id.toString()}"); 
    int index = _intermediateManager.idToIntermediateIndex[id]!;
    print("index of this id: ${index}"); 
    if(_intermediates.length > index && _intermediates.isNotEmpty){
      _intermediates[index] = intermediate;
    } else{
      _intermediates.add(intermediate);
    }
    _changed = true;
  }

  void removeIntermediate(int id){
    print("Remove id: ${id.toString()}"); 
    int index = _intermediateManager.idToIntermediateIndex[id]!;
    if(_intermediates.length > index && _intermediates.isNotEmpty){
      _intermediates.removeAt(index);
      print("index of this id: ${index}"); 
      _intermediateManager.idToIntermediateIndex.remove(id);
      _intermediateManager.intermediateSearches.removeAt(index); 
    }else{print("Wasn't removed");}
    _changed = true;
  }

  // void clearIntermediates(){
  //   for(int i=_intermediateManager.intermediateSearches.length - 1; i >= 0; i--){
  //     _markerManager.clearMarker(SearchType.intermediate, _intermediateManager.intermediateSearches[i].intermediateIndex);
  //     removeIntermediate(_intermediateManager.intermediateSearches[i].intermediateIndex); 
  //   }
  // }

  //TODO: Clear stops

  void clearChanged(){
    _changed = false;
  }

  void endRoute() {
    _directionManager.clear();
    _polylineManager.clearPolyline();

    //clearIntermediates();
    clearStart();
    clearDestination();

    _intermediateManager.clear(); 
  }


}