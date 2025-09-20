import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/storage/hive_data/hive_data_paths.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/providers/custom_notifiers/is_list_view_notifier.dart';

class LibraryTabViewProviders {
  /// All To be used in just the LibraryTabView since it's a main view
  static final ValueNotifier<double> scrollPositionNotifier = ValueNotifier(0.0);

  static final AutoDisposeAsyncNotifierProvider<CardViewTypeNotifier, int> cardViewType =
      AutoDisposeAsyncNotifierProvider<CardViewTypeNotifier, int>(
        () => CardViewTypeNotifier(HiveDataPaths.libraryTabCardViewType, 2),
      );
  static bool isCourseCardAnimating = false;

  static Offset? cardTapPositionDetails;

  static void dispose() {
    scrollPositionNotifier.dispose();
    log("Disposed Library Tab View Providers");
  }
}
