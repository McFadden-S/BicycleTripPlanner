import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'managers/TimeManager.dart';

class ThemeStyle {
  static final ThemeStyle _themeStyle = ThemeStyle._internal();

  static CurrentTime _time = CurrentTime();

  factory ThemeStyle() {
    if (_time.isPM()) {
      kPrimaryColor = Color(0xFF00008B);
      buttonPrimaryColor = Color(0xFF00008B);
      buttonSecondaryColor = Color(0xFFDCDCDC);
      kPrimaryLightColor = Color(0xFFBBDEFB);
      mainFontColor = Color(0xFF1C1C1C);
      secondaryFontColor = Color(0xFF605D5D);

      primaryTextColor = Colors.white;
      secondaryTextColor = Colors.black45;
      boxShadow = Colors.black54;
      cardColor = Color(0xFFDCDCDC);
      goButtonColor = Color(0xFF228B22);
      primaryIconColor = Colors.white;
      secondaryIconColor = Color(0xFF484848);
      cardOutlineColor = Color(0xFF969393);

      stationMarkerColor = 130;

      mapStyle = 'assets/night_map_style.txt';

      buttonTextStyle = const TextStyle(
        color: Color(0xFFFFFFFF),
        fontFamily: 'Outfit',
        fontSize: 18,
        fontWeight: FontWeight.bold,
      );
    }
    else {
      kPrimaryColor = Color(0xFF0C9CEE);
      buttonPrimaryColor = Color(0xFF0C9CEE);
      buttonSecondaryColor = Colors.white;
      kPrimaryLightColor = Color(0xFFBBDEFB);
      mainFontColor = Color(0xFF1C1C1C);
      secondaryFontColor = Color(0xFF605D5D);

      primaryTextColor = Colors.white;
      secondaryTextColor = Colors.black45;
      boxShadow = Colors.black45;
      cardColor = Colors.white;
      goButtonColor = Colors.green;
      primaryIconColor = Colors.white;
      secondaryIconColor = Colors.black54;
      cardOutlineColor = Color(0xff969393);

      stationMarkerColor = BitmapDescriptor.hueGreen;

      mapStyle = 'assets/map_style.txt';

      buttonTextStyle = const TextStyle(
        color: Color(0xFFFFFFFF),
        fontFamily: 'Outfit',
        fontSize: 18,
        fontWeight: FontWeight.bold,
      );
    }

    return _themeStyle;}

  ThemeStyle._internal();

  static late Color kPrimaryColor;
  static late Color buttonPrimaryColor;
  static late Color buttonSecondaryColor;
  static late Color kPrimaryLightColor;
  static late Color mainFontColor;
  static late Color secondaryFontColor;

  static late Color primaryTextColor;
  static late Color secondaryTextColor;
  static late Color boxShadow;
  static late Color cardColor;
  static late Color goButtonColor;
  static late Color primaryIconColor;
  static late Color secondaryIconColor;
  static late Color cardOutlineColor;

  static late double stationMarkerColor;

  static late String mapStyle;

  static late TextStyle buttonTextStyle;
}