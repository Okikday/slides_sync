import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:slides_sync/app.dart';
import 'package:slides_sync/app/states/app_ui_state.dart';
import 'package:slides_sync/components/widgets/app_bar_container.dart';
import 'package:slides_sync/components/widgets/component_widgets.dart';
import 'package:slides_sync/views/library/sub_pages/manage_courses/create_course_view.dart';

class ManageCoursesPage extends ConsumerWidget {
  final NotifierProvider<AppUiState, AppUiModel> appUiStateProvider;
  const ManageCoursesPage(this.appUiStateProvider, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              children: [
                ConstantSizing.columnSpacing(64),

                ...manageButton(
                  Iconsax.add_copy,
                  "Create Course",
                  onTap: () {
                    Navigator.of(context).push(
                      PageTransition(
                        type: PageTransitionType.rightToLeftWithFade,
                        duration: Durations.extralong3,
                        reverseDuration: Durations.medium1,
                        curve: CustomCurves.snappySpring,
                        child: CreateCourseView(appUiStateProvider),
                      ),
                    );
                  },
                ),

                ConstantSizing.columnSpacingExtraLarge,

                ...manageButton(Icons.explore_outlined, "Explore Online Library", onTap: () {}),

                ConstantSizing.columnSpacingExtraLarge,

                ...manageButton(Iconsax.document_download_copy, "Get file(s) from link", onTap: () {}),

                ConstantSizing.columnSpacingExtraLarge,
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> manageButton(IconData icon, String title, {required void Function() onTap}) {
    return [
      CustomElevatedButton(
        onClick: onTap,
        shape: CircleBorder(),
        overlayColor: Colors.lightBlueAccent.withAlpha(100),
        pixelHeight: 100,
        pixelWidth: 100,
        backgroundColor: Colors.lightBlueAccent.withAlpha(80),
        textColor: Colors.white,
        borderRadius: 24,
        child: Icon(icon, size: 64),
      ),
      ConstantSizing.columnSpacingSmall,
      CustomText(title),
    ];
  }
}
