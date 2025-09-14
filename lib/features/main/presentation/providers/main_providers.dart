import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainProviders {
  static final AutoDisposeStateProvider<bool> isMainScrolledProvider = AutoDisposeStateProvider((ref) => false);
  static final AutoDisposeStateProvider<int> mainTabViewIndexProvider = AutoDisposeStateProvider((ref) => 0);
  static final AutoDisposeStateProvider<bool> isFocusModeProvider = AutoDisposeStateProvider((ref) => false);
}
