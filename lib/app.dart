
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/routes/routes.dart';
import 'package:slides_sync/shared/styles/theme/app_theme_model.dart';

import 'shared/styles/theme/themes.dart';

final NotifierProvider<AppThemeProvider, AppThemeModel> appThemeProvider =
    NotifierProvider(AppThemeProvider.new);


class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    final theme = ref.watch(appThemeProvider).themeData;

    return MaterialApp.router(title: "SlideSync", routerConfig: Routes.mainRouter, debugShowCheckedModeBanner: false, theme: theme);
  }
}
