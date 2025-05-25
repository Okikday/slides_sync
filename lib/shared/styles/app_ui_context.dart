import 'package:flutter/material.dart';

extension AppUiContext on BuildContext {
  BuildContext get context => this;
  Color get scaffoldBackgroundColor => Theme.of(this).scaffoldBackgroundColor;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
  Size get screenSize => MediaQuery.of(this).size;
  double get deviceWidth => screenSize.width;
  double get deviceHeight => screenSize.height;
  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);
  EdgeInsets get padding => MediaQuery.paddingOf(this);
  double get topPadding => padding.top;
}