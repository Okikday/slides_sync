
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:slides_sync/app/states/app_ui_state.dart';
import 'package:slides_sync/shared/components/app_bar_container.dart';
import 'package:slides_sync/shared/components/component_widgets.dart';
import 'package:slides_sync/shared/models/course_model/course_model.dart';
import 'package:slides_sync/features/course_mgmt/presentation/views/manage_courses/create_course_view/modify_course.dart';
import 'package:uuid/uuid.dart';

class CreateCourseView extends ConsumerStatefulWidget {
  final NotifierProvider<AppUiState, AppUiModel> appUiStateProvider;
  const CreateCourseView(this.appUiStateProvider, {super.key});

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
    final AppUiModel appUiModel = ref.watch(appUiStateProvider);
    final Color scaffoldBgColor = Theme.of(context).scaffoldBackgroundColor;

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: scaffoldBgColor,
        systemNavigationBarIconBrightness: appUiModel.isDarkMode ? Brightness.light : Brightness.dark,
        statusBarColor: scaffoldBgColor,
        statusBarIconBrightness: appUiModel.isDarkMode ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        appBar: AppBarContainer(
          appBarHeight: kToolbarHeight + 12,
          padding: EdgeInsets.zero,
          child: Material(
            type: MaterialType.transparency,
            shape: LinearBorder(
              bottom: LinearBorderEdge(),
              side: BorderSide(color: appUiModel.isDarkMode ? Colors.lightBlueAccent.withAlpha(60) : Colors.grey.withAlpha(40)),
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
          height: appUiModel.deviceHeight,
          width: appUiModel.deviceWidth,
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
                                      appUiModel.deviceHeight > appUiModel.deviceWidth
                                          ? appUiModel.deviceWidth * 0.4 / 2
                                          : appUiModel.deviceHeight * 0.4 / 2,
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
                              color: appUiModel.isDarkMode ? Colors.lightBlueAccent.withAlpha(80) : Colors.deepPurple.withAlpha(20),

                            ),
                          ),
                          pixelWidth: appUiModel.deviceWidth,
                          pixelHeight: 60,
                          inputContentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                          hint: "Enter a new Course title",
                          inputTextStyle: CustomText("", fontSize: 16).effectiveStyle(context),
                          onTapOutside: () {},
                        ),

                        ConstantSizing.columnSpacingMedium,

                        CustomTextButton(label: "Add alternative course code", textColor: Colors.blue,onClick: (){}, ),


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
                    pixelWidth: appUiModel.deviceWidth,
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


                      final String courseId = Uuid().v4();
                      final CourseModel courseModel = CourseModel(
                        courseId: courseId,
                        courseTitle: text,
                        courseMetadata: {'creationTime': DateTime.now().toIso8601String()},
                      );

                      if (context.mounted) {
                        Navigator.of(context).push(
                          PageTransition(
                            type: PageTransitionType.bottomToTop,
                            duration: Durations.extralong3,
                            reverseDuration: Durations.medium1,
                            curve: CustomCurves.snappySpring,
                            child: ModifyCourse(appUiStateProvider, courseModel: courseModel),
                          ),
                        );
                      }
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
