import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeNavBarIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;
  void update(int newIndex) => state = newIndex;
}