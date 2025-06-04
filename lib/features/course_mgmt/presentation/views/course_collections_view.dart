import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:slides_sync/core/models/file_location.dart';
import 'package:slides_sync/features/course_mgmt/data/models/course_model/course_model.dart';
import 'package:slides_sync/features/course_mgmt/data/models/course_model/sub/course_content_type.dart';
import 'package:slides_sync/features/course_mgmt/data/repos/course_repo.dart';
import 'package:slides_sync/features/course_mgmt/presentation/views/course_collections/collections_view_search_bar.dart';
import 'package:slides_sync/features/course_mgmt/presentation/views/course_collections/create_collection_bottom_sheet.dart';
import 'package:slides_sync/features/course_mgmt/presentation/views/course_collections/empty_collections_view.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_navigation/collection_card_tile.dart';
import 'package:slides_sync/shared/strings/icon_strings.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';
import 'package:slides_sync/shared/styles/colors.dart';
import 'package:slides_sync/test/dummy_slides.dart';

import '../../../../core/utils/ui_utils.dart';
import '../../../../shared/components/app_bar_container.dart';
import '../../../../shared/components/app_bar_container_child.dart';
import '../../../course_navigation/presentation/views/course_materials_view.dart';

class CourseCollectionsView extends ConsumerStatefulWidget {
  final CourseModel courseModel;

  const CourseCollectionsView({super.key, required this.courseModel});

  @override
  ConsumerState createState() => _CourseCollectionsViewState();
}

class _CourseCollectionsViewState extends ConsumerState<CourseCollectionsView> {
  late final StateProvider<CourseModel> modifyCourseProvider;
  late final StreamProvider<CourseModel?> syncCourseProvider;

  @override
  void initState() {
    super.initState();
    modifyCourseProvider = StateProvider((ref) => widget.courseModel);
    syncCourseProvider = StreamProvider((ref) => CourseRepo.watchCourseById(widget.courseModel.id));
  }

  @override
  Widget build(BuildContext context) {
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
            // trailing: Padding(
            //   padding: const EdgeInsets.only(right: 2),
            //   child: CustomElevatedButton(
            //     pixelHeight: 36,
            //     onClick: (){
                  
            //     },
            //     backgroundColor: Colors.deepPurple.withAlpha(80),
            //     child: Icon(Iconsax.more_copy, color: Colors.grey),
            //   ),
            // ),
          ),
        ),

        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: context.isDarkMode ? Color.fromARGB(255, 52, 33, 79) : Colors.deepPurple,
          onPressed: () async {
            await showModalBottomSheet(
              context: context,
              enableDrag: true,
              showDragHandle: false,
              backgroundColor: context.scaffoldBackgroundColor,
              shape: RoundedRectangleBorder(),
              builder: (context) {
                return CreateCollectionBottomSheet();
              },
            );
          },
          label: CustomText("Add a collection", fontWeight: FontWeight.w600, color: Colors.white),
          icon: Icon(Iconsax.add_copy, size: 32, color: Colors.white),
        ),

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
                itemCount: 4,
                itemBuilder: (context, index) {
                  final dummyCourseContent = CourseContent.create(
                    title: "title",
                    path: FileLocation(),
                    courseContentType: CourseContentType.image,
                  );
                  final collection = CourseSubCollection.create(
                    collectionTitle: "Textbooks",
                    courseContents: [dummyCourseContent, dummyCourseContent, dummyCourseContent],
                  );
                  // final CourseSubCollection collection = courseModel.subCollections[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: CollectionCardTile(
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
                    ).animate().moveY(begin: -20, end: 0).flipV(begin: 0.1, end: 0).fadeIn(),
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
