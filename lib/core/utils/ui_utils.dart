import 'package:flutter/services.dart';

class UiUtils {
  /// For getting repititive SystemOverlayStyle
  static SystemUiOverlayStyle getSystemUiOverlayStyle(Color scaffoldBgColor, bool isDarkMode) {
    return SystemUiOverlayStyle(
      systemNavigationBarColor: scaffoldBgColor,
      statusBarColor: scaffoldBgColor,
      statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
      systemNavigationBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
    );
  }


  ///
}
