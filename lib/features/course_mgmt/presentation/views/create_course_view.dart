import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/core/usecases/app_navigator.dart';
import 'package:slides_sync/core/utils/app_ui_state.dart';
import 'package:slides_sync/features/course_mgmt/data/models/course_model/course_model.dart';
import 'package:slides_sync/features/course_mgmt/presentation/views/create_course_view/add_image_avatar.dart';
import 'package:slides_sync/features/course_mgmt/presentation/views/create_course_view/create_course_button.dart';
import 'package:slides_sync/features/course_mgmt/presentation/views/create_course_view/input_course_code_field.dart';
import 'package:slides_sync/features/course_mgmt/presentation/views/create_course_view/input_course_title_field.dart';
import 'package:slides_sync/shared/components/app_bar_container.dart';
import 'package:slides_sync/shared/components/app_bar_container_child.dart';
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
  late final TextEditingController courseCodeController;

  @override
  void initState() {
    super.initState();
    courseNameController = TextEditingController();
    courseCodeController = TextEditingController();
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
                    child: Column(
                      children: [
                        ConstantSizing.columnSpacingMedium,
                        
                        AddImageAvatar(),

                        ConstantSizing.columnSpacing(56),

                        InputCourseTitleField(courseNameController: courseNameController),

                        ConstantSizing.columnSpacingLarge,

                        InputCourseCodeField(courseCodeController: courseCodeController,),

                        ConstantSizing.columnSpacing(72),
                      ],
                    ),
                  ),
                ),

                CreateCourseButton(courseNameController: courseNameController),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




