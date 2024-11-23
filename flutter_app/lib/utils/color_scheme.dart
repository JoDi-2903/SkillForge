class AppColorScheme {
  static Color indigo = const Color(0xFF034875);
  static Color lapisLazuli = const Color(0xFF799BB2);
  static Color payne = const Color(0xFF4E7187);
  static Color slate = const Color(0xFF748590);
  static Color battleShip = const Color(0xFF999999);
  static Color antiFlash = const Color(0xFFEEEEEE);
  static Color ownBlack = const Color(0xFF000000);
  static Color ownWhite = const Color(0xFFFFFFFF);
  static void setDarkmode(bool darkmode) {
    if (darkmode) {
      indigo = const Color(0xFFE05408);
      lapisLazuli = const Color(0xFF799BB2);
      payne = const Color(0xFF4E7187);
      slate = const Color(0xFF034875);
      battleShip = const Color(0xFFEEEEEE);
      antiFlash = const Color(0xFF001D31);
      ownBlack = const Color(0xFFFFFFFF);
      ownWhite = const Color(0xFF00171F);
    } else {
      indigo = const Color(0xFF034875);
      lapisLazuli = const Color(0xFF799BB2);
      payne = const Color(0xFF4E7187);
      slate = const Color(0xFF748590);
      battleShip = const Color(0xFF999999);
      antiFlash = const Color(0xFFEEEEEE);
      ownBlack = const Color(0xFF000000);
      ownWhite = const Color(0xFFFFFFFF);
    }
  }
}
