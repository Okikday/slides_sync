import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/data/hive_data/hive_data.dart';
import 'package:slides_sync/shared/styles/theme/app_theme_model.dart';

import 'routes/routes.dart';
import 'shared/styles/theme/themes.dart';

final NotifierProvider<AppThemeDataProvider, ThemeData> appThemeDataProvider = NotifierProvider(AppThemeDataProvider.new);

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final String? hiveTheme = (await HiveData().getData(key: "appTheme")) as String?;
      if (hiveTheme == null) return;
      final AppThemeModel theme = AppThemeModel.fromJson(hiveTheme);
      ref.read(appThemeDataProvider.notifier).update(resolveThemeData(theme));
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    final theme = ref.watch(appThemeDataProvider);

    log("MaterialApp rebuilt");
    return MaterialApp.router(title: "SlideSync", routerConfig: Routes.mainRouter, debugShowCheckedModeBanner: false, theme: theme);
  }
}
