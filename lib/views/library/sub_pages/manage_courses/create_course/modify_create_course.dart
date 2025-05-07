import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/app/states/app_ui_state.dart';
import 'package:slides_sync/components/widgets/app_bar_container.dart';
import 'package:slides_sync/components/widgets/component_widgets.dart';
import 'package:slides_sync/use_cases/library/library_ui_funcs.dart';
import 'package:slides_sync/use_cases/library/models/course_model.dart';
import 'package:slides_sync/views/library/sub_pages/manage_courses/create_course/modify_create_course/modify_create_course_header.dart';

class ModifyCreateCourse extends ConsumerStatefulWidget {
  final NotifierProvider<AppUiState, AppUiModel> appUiStateProvider;
  final CourseModel courseModel;
  const ModifyCreateCourse(this.appUiStateProvider, {super.key, required this.courseModel});

  @override
  ConsumerState createState() => _ModifyCreateCourseState();
}

class _ModifyCreateCourseState extends ConsumerState<ModifyCreateCourse> {
  @override
  Widget build(BuildContext context) {
    final AppUiModel appUiModel = ref.watch(appUiStateProvider);
    final Color scaffoldBgColor = Theme.of(context).scaffoldBackgroundColor;
    final CourseModel courseModel = widget.courseModel;

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
                  Expanded(child: CustomText("Modify Course", fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ),
        
        floatingActionButton: FloatingActionButton.small(onPressed: (){}, shape: CircleBorder(), child: Icon(Iconsax.arrow_up_1),),

        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomScrollView(
            slivers: [
              ModifyCreateCourseHeader(title: courseModel.courseTitle, description: courseModel.description),

              SliverToBoxAdapter(child: ConstantSizing.columnSpacingExtraLarge),

              PinnedHeaderSliver(
                  child: ColoredBox(
                    color: scaffoldBgColor,
                    child: Row(
                                    children: [
                    Expanded(child: CustomText("Collections", fontSize: 18, fontWeight: FontWeight.bold)),

                    CustomElevatedButton(backgroundColor: Colors.transparent, shape: CircleBorder(), child: Icon(Iconsax.add_circle_copy)),

                    CustomElevatedButton(
                      contentPadding: EdgeInsets.all(8),
                      backgroundColor: Colors.lightBlueAccent.withAlpha(40),
                      shape: CircleBorder(),
                      child: Icon(Iconsax.arrow_up_copy, size: 20, color: appUiModel.isDarkMode ? Colors.white : Colors.black),
                    ),
                                    ],
                                  ),
                  )),
              SliverList.list(
                children: [
                  ConstantSizing.columnSpacingMedium,
                  _buildListButton("Textbooks", appUiModel.isDarkMode, onTap: () {}),
                ],
              ),

              SliverToBoxAdapter(child: ConstantSizing.columnSpacingExtraLarge),

              PinnedHeaderSliver(
                  child: ColoredBox(
                    color: scaffoldBgColor,
                    child: Row(
                      children: [
                        Expanded(child: CustomText("Slides", fontSize: 18, fontWeight: FontWeight.bold)),

                        CustomElevatedButton(backgroundColor: Colors.transparent, shape: CircleBorder(), child: Icon(Iconsax.add_circle_copy)),

                        CustomElevatedButton(
                          contentPadding: EdgeInsets.all(8),
                          backgroundColor: Colors.lightBlueAccent.withAlpha(40),
                          shape: CircleBorder(),
                          child: Icon(Iconsax.arrow_up_copy, size: 20, color: appUiModel.isDarkMode ? Colors.white : Colors.black),
                        ),
                      ],
                    ),
                  )),
              SliverList.list(
                children: [
                  ConstantSizing.columnSpacingMedium,
                  _buildListButton("Textbooks", appUiModel.isDarkMode, onTap: () {}),
                  ConstantSizing.columnSpacingMedium,
                  _buildListButton("Slides", appUiModel.isDarkMode, onTap: () {}),
                ],
              ),

              // CustomText("Contents", fontWeight: FontWeight.bold, fontSize: 18,),
              // ConstantSizing.columnSpacingMedium,
              // _buildListButton("New Content", appUiModel.isDarkMode, onTap: (){}),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildListButton(String title, bool isDarkMode, {required void Function() onTap}) {
  return InkWell(
    borderRadius: BorderRadius.circular(12),
    overlayColor: WidgetStatePropertyAll(Colors.deepPurple.withAlpha(40)),
    onTap: onTap,
    child: Container(
      decoration: LibraryUiFuncs.getBoxDecorationStyle(isDarkMode),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),

      child: Row(children: [Icon(Iconsax.add_circle, size: 30), ConstantSizing.rowSpacingMedium, Expanded(child: CustomText(title))]),
    ),
  );
}

// CircleAvatar(radius: 40, child: Icon(Iconsax.book),),
// ConstantSizing.columnSpacingMedium,
// CustomText("Introduction to Java Programming", fontSize: 20, fontWeight: FontWeight.bold,),
// ConstantSizing.columnSpacingMedium,
// CustomText("Add description", textAlign: TextAlign.center, color: Colors.deepPurple, ),
