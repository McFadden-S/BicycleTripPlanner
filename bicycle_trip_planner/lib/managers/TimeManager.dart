import 'package:sunrise_sunset_calc/sunrise_sunset_calc.dart';

class CurrentTime {
  DateTime currentTime = DateTime.now();
  int currentHour = DateTime.now().hour;

  static final CurrentTime _currentTime = CurrentTime._internal();

  factory CurrentTime() {return _currentTime;}

  CurrentTime._internal();

  int getCurrentHour() {
    return currentHour;
  }

  bool isDark() {
    var sunset = getSunriseSunset(	51.509865, -0.118092, 0, currentTime).sunset;
    var sunrise = getSunriseSunset(	51.509865, -0.118092, 0, currentTime).sunrise;
    return ((currentTime.isAfter(sunset)) || (currentTime.isBefore(sunrise)));
  }
}