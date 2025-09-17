import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/domain/models/course_model/sub/course_content.dart';
class ModifyContentsViewProviders {
  final WidgetRef ref;
  late final ValueNotifier<LinkedHashSet<CourseContent>> selectedContentsNotifier;

  ModifyContentsViewProviders._(this.ref) {
    selectedContentsNotifier = ValueNotifier(LinkedHashSet<CourseContent>());
  }

  static ModifyContentsViewProviders of(WidgetRef ref) => ModifyContentsViewProviders._(ref);

  bool get isEmpty => selectedContentsNotifier.value.isEmpty;

  bool lookup(String value) => selectedContentsNotifier.value.contains(value);

  // return true only if the id is added
  bool selectContent(CourseContent content) {
    final set = selectedContentsNotifier.value;
    final added = set.add(content);
    if (added) selectedContentsNotifier.value = LinkedHashSet.from(set);
    return added;
  }
  bool removeContent(CourseContent content) {
    final set = selectedContentsNotifier.value;
    final removed = set.remove(content);
    if (removed) selectedContentsNotifier.value = LinkedHashSet.from(set);
    return removed;
  }
  void clearContents() {
  if (selectedContentsNotifier.value.isNotEmpty) {
    selectedContentsNotifier.value.clear();
    selectedContentsNotifier.value = LinkedHashSet();
  }
}

  void dispose() {
    selectedContentsNotifier.dispose();
  }
}
