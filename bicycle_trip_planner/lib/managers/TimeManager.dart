
class CurrentTime {
  int currentTime = DateTime.now().hour;

  static final CurrentTime _currentTime = CurrentTime._internal();

  factory CurrentTime() {return _currentTime;}

  CurrentTime._internal();

  int getCurrentHour() {
    return currentTime;
  }

  bool isPM() {
    print('Prave teraz je hodin: $currentTime');
    print((currentTime < 6) || (currentTime > 16));
    return ((currentTime < 6) || (currentTime > 16));
  }

}