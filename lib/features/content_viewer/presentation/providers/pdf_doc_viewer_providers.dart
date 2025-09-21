import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/global_notifiers/toggle_notifier.dart';
import 'package:slides_sync/core/storage/hive_data/hive_data_paths.dart';

class PdfDocViewerProviders {
  static final AutoDisposeAsyncNotifierProvider<ToggleNotifier, bool> ispdfViewerInDarkModeNotifier =
    AutoDisposeAsyncNotifierProvider<ToggleNotifier, bool>(() => ToggleNotifier(HiveDataPaths.ispdfViewerInDarkMode));
}