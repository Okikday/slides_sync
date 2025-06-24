import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/shared/styles/app_color_palette.dart';

import 'routes/routes.dart';
import 'shared/styles/themes.dart';

final NotifierProvider<AppColorPaletteProvider, AppColorPalette> appPaletterProvider = NotifierProvider(AppColorPaletteProvider.new);

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    
    return MaterialApp.router(
      routerConfig: Routes.mainRouter,
      debugShowCheckedModeBanner: false,
      theme: Themes.lightTheme,
      darkTheme: Themes.darkTheme,
    );
  }
}
