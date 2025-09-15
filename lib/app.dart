import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/routes/routes.dart';
import 'package:slides_sync/core/storage/hive_data/app_hive_data.dart';
import 'package:slides_sync/core/utils/file_utils.dart';
import 'package:slides_sync/shared/styles/theme/app_theme_model.dart';
import 'package:slides_sync/shared/styles/theme/built_in_themes.dart';

import 'shared/styles/theme/themes.dart';

final NotifierProvider<AppThemeProvider, AppThemeModel> appThemeProvider = NotifierProvider(AppThemeProvider.new);

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  Future<void> _loadThemeFromHive() async {
    try {
      final String? hiveTheme = (await AppHiveData.instance.getData(key: "appTheme")) as String?;
      if (hiveTheme == null) {
        ref.read(appThemeProvider.notifier).update(Brightness.dark, defaultUnifiedThemeModels[0]);
        return;
      }
      final UnifiedThemeModel unifiedTheme = UnifiedThemeModel.fromJson(hiveTheme);

      if (mounted) {
        final currentBrightness = MediaQuery.platformBrightnessOf(context);
        ref.read(appThemeProvider.notifier).update(currentBrightness, unifiedTheme);
      }
    } catch (e) {
      debugPrint('Failed to load theme from Hive: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    if (RootIsolateToken.instance != null) {
      compute(FileUtils.deleteEmptyCoursesDirsInIsolate, {'rootIsolateToken': RootIsolateToken.instance});
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadThemeFromHive());
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(appThemeProvider);

    return MaterialApp.router(
      title: "SlideSync",
      routerConfig: Routes.mainRouter,
      debugShowCheckedModeBanner: false,
      theme: resolveThemeData(theme),
    );
  }
}


// class DummyApp extends ConsumerWidget {
//   const DummyApp({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return MaterialApp(home: Center(child: Text("This is a text"),));
//   }
// }