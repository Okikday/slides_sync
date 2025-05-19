
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/core/usecases/app_navigator.dart';
import 'package:slides_sync/core/utils/app_ui_state.dart';
import 'package:slides_sync/features/course_mgmt/data/models/course_model/course_model.dart';
import 'package:slides_sync/shared/components/app_bar_container.dart';
import 'package:slides_sync/shared/components/component_widgets.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';
import 'package:uuid/uuid.dart';

class CreateCourseView extends ConsumerStatefulWidget {
  const CreateCourseView({super.key});

  @override
  ConsumerState createState() => _CreateCourseViewState();
}

class _CreateCourseViewState extends ConsumerState<CreateCourseView> with SingleTickerProviderStateMixin {
  late final TextEditingController courseNameController;

  @override
  void initState() {
    super.initState();
    courseNameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    
    

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: context.scaffoldBackgroundColor,
        systemNavigationBarIconBrightness: context.isDarkMode ? Brightness.light : Brightness.dark,
        statusBarColor: context.scaffoldBackgroundColor,
        statusBarIconBrightness: context.isDarkMode ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        appBar: AppBarContainer(
          appBarHeight: kToolbarHeight + 12,
          padding: EdgeInsets.zero,
          child: Material(
            type: MaterialType.transparency,
            shape: LinearBorder(
              bottom: LinearBorderEdge(),
              side: BorderSide(color: context.isDarkMode ? Colors.lightBlueAccent.withAlpha(60) : Colors.grey.withAlpha(40)),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  ComponentWidgets.backButton(context),
                  ConstantSizing.rowSpacingMedium,
                  Expanded(child: CustomText("Create Course", fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ),

        body: SizedBox(
          height: context.deviceHeight,
          width: context.deviceWidth,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ConstantSizing.columnSpacingMedium,
                        ClipOval(
                              child: InkWell(
                                customBorder: CircleBorder(),
                                onTap: (){},
                                child: CircleAvatar(
                                  backgroundColor: Colors.lightBlueAccent.withAlpha(40),
                                  radius:
                                      context.deviceHeight > context.deviceWidth
                                          ? context.deviceWidth * 0.4 / 2
                                          : context.deviceHeight * 0.4 / 2,
                                  child: Icon(Iconsax.folder_add, size: 72)
                                      .animate()
                                      .scale(
                                        begin: Offset(0.4, 0.4),
                                        duration: Durations.extralong4,
                                        delay: Durations.medium1,
                                        curve: CustomCurves.bouncySpring,
                                      )
                                      .moveY(begin: -20, duration: Durations.extralong4, delay: Durations.medium1),
                                ),
                              ),
                            )
                            .animate()
                            .moveY(begin: -20, duration: Durations.medium2, delay: Durations.medium1, curve: CustomCurves.decelerate)
                            .fadeIn(begin: 0.3, duration: Durations.medium2, delay: Durations.medium1, curve: CustomCurves.decelerate),

                        ConstantSizing.columnSpacing(56),

                        CustomTextfield(
                          controller: courseNameController,
                          backgroundColor: Colors.grey.withAlpha(40),
                          cursorColor: CustomText("").effectiveStyle(context).color ?? Colors.white,
                          selectionHandleColor: Colors.deepPurple,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: context.isDarkMode ? Colors.lightBlueAccent.withAlpha(80) : Colors.deepPurple.withAlpha(20),

                            ),
                          ),
                          pixelWidth: context.deviceWidth,
                          pixelHeight: 60,
                          inputContentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                          hint: "Enter course title",
                          inputTextStyle: CustomText("", fontSize: 16).effectiveStyle(context),
                          onTapOutside: () {},
                        ),


                        ConstantSizing.columnSpacing(72),
                      ],
                    ),
                  ),
                ),

                Positioned(
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
                        if(text.isEmpty){
                          CustomSnackBar.showSnackBar(
                              context,
                              content: "Kindly input into the Text Field!",
                              usePrimaryColor: true,
                              textStyle: textStyle,
                              icon: Icon(Iconsax.info_circle_copy, color: textStyle.color,),
                              margin: EdgeInsets.only(bottom: 64, left: 16, right: 16)
                          );
                        }else if(text.length > 64){
                          CustomSnackBar.showSnackBar(
                              context,
                              content: "Course name input too long!",
                              usePrimaryColor: true,
                              textStyle: textStyle,
                              icon: Icon(Iconsax.info_circle_copy, color: textStyle.color,),
                              margin: EdgeInsets.only(bottom: 64, left: 16, right: 16)
                          );
                        }else{
                          CustomSnackBar.showSnackBar(
                              context,
                              content: "Kindly input a valid Course name!",
                              usePrimaryColor: true,
                              textStyle: textStyle,
                              icon: Icon(Iconsax.info_circle_copy, color: textStyle.color,),
                              margin: EdgeInsets.only(bottom: 64, left: 16, right: 16)
                          );
                        }
                        return;
                      }
                      FocusScope.of(context).unfocus();

                      final CourseModel courseModel = CourseModel.create(courseTitle: text);

                      AppNavigator.of(context).modifyCoursePageRoute(courseModel);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
