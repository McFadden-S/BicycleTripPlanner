class Keys {

  //********** Singleton **********

  /// Holds Singleton Instance
  static final Keys _keys = Keys._internal();

  /// Singleton Constructor Override
  factory Keys() {
    return _keys;
  }

  Keys._internal();

  static String API_KEY = 'AIzaSyDxZUAHlrTTckkPJVXS4G15zL8zDWghb6c';

}