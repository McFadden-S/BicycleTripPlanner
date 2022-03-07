import 'package:bicycle_trip_planner/managers/IDManager.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';

class Stop{
 
  String _stop;
  final int _uid = IDManager().generateUID();

  Stop([this._stop = ""]);

  String getStop() => _stop; 

  int getUID() => _uid; 

  void setStop(String stop) => _stop = stop;  
}