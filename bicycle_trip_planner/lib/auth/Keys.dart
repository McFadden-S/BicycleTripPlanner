import 'dart:io';

class Keys {

  //********** Singleton **********

  /// Holds Singleton Instance
  static final Keys _keys = Keys._internal();

  /// Singleton Constructor Override
  factory Keys() {
    return _keys;
  }

  Keys._internal();

  static String _iOS_API_KEY = 'AIzaSyCalgOMn6pEnKoPqAnKcvcAPT55PPBBW9U';
  static String _ANDROID_API_KEY = 'AIzaSyCWEsSRJdyx4NF3Zc47feYbnWlxFF7jhpY';


  static String getApiKey() {
    if(Platform.isIOS){
      return _iOS_API_KEY;
    }
    if(Platform.isAndroid){
      return _ANDROID_API_KEY;
    }
    return 'NO API KEY';
  }

}