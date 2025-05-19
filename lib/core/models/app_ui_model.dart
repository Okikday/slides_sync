// import 'package:flutter/material.dart';
//
// class AppUiModel {
//   final bool isDarkMode;
//   final double deviceWidth;
//   final double deviceHeight;
//   final EdgeInsets viewInsets;
//
//   const AppUiModel({this.isDarkMode = false, this.deviceWidth = 0.0, this.deviceHeight = 0.0, this.viewInsets = EdgeInsets.zero});
//
//   AppUiModel copyWith({bool? isDarkMode, double? deviceWidth, double? deviceHeight, EdgeInsets? viewInsets}) {
//     return AppUiModel(
//       isDarkMode: isDarkMode ?? this.isDarkMode,
//       deviceWidth: deviceWidth ?? this.deviceWidth,
//       deviceHeight: deviceHeight ?? this.deviceHeight,
//       viewInsets: viewInsets ?? this.viewInsets,
//     );
//   }
//
//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;
//     return other is AppUiModel &&
//         other.isDarkMode == isDarkMode &&
//         other.deviceWidth == deviceWidth &&
//         other.deviceHeight == deviceHeight &&
//         other.viewInsets == viewInsets;
//   }
//
//   @override
//   int get hashCode {
//     return isDarkMode.hashCode ^ deviceWidth.hashCode ^ deviceHeight.hashCode ^ viewInsets.hashCode;
//   }
// }
