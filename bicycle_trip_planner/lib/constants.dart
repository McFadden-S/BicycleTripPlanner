import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'managers/TimeManager.dart';

class ThemeStyle {
  static final ThemeStyle _themeStyle = ThemeStyle._internal();

  static CurrentTime _time = CurrentTime();

  factory ThemeStyle() {
    if (_time.isDark()) {
      kPrimaryColor = Color(0xFF00008B);
      buttonPrimaryColor = Color(0xFF00008B);
      buttonSecondaryColor = Color(0xFFDCDCDC);
      kPrimaryLightColor = Color(0xFFBBDEFB);
      mainFontColor = Color(0xFF1C1C1C);
      secondaryFontColor = Color(0xFF605D5D);
      stationShadow = Color(0xFF395B64);

      primaryTextColor = Colors.white;
      secondaryTextColor = Color(0xFFF5F2E7);//Colors.white;//Colors.black45;
      boxShadow = Colors.black54;
      cardColor = Color(0xFF2C3333);//Color(0xFFDCDCDC);
      goButtonColor = Color(0xFF228B22);
      primaryIconColor = Colors.white;
      secondaryIconColor = Colors.white;//Color(0xFF484848);
      cardOutlineColor = Color(0xFF969393);

      stationMarkerColor = 120;

      mapStyle = 'assets/night_map_style.txt';

      buttonTextStyle = const TextStyle(
        color: Color(0xFFFFFFFF),
        fontFamily: 'Outfit',
        fontSize: 18,
        fontWeight: FontWeight.bold,
      );
    }
    return _themeStyle;}

  ThemeStyle._internal();

  static Color kPrimaryColor = Color(0xFF0C9CEE);
  static Color buttonPrimaryColor = Color(0xFF0C9CEE);
  static Color buttonSecondaryColor = Colors.white;
  static Color kPrimaryLightColor = Color(0xFFBBDEFB);
  static Color mainFontColor = Color(0xFF1C1C1C);
  static Color secondaryFontColor = Color(0xFF605D5D);
  static Color stationShadow = Colors.grey;

  static Color primaryTextColor = Colors.white;
  static Color secondaryTextColor = Colors.black45;
  static Color boxShadow = Colors.black45;
  static Color cardColor = Colors.white;
  static Color goButtonColor = Colors.green;
  static Color primaryIconColor = Colors.white;
  static Color secondaryIconColor = Colors.black54;
  static Color cardOutlineColor = Color(0xff969393);

  static double stationMarkerColor = BitmapDescriptor.hueGreen;

  static String mapStyle = 'assets/map_style.txt';

  static TextStyle buttonTextStyle = const TextStyle(
  color: Color(0xFFFFFFFF),
  fontFamily: 'Outfit',
  fontSize: 18,
  fontWeight: FontWeight.bold,
  );
}