import 'package:flutter_riverpod/flutter_riverpod.dart';

class IsCourseCardClickedNotifier extends Notifier<bool> {
  @override
  build() => false;
  update(bool value) {
    if (state == value) return;
    state = value;
  }
}