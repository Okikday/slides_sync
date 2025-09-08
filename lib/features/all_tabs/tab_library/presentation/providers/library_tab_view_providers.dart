import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/providers/custom_notifiers/is_list_view_notifier.dart';

class LibraryTabViewProviders {
  static final AutoDisposeStateProvider<double> scrollPosition = AutoDisposeStateProvider<double>((ref) => 0.0);
  static final AutoDisposeAsyncNotifierProvider<IsListViewNotifier, bool> isListLayout =
      AutoDisposeAsyncNotifierProvider<IsListViewNotifier, bool>(() => IsListViewNotifier("library_tab/isListView"));

  static final AutoDisposeStateProviderFamily<bool, int> isCourseCardTappedDownFamily = AutoDisposeStateProviderFamily(
    (ref, index) => false,
  );

  static final StateProvider<bool> isCourseCardAnimating = StateProvider((ref) => false);

  static final StateProvider<Offset?> cardTapPositionDetails = StateProvider<Offset?>((ref) => null);
}
