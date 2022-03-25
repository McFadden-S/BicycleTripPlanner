import 'package:bicycle_trip_planner/managers/IDManager.dart';
import 'package:bicycle_trip_planner/models/place.dart';

class Stop {
  Place _stop;
  final int _uid = IDManager().generateUID();

  Stop([this._stop = const Place.placeNotFound()]);

  /**
   * @return Place stop
   */
  Place getStop() => _stop;

  /**
   * @return int uid
   */
  int getUID() => _uid;

  /**
   * method sets the stop to specified place
   * @return Place stop
   */
  void setStop(Place stop) => _stop = stop;

  /**
   * method override the toString method
   * @return String of the toString of the object
   */
  @override
  String toString() {
    return "${_stop.toString()} - ${_uid}";
  }
}
