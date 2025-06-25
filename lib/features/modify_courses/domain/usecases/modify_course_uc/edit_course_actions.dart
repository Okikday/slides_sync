import 'dart:developer';

import 'package:another_flushbar/flushbar.dart';
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/data/models/course_model/course_model.dart';
import 'package:slides_sync/data/repos/course_repo.dart';
import 'package:slides_sync/shared/components/dialogs/app_alert_dialog.dart';
import 'package:slides_sync/shared/helpers/course_formatter.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/styles/colors.dart';

class EditCourseActions {
  /// Logic to check if the inputs are valid
  String? checkIfCanUpdateCourse({
    required String courseName,
    required String courseCode,
    required String description,
    required bool isVisible,
  }) {
    if (courseName.isEmpty || courseName.length < 2 || courseName.length > 64 || double.tryParse(courseName) != null) {
      if (courseName.isEmpty) return "Kindly fill the course title field!";
      if (courseName.length < 2) return "Course title too short!";
      if (courseName.length > 64) return "Course title too long!";
      return "Kindly input a valid course title!";
    } else if (isVisible && (courseCode.length < 2 || courseCode.length > 16)) {
      return "Kindly input a valid course code or hide it";
    } else if (description.length > 1024) {
      return "Kindly input a valid description!";
    }
    return null;
  }

  /// Logic to call when user tries to pop page. It'll ask if user wants to exit without saving
  void onPopInvokedWithResult(BuildContext context, StateController<bool> provider) {
    if (provider.state) return;
    CustomDialog.show(
      context,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      transitionType: TransitionType.cupertinoDialog,
      blurSigma: Offset(2.0, 2.0),
      transitionDuration: Durations.medium2,
      child: AppAlertDialog(
        title: "Confirm exit",
        content: "Are you sure you want to exit without saving?",
        backgroundColor: context.isDarkMode ? AppColors.darkBlue.withAlpha(200) : null,
        onCancel: () {
          CustomDialog.hide(context);
        },
        onConfirm: () async {
          CustomDialog.hide(context);

          provider.update((cb) => true);
          Navigator.pop(context);
        },
      ),
    );
  }

  /// Logic to call when user is trying to update details or saving changes
  void onUpdateDetails(
    BuildContext context, {
    required String courseName,
    required String courseCode,
    required String description,
    required bool isCourseCodeFieldVisible,
    required StateController<bool> canExitProvider,
    required StateController<CourseModel> modifyCourseProvider,
  }) async {
    final String? errorMsg = checkIfCanUpdateCourse(
      courseName: courseName,
      courseCode: courseCode,
      description: description,
      isVisible: isCourseCodeFieldVisible,
    );
    if (errorMsg != null) {
      log("Cant update");
      UiUtils.showFlushBar(context, msg: errorMsg, flushbarPosition: FlushbarPosition.TOP);
      return;
    }
    final String courseTitle = CourseFormatter.joinCodeToTitle(courseCode, courseName);
    final CourseModel currCourseModel = modifyCourseProvider.state;
    final CourseModel updatedCourseModel = currCourseModel.copyWith(courseTitle: courseTitle, description: description);
    modifyCourseProvider.update((ref) => updatedCourseModel);
    await CourseRepo.addCourse(updatedCourseModel);
    canExitProvider.update((cb) => true);
    if (context.mounted) Navigator.pop(context);
  }
}
