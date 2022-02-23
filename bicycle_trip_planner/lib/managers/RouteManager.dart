class RouteManager{

  //********** Fields **********

  String _start = "";
  String _destination = "";

  List<String> _intermediates = <String>[];

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

  bool ifChanged(){return _changed;}

  bool ifStartSet(){return _start != "";}

  bool ifDestinationSet(){return _destination != "";}

  void setStart(String start){
    _start = start;
    _changed = true;
  }

  void clearStart(){
    setStart("");
  }

  void setDestination(String destination){
    _destination = destination;
    _changed = true;
  }

  void clearDestination(){
    setDestination("");
  }

  void setIntermediate(String intermediate, int id){
    if(_intermediates.length <= id && _intermediates.isNotEmpty){
      _intermediates[id-1] = intermediate;
    } else{
      _intermediates.add(intermediate);
    }
    _changed = true;
  }

  void removeIntermediate(int id){
    if(_intermediates.length <= id && _intermediates.isNotEmpty){
      _intermediates.removeAt(id-1);
    }
    _changed = true;
  }

  void clearChanged(){
    _changed = false;
  }

}