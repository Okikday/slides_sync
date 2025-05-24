import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/core/usecases/app_navigator.dart';
import 'package:slides_sync/core/utils/app_ui_state.dart';
import 'package:slides_sync/features/course_mgmt/presentation/views/manage_courses/manage_course_button.dart';
import 'package:slides_sync/shared/components/app_bar_container.dart';
import 'package:slides_sync/shared/components/component_widgets.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';

class ManageCoursesPage extends ConsumerWidget {
  const ManageCoursesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    

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
                  Expanded(child: CustomText("Manage Courses", fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ),

        body: SingleChildScrollView(
          child: Align(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 36,
              children:
                  [
                    ConstantSizing.columnSpacingExtraLarge,
                    ManageCourseButton(
                      iconData: Iconsax.add_copy,
                      title: "Create Course",
                      onTap: () {
                        AppNavigator.to(context).createCoursePageRoute();
                      },
                    ),

                    ManageCourseButton(iconData: Iconsax.edit_2_copy, title: "Modify existing Courses", onTap: () {
                      // Select course to modify view
                      AppNavigator.to(context).modifyExistingCoursesRoute();
                    }),

                    ManageCourseButton(iconData: Icons.explore_outlined, title: "Explore Online Library", onTap: () {}),
                  ],
            ),
          ),
        ),
      ),
    );
  }
}
