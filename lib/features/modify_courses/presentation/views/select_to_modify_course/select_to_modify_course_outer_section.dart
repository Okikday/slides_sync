import 'dart:developer';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/utils/app_navigator.dart';
import 'package:slides_sync/data/models/course_model/course_model.dart';
import 'package:slides_sync/data/repos/course_repo.dart';
import 'package:slides_sync/features/modify_courses/presentation/views/select_to_modify_course/empty_courses_view.dart';
import 'package:slides_sync/features/modify_courses/presentation/views/select_to_modify_course/edit_course_tile.dart';
import 'package:slides_sync/features/modify_courses/presentation/views/select_to_modify_course_view.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/widgets/loading_view.dart';
import 'package:slides_sync/shared/widgets/selected_items_count_popup.dart';

class SelectToModifyCourseOuterSection extends ConsumerStatefulWidget {
  const SelectToModifyCourseOuterSection({
    super.key,
    required this.isSelecting,
    required this.selectedCoursesIdProvider,
    required this.selectedCoursesIdMap,
  });

  final bool isSelecting;
  final AutoDisposeStateProvider<Map<int, bool>> selectedCoursesIdProvider;
  final Map<int, bool> selectedCoursesIdMap;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SelectToModifyCourseOuterSectionState();
}

class _SelectToModifyCourseOuterSectionState extends ConsumerState<SelectToModifyCourseOuterSection> {
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
    final AsyncValue<List<CourseModel>> asyncStreamedCourses = ref.watch(streamedCoursesProvider);
    final selectedCoursesIdMap = widget.selectedCoursesIdMap;

    return CustomScrollView(
      slivers: [
        if (selectedCoursesIdMap.isNotEmpty && selectedCoursesIdMap.containsValue(true))
          PinnedHeaderSliver(child: SelectedItemsCountPopUp(selectedItemsCount: selectedCoursesIdMap.values.where((v) => v).length)),
        asyncStreamedCourses.when(
          data: (data) {
            final isDarkMode = context.isDarkMode;

            if (data.isEmpty) {
              return EmptyCoursesView();
            }

            return SliverList.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final courseModel = data[index];
                return Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                  child: EditCourseTile(
                    isDarkMode: isDarkMode,
                    courseName: courseModel.courseName,
                    courseCode: courseModel.courseCode,
                    categoriesCount: courseModel.subCollections.length,
                    selectionState: (
                      selected: selectedCoursesIdMap.isNotEmpty && selectedCoursesIdMap[courseModel.id] == true,
                      isSelecting: widget.isSelecting,
                    ),
                    syncImagePath: courseModel.imageLocationJson,
                    onTap: () {
                      if (widget.isSelecting) {
                        final selectedCoursesIdNotifier = ref.read(widget.selectedCoursesIdProvider.notifier);
                        if (selectedCoursesIdNotifier.state[courseModel.id] == null) {
                          selectedCoursesIdNotifier.update((cb) => {...selectedCoursesIdMap, courseModel.id: true});
                        } else {
                          selectedCoursesIdNotifier.update(
                            (cb) => {...selectedCoursesIdMap, courseModel.id: !selectedCoursesIdNotifier.state[courseModel.id]!},
                          );
                        }
                        if (!selectedCoursesIdNotifier.state.containsValue(true)) {
                          selectedCoursesIdNotifier.update((cb) => <int, bool>{});
                        }
                        return;
                      }
                      Navigator.of(context).pop();
                      AppNavigator.to(context).modifyCourseRoute(courseModel);
                    },
                    onSelected: () {
                      log("Selection");
                      final selectedCoursesIdNotifier = ref.read(widget.selectedCoursesIdProvider.notifier);
                      if (selectedCoursesIdNotifier.state[courseModel.id] == null) {
                        selectedCoursesIdNotifier.update((cb) => {...selectedCoursesIdMap, courseModel.id: true});
                      } else {
                        selectedCoursesIdNotifier.update(
                          (cb) => {...selectedCoursesIdMap, courseModel.id: !selectedCoursesIdNotifier.state[courseModel.id]!},
                        );
                      }
                      if (!selectedCoursesIdNotifier.state.containsValue(true)) {
                        selectedCoursesIdNotifier.update((cb) => <int, bool>{});
                      }
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
    );
  }
}
