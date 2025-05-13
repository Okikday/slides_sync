import 'package:flutter_riverpod/flutter_riverpod.dart';

class IsHomeScrolledNotifier extends Notifier<bool> {
  @override
  bool build() => false;
  void update(bool newValue) {
    if (state == newValue) return;
    state = newValue;
  }
}