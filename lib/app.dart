import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroine/heroine.dart';
import 'package:slides_sync/app/states/app_ui_state.dart';
import 'package:slides_sync/components/themes.dart';
import 'package:slides_sync/views/home/home.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [HeroineController()],
      theme: Themes.lightTheme,
      darkTheme: Themes.darkTheme,
      home: HomeView(),
    );
  }
}
