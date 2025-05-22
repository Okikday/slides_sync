import 'dart:developer';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/core/usecases/app_navigator.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/features/course_mgmt/data/models/course_model/course_model.dart';
import 'package:slides_sync/features/course_mgmt/presentation/views/create_course_view.dart';
import 'package:slides_sync/shared/helpers/course_formatter.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';

class CreateCourseButton extends ConsumerWidget {
  const CreateCourseButton({
    super.key,
    required this.courseNameController,
    required this.courseCodeController,
    required this.isCourseCodeFieldVisible,
  });

  final TextEditingController courseNameController;
  final TextEditingController courseCodeController;
  final AutoDisposeStateProvider<bool> isCourseCodeFieldVisible;

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
        onClick: () async{
          final String courseName = courseNameController.text.trim();
          final String courseCode = courseCodeController.text.trim();
          final String? errorString = checkIfCanCreateCourse(courseName, courseCode, ref.watch(isCourseCodeFieldVisible));
          if (errorString != null) {
            UiUtils.showFlushBar(context, msg: errorString);
            return;
          }
          FocusScope.of(context).unfocus();

          await Future.delayed(Durations.medium2);

         if(context.mounted) LoadingDialog.showLoadingDialog(context, msg: "Adding Course");

          await Future.delayed(Duration(seconds: 1));

          if(context.mounted) LoadingDialog.hideLoadingDialog(context);

          await Future.delayed(Durations.short4);


          final CourseModel courseModel = CourseModel.create(courseTitle: CourseFormatter.joinCodeToTitle(courseCode, courseName));

          if(context.mounted) AppNavigator.of(context).modifyCoursePageRoute(courseModel);
        },
      ),
    );
  }
}
