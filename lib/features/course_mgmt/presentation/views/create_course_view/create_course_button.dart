import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/core/usecases/app_navigator.dart';
import 'package:slides_sync/features/course_mgmt/data/models/course_model/course_model.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';

class CreateCourseButton extends StatelessWidget {
  const CreateCourseButton({
    super.key,
    required this.courseNameController,
  });

  final TextEditingController courseNameController;

  @override
  Widget build(BuildContext context) {
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
        onClick: () {
          final String text = courseNameController.text.trim();
          if (text.isEmpty || text.length < 2 || text.length > 64 || double.tryParse(text) != null) {
            final textStyle = CustomText("").effectiveStyle(context);
            if (text.isEmpty) {
              CustomSnackBar.showSnackBar(
                context,
                content: "Kindly input into the Text Field!",
                usePrimaryColor: true,
                textStyle: textStyle,
                icon: Icon(Iconsax.info_circle_copy, color: textStyle.color),
                margin: EdgeInsets.only(bottom: 64, left: 16, right: 16),
              );
            } else if (text.length > 64) {
              CustomSnackBar.showSnackBar(
                context,
                content: "Course name input too long!",
                usePrimaryColor: true,
                textStyle: textStyle,
                icon: Icon(Iconsax.info_circle_copy, color: textStyle.color),
                margin: EdgeInsets.only(bottom: 64, left: 16, right: 16),
              );
            } else {
              CustomSnackBar.showSnackBar(
                context,
                content: "Kindly input a valid Course name!",
                usePrimaryColor: true,
                textStyle: textStyle,
                icon: Icon(Iconsax.info_circle_copy, color: textStyle.color),
                margin: EdgeInsets.only(bottom: 64, left: 16, right: 16),
              );
            }
            return;
          }
          FocusScope.of(context).unfocus();
    
          final CourseModel courseModel = CourseModel.create(courseTitle: text);
    
          AppNavigator.of(context).modifyCoursePageRoute(courseModel);
        },
      ),
    );
  }
}