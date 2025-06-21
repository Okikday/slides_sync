import 'package:flutter_riverpod/flutter_riverpod.dart';

final StateProvider<bool> isMainScrolledProvider = StateProvider((ref) => false);
final StateProvider<int> mainTabViewIndexProvider = StateProvider((ref) => 0);
