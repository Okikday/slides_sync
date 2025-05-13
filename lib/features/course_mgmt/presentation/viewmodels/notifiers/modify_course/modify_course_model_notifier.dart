import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../shared/models/course_model/course_model.dart';
class ModifyCourseModelNotifier extends Notifier<CourseModel> {
  @override
  CourseModel build() {
    return CourseModel(courseId: "courseId", courseTitle: "courseTitle");
  }

  void update(CourseModel courseModel) {
    if (state == courseModel) return;
    state = courseModel;
  }
}