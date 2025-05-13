import 'package:flutter_riverpod/flutter_riverpod.dart';

class CourseCardScaleClickFamilyNotifier extends FamilyNotifier<bool, int> {
  @override
  build(value) => false;
  update(bool value) {
    if (state == value) return;
    state = value;
  }
}