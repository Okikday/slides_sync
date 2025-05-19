import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/features/course_mgmt/data/models/course_model/course_model.dart';
class ModifyCourseModelNotifier extends Notifier<CourseModel> {
  @override
  CourseModel build() {
    return CourseModel();
  }

  void update(CourseModel courseModel) {
    if (state == courseModel) return;
    state = courseModel;
  }
}