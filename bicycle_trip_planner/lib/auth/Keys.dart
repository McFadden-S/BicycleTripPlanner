import 'package:firebase_remote_config/firebase_remote_config.dart';

class Keys {
  FirebaseRemoteConfig firebaseRemoteConfig = FirebaseRemoteConfig.instance;
  static String iOS_API_KEY = '';
  static String ANDROID_API_KEY = '';

  Keys(){
    iOS_API_KEY = firebaseRemoteConfig.getString('iosApiKey');
    ANDROID_API_KEY = firebaseRemoteConfig.getString('androidApiKey');
  }

  fetchKeys() async {
    bool updated = await firebaseRemoteConfig.fetchAndActivate();
    if (updated) {
      iOS_API_KEY = firebaseRemoteConfig.getString('iosApiKey');
      ANDROID_API_KEY = firebaseRemoteConfig.getString('androidApiKey');
    } else {
      // the config values were previously updated.
    }
  }
}