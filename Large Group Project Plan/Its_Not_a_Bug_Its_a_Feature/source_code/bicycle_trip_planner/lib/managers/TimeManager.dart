import 'package:sunrise_sunset_calc/sunrise_sunset_calc.dart';

/// Class Comment:
/// CurrentTime is a manager class that holds the current time
/// and checks actual sunrise/sunset

class CurrentTime {

  //********** Fields **********

  DateTime currentTime = DateTime.now();
  int currentHour = DateTime.now().hour;

  //********** Singleton **********

  static final CurrentTime _currentTime = CurrentTime._internal();

  factory CurrentTime() {return _currentTime;}

  CurrentTime._internal();

  //********** Public **********

  /// @param void
  /// @return int - current hour
  int getCurrentHour() {
    return currentHour;
  }

  /// @param void
  /// @return bool -
  ///   true - current time is after sunset
  ///   false - current time is before sunset
  bool isDark() {
    var sunset = getSunriseSunset(	51.509865, -0.118092, 0, currentTime).sunset;
    var sunrise = getSunriseSunset(	51.509865, -0.118092, 0, currentTime).sunrise;
    return ((currentTime.isAfter(sunset)) || (currentTime.isBefore(sunrise)));
  }
}