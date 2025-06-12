import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:slides_sync/core/models/file_location.dart';
import 'package:slides_sync/data/models/course_model/course_model.dart';
import 'package:slides_sync/data/models/course_model/sub/course_content_type.dart';
import 'package:slides_sync/data/repos/course_repo.dart';
import 'package:slides_sync/features/modify_courses/presentation/views/modify_collections/add_collection_action_button.dart';
import 'package:slides_sync/features/modify_courses/presentation/views/modify_collections/collections_view_search_bar.dart';
import 'package:slides_sync/features/modify_courses/presentation/views/modify_collections/create_collection_bottom_sheet.dart';
import 'package:slides_sync/features/modify_courses/presentation/views/modify_collections/empty_collections_view.dart';
import 'package:slides_sync/features/modify_courses/presentation/views/modify_collections/collection_card_tile.dart';
import 'package:slides_sync/shared/strings/icon_strings.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';
import 'package:slides_sync/shared/styles/colors.dart';
import 'package:slides_sync/test/dummy_slides.dart';

import '../../../../core/utils/ui_utils.dart';
import '../../../../shared/components/app_bar_container.dart';
import '../../../../shared/components/app_bar_container_child.dart';
import '../../../course_navigation/presentation/views/course_materials_view.dart';

class ModifyCollectionsView extends ConsumerStatefulWidget {
  final CourseModel courseModel;

  const ModifyCollectionsView({super.key, required this.courseModel});

  @override
  ConsumerState createState() => _ModifyCollectionsViewState();
}

class _ModifyCollectionsViewState extends ConsumerState<ModifyCollectionsView> {
  late final StateProvider<CourseModel> modifyCourseProvider;
  late final StreamProvider<CourseModel?> syncCourseProvider;

  @override
  void initState() {
    super.initState();
    modifyCourseProvider = StateProvider((ref) => widget.courseModel);
    syncCourseProvider = StreamProvider((ref) => CourseRepo.watchCourseById(widget.courseModel.id));
  }

  void syncCourseWithStorage(AsyncValue<CourseModel?>? prev, AsyncValue<CourseModel?> next) {
    if (!next.hasValue) return;
    final CourseModel? currCourse = next.value;
    if (currCourse == null) return;
    ref.read(modifyCourseProvider.notifier).update((cb) => currCourse);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(syncCourseProvider, syncCourseWithStorage);

    final courseModel = widget.courseModel;

    return AnnotatedRegion(
      value: UiUtils.getSystemUiOverlayStyle(context.scaffoldBackgroundColor, context.isDarkMode),
      child: Scaffold(
        appBar: AppBarContainer(
          appBarHeight: kToolbarHeight + 12,
          padding: EdgeInsets.zero,
          child: AppBarContainerChild(
            context.isDarkMode,
            title: courseModel.courseName,
            
          ),
        ),

        floatingActionButton: AddCollectionActionButton(courseDbId: courseModel.id),

        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: ConstantSizing.columnSpacingLarge),

            PinnedHeaderSliver(child: CollectionsViewSearchBar()),

            SliverToBoxAdapter(child: ConstantSizing.columnSpacingExtraLarge),

            // if (courseModel.subCollections.isNotEmpty)
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 14.0),
              sliver: SliverList.builder(
                // itemCount: courseModel.subCollections.length,
                itemCount: courseModel.subCollections.length,
                itemBuilder: (context, index) {
                  final CourseSubCollection collection = courseModel.subCollections[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child:
                        CollectionCardTile(
                              title: collection.collectionTitle,
                              contentCount: collection.courseContents.length,
                              onTap: () {
                                if (context.mounted) {
                                  Navigator.of(context).push(
                                    PageTransition(
                                      type: PageTransitionType.rightToLeftWithFade,
                                      duration: Durations.extralong3,
                                      reverseDuration: Durations.medium1,
                                      curve: CustomCurves.snappySpring,
                                      child: CourseMaterialsView(),
                                    ),
                                  );
                                }
                              },
                            )
                            .animate()
                            .moveY(begin: -20, end: 0, curve: CustomCurves.defaultIosSpring, duration: Durations.extralong1)
                            .flipV(begin: 0.2, end: 0, curve: CustomCurves.defaultIosSpring, duration: Durations.extralong1)
                            .fadeIn(),
                  );
                },
              ),
            ),

            // else
            // EmptyCollectionsView(),
            SliverToBoxAdapter(child: ConstantSizing.columnSpacingMedium),

            // ),
          ],
        ),
      ),
    );
  }
}
