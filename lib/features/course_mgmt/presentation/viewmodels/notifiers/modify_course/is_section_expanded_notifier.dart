import 'package:flutter_riverpod/flutter_riverpod.dart';

class IsSectionExpandedNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void update(bool value) {
    if (state == value) return;
    state = value;
  }
}