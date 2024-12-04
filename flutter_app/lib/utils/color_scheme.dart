// lib/utils/color_scheme.dart
import 'package:flutter/material.dart';

class AppColorScheme {
  static Color indigo = const Color(0xFF034875);
  static Color transparentIndigo = const Color(0x15034875);
  static Color lapisLazuli = const Color(0xFF799BB2);
  static Color payne = const Color(0xFF4E7187);
  static Color slate = const Color(0xFF748590);
  static Color battleShip = const Color(0xFF999999);
  static Color antiFlash = const Color(0xFFEEEEEE);
  static Color ownBlack = const Color(0xFF000000);
  static Color ownWhite = const Color(0xFFFFFFFF);
  static Color computerScience = const Color(0xFF2196F3); // Blue
  static Color electricalEngineering = const Color(0xFFFF9800); // Orange
  static Color mechanicalEngineering = const Color(0xFF4CAF50); // Green
  static Color mechatronics = const Color(0xFF9C27B0); // Purple
  static Color otherSubject = const Color(0xFF795548); // Brown
  static void setDarkmode(bool darkmode) {
    if (darkmode) {
      indigo = const Color(0xFFE05408);
      transparentIndigo = const Color(0x15E05408);
      lapisLazuli = const Color(0xFF799BB2);
      payne = const Color(0xFF4E7187);
      slate = const Color(0xFF034875);
      battleShip = const Color(0xFFEEEEEE);
      antiFlash = const Color(0xFF001D31);
      ownBlack = const Color(0xFFFFFFFF);
      ownWhite = const Color(0xFF00171F);
      computerScience = const Color(0xFF2196F3);
      electricalEngineering = const Color(0xFFFF9800);
      mechanicalEngineering = const Color(0xFF4CAF50);
      mechatronics = const Color(0xFF9C27B0);
      otherSubject = const Color(0xFF795548);
    } else {
      indigo = const Color(0xFF034875);
      transparentIndigo = const Color(0x15034875);
      lapisLazuli = const Color(0xFF799BB2);
      payne = const Color(0xFF4E7187);
      slate = const Color(0xFF748590);
      battleShip = const Color(0xFF999999);
      antiFlash = const Color(0xFFEEEEEE);
      ownBlack = const Color(0xFF000000);
      ownWhite = const Color(0xFFFFFFFF);
      computerScience = const Color(0xFF2196F3);
      electricalEngineering = const Color(0xFFFF9800);
      mechanicalEngineering = const Color(0xFF4CAF50);
      mechatronics = const Color(0xFF9C27B0);
      otherSubject = const Color(0xFF795548);
    }
  }
}
