import 'package:bicycle_trip_planner/widgets/general/Search.dart';

class IntermediateManager{

  //********** Fields **********

  // TODO: Make variables private
  Map<int, int> idToIntermediateIndex = Map(); 
  List<Search> intermediateSearches = []; 

  //********** Singleton **********

  static final IntermediateManager _intermediateManager = IntermediateManager._internal(); 

  factory IntermediateManager(){return _intermediateManager;} 

  IntermediateManager._internal(); 

  //********** Public **********

  void setIDToSearch(int id, int index){
    idToIntermediateIndex.update(id, (oldIndex) => index, ifAbsent: () => index);
  }

  void clear(){
    idToIntermediateIndex.clear();
    intermediateSearches.clear(); 
  }
}