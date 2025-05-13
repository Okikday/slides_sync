import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScrollOffsetNotifier extends Notifier<double> {
  @override
  double build() => 0.0;

  update(double value) {
    if (state == value) return;
    state = value;
  }
}