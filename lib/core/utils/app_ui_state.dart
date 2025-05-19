// import 'dart:developer';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:slides_sync/core/models/app_ui_model.dart';
//
// export 'package:slides_sync/core/models/app_ui_model.dart' show AppUiModel;
//
// final NotifierProvider<AppUiState, AppUiModel> appUiStateProvider = NotifierProvider<AppUiState, AppUiModel>(AppUiState.new);
//
// class AppUiState extends Notifier<AppUiModel> with WidgetsBindingObserver {
//   bool isInitialized = false;
//
//   @override
//   AppUiModel build() {
//     WidgetsBinding.instance.addObserver(this);
//     ref.onDispose(() => WidgetsBinding.instance.removeObserver(this));
//     if (!isInitialized) log("App UI State is not initialized yet.");
//     return const AppUiModel();
//   }
//
//   @override
//   void didChangeMetrics() {
//     try {
//       updateMetrics();
//     } catch (e) {
//       log("Error initializing app UI state: $e");
//     }
//   }
//
//   @override
//   void didChangePlatformBrightness() {
//     updatePlatformBrightness();
//   }
//
//   void initAppUiState() {
//     updateMetrics();
//     updatePlatformBrightness();
//     isInitialized = true;
//     log("Initialized app Ui State");
//
//     final appUiModel = state;
//     print(
//       "deviceWidth: ${context.deviceWidth}\n"
//       "deviceHeight: ${context.deviceHeight}\n"
//       "isDarkMode: ${context.isDarkMode}\n"
//       "viewInsets: ${appUiModel.viewInsets}\n",
//     );
//   }
//
//   void updateMetrics() {
//     final FlutterView? instanceImplicitView = WidgetsBinding.instance.platformDispatcher.implicitView;
//     final Size? size = instanceImplicitView?.physicalSize;
//     final ViewPadding? systemViewInsets = instanceImplicitView?.viewInsets;
//     final double? devicePixelRatioTemp = instanceImplicitView?.devicePixelRatio;
//
//     if (size != null && devicePixelRatioTemp != null) {
//       final double logicalWidth = size.width / devicePixelRatioTemp;
//       final double logicalHeight = size.height / devicePixelRatioTemp;
//
//       state = state.copyWith(
//         deviceWidth: logicalWidth,
//         deviceHeight: logicalHeight,
//         viewInsets: systemViewInsets != null ? EdgeInsets.fromViewPadding(systemViewInsets, devicePixelRatioTemp) : state.viewInsets,
//       );
//     }
//   }
//
//   void updatePlatformBrightness() {
//     final bool isDarkModeTemp = WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
//
//     if (isDarkModeTemp != state.isDarkMode) {
//       state = state.copyWith(isDarkMode: isDarkModeTemp);
//     }
//   }
//
//   void updateState(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//     final EdgeInsets viewInsetsTemp = MediaQuery.of(context).viewInsets;
//     final bool isDarkModeTemp = Theme.of(context).brightness == Brightness.dark;
//
//     state = state.copyWith(deviceWidth: size.width, deviceHeight: size.height, viewInsets: viewInsetsTemp, isDarkMode: isDarkModeTemp);
//   }
// }
