
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/features/course_mgmt/presentation/views/create_course_view/add_image_avatar.dart';
import 'package:slides_sync/features/course_mgmt/presentation/views/create_course_view/create_course_button.dart';
import 'package:slides_sync/features/course_mgmt/presentation/views/create_course_view/input_course_code_field.dart';
import 'package:slides_sync/features/course_mgmt/presentation/views/create_course_view/input_course_title_field.dart';
import 'package:slides_sync/shared/components/app_bar_container.dart';
import 'package:slides_sync/shared/components/app_bar_container_child.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';

class CreateCourseView extends ConsumerStatefulWidget {
  const CreateCourseView({super.key});

  @override
  ConsumerState createState() => _CreateCourseViewState();
}

class _CreateCourseViewState extends ConsumerState<CreateCourseView> with SingleTickerProviderStateMixin {
  late final StateProvider<bool> isCourseCodeFieldVisible;
  late final TextEditingController courseNameController;
  late final TextEditingController courseCodeController;
  late final StateProvider<String?> courseImagePathProvider;
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    isCourseCodeFieldVisible = StateProvider((ref) => false);
    courseImagePathProvider = StateProvider((ref) => null);
    courseNameController = TextEditingController();
    courseCodeController = TextEditingController();
    scrollController = ScrollController();
  }
  
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: UiUtils.getSystemUiOverlayStyle(Colors.transparent, context.isDarkMode).copyWith(statusBarIconBrightness: Brightness.light),
      child: Scaffold(
        appBar: AppBarContainer(
          appBarHeight: kToolbarHeight + 12,
          padding: EdgeInsets.zero,
          child: AppBarContainerChild(context.isDarkMode, title: "Create course"),
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
                    controller: scrollController,
                    child: Column(
                      children: [
                        ConstantSizing.columnSpacingMedium,

                        AddImageAvatar(
                          courseImagePathProvider: courseImagePathProvider,
                        ),

                        ConstantSizing.columnSpacing(56),

                        InputCourseTitleField(
                          courseNameController: courseNameController,
                          isCourseCodeFieldVisible: isCourseCodeFieldVisible,
                          viewScrollController: scrollController
                        ),

                        ConstantSizing.columnSpacingLarge,

                        InputCourseCodeField(
                          courseCodeController: courseCodeController,
                          isCourseCodeFieldVisible: isCourseCodeFieldVisible,
                        ),

                        ConstantSizing.columnSpacing(72),
                      ],
                    ),
                  ),
                ),

                CreateCourseButton(
                  courseNameController: courseNameController,
                  courseCodeController: courseCodeController,
                  isCourseCodeFieldVisible: isCourseCodeFieldVisible,
                  courseImagePathProvider: courseImagePathProvider,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}