import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'routes/routes.dart';
import 'shared/styles/themes.dart';

final NotifierProvider<AppThemeDataProvider, ThemeData> appThemeDataProvider = NotifierProvider(AppThemeDataProvider.new);

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    log("Build Material App");
    return MaterialApp.router(
      title: "SlideSync",
      routerConfig: Routes.mainRouter,
      debugShowCheckedModeBanner: false,
      theme: ref.watch(appThemeDataProvider)
    );
  }
}
