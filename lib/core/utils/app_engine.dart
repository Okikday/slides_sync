import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/app.dart';
import 'package:slides_sync/core/storage/hive_data/app_hive_data.dart';
import 'package:slides_sync/shared/styles/theme/app_theme_model.dart';

class AppEngine {
  Future<void> loadTheme(ProviderContainer container) async {
  final String? hiveTheme =
      (await AppHiveData.instance.getData(key: "appTheme")) as String?;
  if (hiveTheme == null) return;
  final AppThemeModel theme = AppThemeModel.fromJson(hiveTheme);
  container.read(appThemeProvider.notifier).update(theme);
}
}