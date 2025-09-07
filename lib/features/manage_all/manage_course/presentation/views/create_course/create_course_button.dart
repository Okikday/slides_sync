import 'dart:developer';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/routes/app_route_navigator.dart';
import 'package:slides_sync/core/utils/result.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/features/manage_all/manage_course/usecases/create_course_uc/create_course_uc.dart';
import 'package:slides_sync/core/routes/routes.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

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
  final AutoDisposeStateProvider<bool> isCourseCodeFieldVisible;
  final AutoDisposeStateProvider<String?> courseImagePathProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Positioned(
      bottom: 12,
      left: 0,
      right: 0,
      child: CustomElevatedButton(
        backgroundColor: ref.theme.primaryColor,
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
            UiUtils.showFlushBar(
              context,
              msg: errorString,
              vibe: FlushbarVibe.error,
              margin: EdgeInsets.only(left: 24, right: 24, bottom: context.bottomPadding + 60),
              barBlur: 2.0,
            );
            return;
          }
          FocusScope.of(context).unfocus();

          if (context.mounted) {
            UiUtils.showLoadingDialog(context, message: "Adding Course...", backgroundColor: Colors.white10, blurSigma: Offset(2, 2));
          }

          final String? courseImagePath = ref.read(courseImagePathProvider.notifier).state;

          final Result<Course> createCourseOutcome = await CreateCourseUc().createCourseAction(
            courseName: courseName,
            courseCode: courseCode,
            courseImagePath: courseImagePath,
          );

          if (context.mounted) UiUtils.hideDialog(context);

          createCourseOutcome
              .doNext((value) async {
                if (context.mounted) {
                  Navigator.of(context).pop();
                  log("${context.mounted}");
                  AppRouteNavigator.to(context).modifyCourseRoute(value);
                  await Future.delayed(Durations.short4);
                  if (rootNavigatorKey.currentContext != null && rootNavigatorKey.currentContext!.mounted) {
                    await UiUtils.showFlushBar(
                      rootNavigatorKey.currentContext!,
                      msg: "Successfully created course!",
                      vibe: FlushbarVibe.success,
                    );
                  }
                }
              })
              .onError((error, [_]) async {
                await UiUtils.showFlushBar(
                  context,
                  msg: error,
                  vibe: FlushbarVibe.error,
                  margin: EdgeInsets.only(left: 24, right: 24, bottom: context.bottomPadding + 60),
                );
              });
        },
      ),
    );
  }
}

String? checkIfCanCreateCourse(String courseName, String courseCode, bool isCourseCodeVisible, {int minLength = 2, int maxLength = 64}) {
  if (courseName.isEmpty || courseName.length < minLength || courseName.length > maxLength || double.tryParse(courseName) != null) {
    if (courseName.isEmpty) return "Kindly fill the course title field!";
    if (courseName.length < 2) return "Course title too short!";
    if (courseName.length > 64) return "Course title too long!";
    return "Kindly input a valid course title!";
  } else if (isCourseCodeVisible && (courseCode.length < 2 || courseCode.length > 16)) {
    return "Kindly input a valid course code or hide it";
  }
  return null;
}
