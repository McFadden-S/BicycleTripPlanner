import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'managers/TimeManager.dart';

class ThemeStyle {
  CurrentTime _time = CurrentTime();

  static Color kPrimaryColor = Color(0xFF0C9CEE);
  static Color buttonPrimaryColor = Color(0xFF0C9CEE);
  static Color buttonSecondaryColor = Colors.white;
  static Color kPrimaryLightColor = Color(0xFFBBDEFB);
  static Color mainFontColor = Color(0xFF1C1C1C);
  static Color secondaryFontColor = Color(0xFF605D5D);

  static Color primaryTextColor = Colors.white;
  static Color secondaryTextColor = Colors.black45;
  static Color boxShadow = Colors.black45;
  static Color cardColor = Colors.white;
  static Color goButtonColor = Colors.green;
  static Color primaryIconColor = Colors.white;
  static Color secondaryIconColor = Colors.black54;
  static Color cardOutlineColor = Color(0xff969393);

  static String mapStyle = 'assets/map_style.txt';

  static TextStyle buttonTextStyle = const TextStyle(
    color: Color(0xFFFFFFFF),
    fontFamily: 'Outfit',
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  ColorTheme(){
    if (_time.isPM()) {
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

      mapStyle = 'assets/night_map_style.txt';

      buttonTextStyle = const TextStyle(
        color: Color(0xFFFFFFFF),
        fontFamily: 'Outfit',
        fontSize: 18,
        fontWeight: FontWeight.bold,
      );
    }
  }

}