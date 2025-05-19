import 'package:flutter/services.dart';

class UiUtils {
  /// For getting repititive SystemOverlayStyle
  static SystemUiOverlayStyle getSystemUiOverlayStyle(Color scaffoldBackgroundColor, bool isDarkMode) {
    return SystemUiOverlayStyle(
      systemNavigationBarColor: scaffoldBackgroundColor,
      statusBarColor: scaffoldBackgroundColor,
      statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
      systemNavigationBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
    );
  }


  ///
}
