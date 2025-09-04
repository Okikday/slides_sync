import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/utils/app_navigator.dart';
import 'package:slides_sync/features/manage_all/manage_course/presentation/views/create_course_view.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class EmptyCoursesView extends ConsumerWidget {
  const EmptyCoursesView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: context.deviceHeight / 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
    
          spacing: 8.0,
          children: [
            CircleAvatar(radius: 26, child: Icon(Icons.info_rounded, size: 32)),
            CustomText("No Existing courses!"),
            ConstantSizing.columnSpacingLarge,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomElevatedButton(
                onClick: () {
                  Navigator.pop(context);
    
                  AppNavigator.to(context).createCourseRoute();
                },
                backgroundColor: ref.theme.altBackgroundPrimary,
                borderRadius: 12,
                pixelHeight: 44,
                label: "Create your course",
                textSize: 15,
                textColor: ref.theme.primaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
