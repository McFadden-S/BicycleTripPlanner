import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'dart:io';

class Keys {
  FirebaseRemoteConfig firebaseRemoteConfig = FirebaseRemoteConfig.instance;
  static String _iOS_API_KEY = '';
  static String _ANDROID_API_KEY = '';

  Keys(){
    _iOS_API_KEY = firebaseRemoteConfig.getString('iosApiKey');
    _ANDROID_API_KEY = firebaseRemoteConfig.getString('androidApiKey');
  }

  fetchKeys() async {
    bool updated = await firebaseRemoteConfig.fetchAndActivate();
    if (updated) {
      _iOS_API_KEY = firebaseRemoteConfig.getString('iosApiKey');
      _ANDROID_API_KEY = firebaseRemoteConfig.getString('androidApiKey');
    } else {
      // the config values were previously updated.
    }
  }

  static String getApiKey() {
    if(Platform.isIOS){
      return _iOS_API_KEY;
    }
    if(Platform.isAndroid){
      return _ANDROID_API_KEY;
    }
    return 'NO API KEY';
  }

  static bool areUndefined() {
    return Keys._ANDROID_API_KEY == ''
        || Keys._iOS_API_KEY == '';
  }
}