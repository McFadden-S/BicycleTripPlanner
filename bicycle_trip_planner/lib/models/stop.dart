import 'package:bicycle_trip_planner/managers/IDManager.dart';
import 'package:bicycle_trip_planner/models/place.dart';

class Stop {
  Place _stop;
  final int _uid = IDManager().generateUID();

  Stop([this._stop = const Place.placeNotFound()]);


  Place getStop() => _stop;

  int getUID() => _uid;

  void setStop(Place stop) => _stop = stop;
}
