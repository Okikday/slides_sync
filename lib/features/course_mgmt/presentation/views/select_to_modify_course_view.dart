import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/usecases/app_navigator.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/features/course_mgmt/data/models/course_model/course_model.dart';
import 'package:slides_sync/features/course_mgmt/presentation/viewmodels/notifiers/select_to_modify_course/get_courses_notifier.dart';
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
  late final AsyncNotifierProvider<GetCoursesAsyncNotifier, List<CourseModel>> asyncGetCoursesProvider;

  @override
  void initState() {
    super.initState();
    asyncGetCoursesProvider = AsyncNotifierProvider<GetCoursesAsyncNotifier, List<CourseModel>>(GetCoursesAsyncNotifier.new);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<CourseModel>> futureCourses = ref.watch(asyncGetCoursesProvider);

    return AnnotatedRegion(
      value: UiUtils.getSystemUiOverlayStyle(context.scaffoldBackgroundColor, context.isDarkMode),
      child: Scaffold(
        appBar: AppBarContainer(
          appBarHeight: kToolbarHeight + 12,
          padding: EdgeInsets.zero,
          child: AppBarContainerChild(context.isDarkMode, title: 'Select course to modify'),
        ),
        body: CustomScrollView(
          slivers: [
            futureCourses.when(
              data: (data) {
                final isDarkMode = context.isDarkMode;

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
                        syncImagePath: courseModel.imagePath,
                        onTap: () {
                          AppNavigator.to(context).modifyCoursePageRoute(courseModel);
                        },
                      ),
                    );
                  },
                );
              },
              error: (_, __) => SliverToBoxAdapter(child: const Icon(Icons.error_rounded)),
              loading: () => SliverToBoxAdapter(child: LoadingView(msg: "Loading Courses...")),
            ),
          ],
        ),
      ),
    );
  }
}
