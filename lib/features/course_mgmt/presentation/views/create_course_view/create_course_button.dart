import 'dart:io';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/usecases/app_navigator.dart';
import 'package:slides_sync/core/utils/file_utils.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/features/course_mgmt/data/models/course_model/course_model.dart';
import 'package:slides_sync/features/course_mgmt/data/repos/course_repo.dart';
import 'package:slides_sync/features/course_mgmt/presentation/views/create_course_view.dart';
import 'package:slides_sync/shared/helpers/course_formatter.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';

class CreateCourseButton extends ConsumerWidget {
  const CreateCourseButton({
    super.key,
    required this.courseNameController,
    required this.courseCodeController,
    required this.isCourseCodeFieldVisible,
    required this.courseImagePathProvider,
  });

  final TextEditingController courseNameController;
  final TextEditingController courseCodeController;
  final StateProvider<bool> isCourseCodeFieldVisible;
  final StateProvider<String?> courseImagePathProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Positioned(
      bottom: 12,
      left: 0,
      right: 0,
      child: CustomElevatedButton(
        backgroundColor: Colors.deepPurple,
        label: "Create Course",
        textColor: Colors.white,
        textSize: 14,
        pixelWidth: context.deviceWidth,
        pixelHeight: 48,
        borderRadius: 24,
        onClick: () async {
          final String courseName = courseNameController.text.trim();
          final String courseCode = courseCodeController.text.trim();
          final String? errorString = checkIfCanCreateCourse(courseName, courseCode, ref.watch(isCourseCodeFieldVisible));
          if (errorString != null) {
            UiUtils.showFlushBar(context, msg: errorString);
            return;
          }
          FocusScope.of(context).unfocus();

          if (context.mounted) LoadingDialog.showLoadingDialog(context, msg: "Adding Course...");

          final String? courseImagePath = ref.read(courseImagePathProvider.notifier).state;

          await Future.delayed(Durations.medium2);

          CourseModel courseModel = CourseModel.create(courseTitle: CourseFormatter.joinCodeToTitle(courseCode, courseName));

          if (courseImagePath != null) {
            final String path = await FileUtils.storeFile(file: File(courseImagePath), folderPath: "courses/${courseModel.courseId}");
            courseModel = courseModel.copyWith(imagePath: "file: $path");
          }

          await CourseRepo.addCourse(courseModel);

          if (context.mounted) LoadingDialog.hideLoadingDialog(context);

          await Future.delayed(Durations.short1);

          if(context.mounted) Navigator.pop(context);

          Future.delayed(Durations.medium1);

          if (context.mounted) AppNavigator.to(context).modifyCourseRoute(courseModel);
        },
      ),
    );
  }
}
