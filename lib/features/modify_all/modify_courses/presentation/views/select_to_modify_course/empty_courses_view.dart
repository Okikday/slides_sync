import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:slides_sync/features/create_all/create_course/presentation/views/create_course_view.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class EmptyCoursesView extends StatelessWidget {
  const EmptyCoursesView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
    
                  Navigator.push(
                    context,
                    CupertinoSheetRoute(
                      builder: (context) {
                        return CreateCourseView();
                      },
                    ),
                  );
                },
                backgroundColor: Colors.lightBlueAccent.withAlpha(40),
                borderRadius: 12,
                pixelHeight: 44,
                label: "Create your course",
                textSize: 15,
                textColor: context.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
