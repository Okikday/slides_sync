import 'dart:developer';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:slides_sync/core/models/file_details.dart';
import 'package:slides_sync/core/utils/file_utils.dart';
import 'package:slides_sync/core/utils/result.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/data/models/course_model/course_model.dart';
import 'package:slides_sync/data/repos/course_repo.dart';
import 'package:slides_sync/features/create_course/domain/usecases/create_course_action.dart';
import 'package:slides_sync/features/modify_courses/presentation/views/modify_course/course_description_dialog.dart';
import 'package:slides_sync/features/modify_courses/presentation/views/modify_course/edit_course_bottom_sheet.dart';
import 'package:slides_sync/features/modify_courses/presentation/views/modify_course/modify_course_header/preview_modify_course_image_dialog.dart';
import 'package:slides_sync/shared/components/dialogs/app_action_dialog.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class ModifyCourseActions {
  /// When the user clicks to delete the course, on the Dialog
  Future<void> onDeleteCourse({required int id, required String courseId}) async {
    await CourseRepo.deleteCourseByDbId(id);
    await FileUtils.deleteFromAppDirectory(relativePath: "courses/$courseId");
  }

  /// When the user Modifies image
  Future<Result> modifyCourseImageAction({required int id, required File newImageFile}) async {
    final Result<bool?> createCourseOutcome = await Result.tryRunAsync<bool>(() async {
      CourseModel? courseModel = await CourseRepo.getCourseByDbId(id);
      if (courseModel == null) return false;
      if (courseModel.imageLocationJson.containsAnyFilePath) {
        await FileUtils.deleteFileAtPath(courseModel.imageLocationJson.filePath);
      }
      final String? newPath = await compressCourseImageAsFile(newImageFile.path, folderPath: "courses/${courseModel.courseId}");
      if (newPath != null) {
        courseModel = courseModel.copyWith(imageLocation: FileDetails(filePath: newPath));
        await CourseRepo.addCourse(courseModel);
        log("Successfully changed image ");
        return true;
      }
      return false;
    });

    if (createCourseOutcome.isSuccess) {
      return Result.success(createCourseOutcome.data!);
    }
    return Result.error("Unable to create course");
  }

  /// This deletes the course image
  Future<bool> deleteCourseImageAction({required int courseDbId}) async {
    CourseModel? courseModel = await CourseRepo.getCourseByDbId(courseDbId);
    if (courseModel == null) return false;
    if (courseModel.imageLocationJson.containsAnyFilePath) {
      await CourseRepo.addCourse(courseModel.copyWith(imageLocation: FileDetails()));
      await FileUtils.deleteFileAtPath(courseModel.imageLocationJson.filePath);
      return true;
    }
    return false;
  }

  /// When user clicks Add Description.
  /// If there's a description, it shows the Description
  /// else, it brings the option to add description
  void onClickAddDescription(
    BuildContext context, {
    required String currDescription,
    required StateProvider<CourseModel> modifyCourseProvider,
  }) {
    if (currDescription.isNotEmpty) {
      CustomDialog.show(
        context,
        canPop: true,
        reverseTransitionDuration: Durations.short4,
        transitionType: TransitionType.cupertinoDialog,
        curve: CustomCurves.defaultIosSpring,
        barrierColor: Colors.black54,
        child: CourseDescriptionDialog(
          description: currDescription,
        ).animate().scale(begin: Offset(0.5, 0.5), duration: Durations.extralong1, curve: CustomCurves.bouncySpring),
      );
    } else {
      showModalBottomSheet(
        context: context,
        enableDrag: false,
        showDragHandle: false,
        backgroundColor: context.scaffoldBackgroundColor,
        barrierColor: Colors.black54,
        isScrollControlled: true,
        builder: (context) {
          return EditCourseBottomSheet(modifyCourseProvider: modifyCourseProvider, isEditingDescription: true);
        },
      );
    }
  }

  /// Navigates to dialog to preview image
  Future<void> previewImageActionRoute(BuildContext context, {required String courseImagePath}) async {
    if (!courseImagePath.fileDetails.containsFilePath) return;
    CustomDialog.show(
      context,
      transitionDuration: Durations.short3,
      reverseTransitionDuration: Durations.short4,
      canPop: true,
      barrierColor: Colors.black.withAlpha(200),
      child: PreviewModifyCourseImageDialog(imagePath: courseImagePath),
    );
  }

  /// This picks image from device, shows a loading dialog
  Future<void> pickImageActionRoute(BuildContext context, {required int courseDbId}) async {
    CustomDialog.showLoadingDialog(context, msg: "Selecting image");
    ImagePicker imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    if (context.mounted) CustomDialog.hide(context);
    if (pickedImage == null) {
      if (context.mounted) UiUtils.showFlushBar(context, msg: "Oops, You didn't select an image!", vibe: FlushbarVibe.warning);
      return;
    }

    final Result result = await modifyCourseImageAction(id: courseDbId, newImageFile: File(pickedImage.path));

    if (context.mounted) {
      CustomDialog.hide(context);
      if (result.isSuccess) {
        UiUtils.showFlushBar(context, msg: "Successfully changed course Image!", vibe: FlushbarVibe.success);
      } else {
        UiUtils.showFlushBar(context, msg: "Unable to change course Image!", vibe: FlushbarVibe.error);
      }
    }
  }

  /// When the course image is clicked, it shows some options in a dialog the user can choose from.
  void onClickCourseImage(BuildContext context, {required CourseModel courseModel}) {
    final List<AppActionDialogModel> dialogModels = [
      AppActionDialogModel(
        title: "View image",
        icon: Icon(Iconsax.crop, size: 28),
        onTap: () async {
          CustomDialog.hide(context);
          await Future.delayed(Durations.short2);
          if (context.mounted) previewImageActionRoute(context, courseImagePath: courseModel.imageLocationJson);
        },
      ),
      AppActionDialogModel(
        title: "Change image",
        icon: Icon(Iconsax.edit, size: 28),
        onTap: () async {
          CustomDialog.hide(context);
          await Future.delayed(Durations.short2);
          if (context.mounted) await pickImageActionRoute(context, courseDbId: courseModel.id);
        },
      ),
      AppActionDialogModel(
        title: "Remove image",
        icon: Icon(Iconsax.trash, size: 28),
        onTap: () async {
          CustomDialog.hide(context);
          await Future.delayed(Durations.short2);
          if (context.mounted) CustomDialog.showLoadingDialog(context, msg: "Removing image");
          await deleteCourseImageAction(courseDbId: courseModel.id);
          if (context.mounted) CustomDialog.hide(context);
        },
      ),
    ];
    CustomDialog.show(
      context,
      canPop: true,
      transitionDuration: Durations.medium2,
      reverseTransitionDuration: Durations.short2,
      transitionType: TransitionType.cupertinoDialog,
      curve: CustomCurves.defaultIosSpring,
      barrierColor: Colors.black.withAlpha(220),
      child: AppActionDialog(
        title: "What would you like to do?",
        actions: dialogModels,
      ).animate().scaleY(begin: 0.1, end: 1.0, curve: CustomCurves.bouncySpring, duration: Durations.extralong1),
    );
  }
}
