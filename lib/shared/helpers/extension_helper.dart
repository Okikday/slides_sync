import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/app.dart';
import 'package:slides_sync/shared/helpers/device_helper.dart';
import 'package:slides_sync/shared/helpers/responsiveness_helper.dart';
import 'package:slides_sync/shared/styles/theme/app_theme_model.dart';

extension ExtensionHelper on BuildContext {
  BuildContext get context => this;
  ThemeData get theme => Theme.of(context);
  Color get scaffoldBackgroundColor => Theme.of(this).scaffoldBackgroundColor;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
  MediaQueryData get mediaQuery => MediaQuery.of(context);
  Size get screenSize => MediaQuery.of(this).size;
  double get deviceWidth => screenSize.width;
  double get deviceHeight => screenSize.height;
  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);
  EdgeInsets get padding => MediaQuery.paddingOf(this);
  double get topPadding => padding.top;
  double get bottomPadding => padding.bottom;

  //
}

extension ResponsivenessExtension on BuildContext {
  DeviceType get deviceType => DeviceHelper.getDeviceType(this);
  double get hPadding => ResponsivenessHelper.resolveHPadding(this);
  double get defaultBtnDimension => ResponsivenessHelper.resolveSquareButtonSize(this);

  double get hPadding5 => hPadding * .5;
  double get hPadding7 => hPadding * .7;
}

extension AppProviderTheme on WidgetRef {
  AppThemeModel get theme => watch(appThemeProvider);
}
