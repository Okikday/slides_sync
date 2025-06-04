import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/usecases/app_navigator.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/features/course_mgmt/data/models/course_model/course_model.dart';
import 'package:slides_sync/features/course_mgmt/data/repos/course_repo.dart';
import 'package:slides_sync/features/course_mgmt/presentation/views/create_course_view.dart';
import 'package:slides_sync/features/course_mgmt/presentation/views/select_to_modify_course/plain_course_tile.dart';
import 'package:slides_sync/shared/components/app_bar_container.dart';
import 'package:slides_sync/shared/components/app_bar_container_child.dart';
import 'package:slides_sync/shared/components/loading_view.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';

class SelectToModifyCourseView extends ConsumerStatefulWidget {
  const SelectToModifyCourseView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SelectToModifyCourseViewState();
}

class _SelectToModifyCourseViewState extends ConsumerState<SelectToModifyCourseView> {
  late final StreamProvider<List<CourseModel>> streamedCoursesProvider;

  @override
  void initState() {
    super.initState();
    streamedCoursesProvider = StreamProvider((ref) => CourseRepo.watchAllCourses());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<CourseModel>> streamedCourses = ref.watch(streamedCoursesProvider);

    return AnnotatedRegion(
      value: UiUtils.getSystemUiOverlayStyle(Colors.transparent, context.isDarkMode).copyWith(statusBarIconBrightness: Brightness.light),
      child: Scaffold(
        appBar: AppBarContainer(
          appBarHeight: kToolbarHeight + 12,
          padding: EdgeInsets.zero,
          child: AppBarContainerChild(context.isDarkMode, title: 'Select course to modify'),
        ),
        body: CustomScrollView(
          slivers: [
            streamedCourses.when(
              data: (data) {
                final isDarkMode = context.isDarkMode;

                if (data.isEmpty) {
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

                return SliverList.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final courseModel = data[index];
                    return Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: PlainCourseTile(
                        isDarkMode: isDarkMode,
                        courseName: courseModel.courseName,
                        courseCode: courseModel.courseCode,
                        categoriesCount: courseModel.rootContents.length,
                        syncImagePath: courseModel.imageLocationJson,
                        onTap: () {
                          // Navigator.pop(context);

                          // Future.delayed(Durations.medium1);

                          AppNavigator.to(context).modifyCourseRoute(courseModel);
                        },
                      ),
                    );
                  },
                );
              },
              error:
                  (_, __) => SliverToBoxAdapter(
                    child: SizedBox(height: context.deviceHeight / 2 - 24, child: Center(child: const Icon(Icons.error_rounded))),
                  ),
              loading:
                  () => SliverToBoxAdapter(
                    child: SizedBox(height: context.deviceHeight / 2 - 48, child: Center(child: LoadingView(msg: "Loading Courses..."))),
                  ),
            ),

            SliverToBoxAdapter(child: ConstantSizing.columnSpacingMedium),
          ],
        ),
      ),
    );
  }
}
