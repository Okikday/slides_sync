import 'dart:convert';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/domain/models/file_details.dart';
import 'package:slides_sync/features/all_tabs/tab_home/presentation/actions/recent_dialog_actions.dart';
import 'package:slides_sync/features/all_tabs/tab_home/presentation/providers/home_tab_view_providers.dart';
import 'package:slides_sync/domain/models/progress_track_model.dart';
import 'package:slides_sync/features/all_tabs/tab_home/presentation/views/home_tab_view/home_body/recents_section/recent_dialog.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/styles/theme/app_theme_model.dart';
import 'package:slides_sync/shared/widgets/build_image_path_widget.dart';
import 'package:slides_sync/shared/components/loading_logo.dart';

import 'recent_list_tile.dart';

class RecentsSectionBody extends ConsumerWidget {
  const RecentsSectionBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.theme;
    final AsyncValue<List<ProgressTrackModel>> asyncProgressTrackValues = ref.watch(
      HomeTabViewProviders.recentProgressTrackProvider,
    );
    final rda = RecentDialogActions.of(ref);
    return asyncProgressTrackValues.when(
      data: (data) {
        if (data.isEmpty) {
          // return SliverToBoxAdapter(
          //   child: ListView(
          //     shrinkWrap: true,
          //     physics: const NeverScrollableScrollPhysics(),
          //     children: [

          //       ConstantSizing.columnSpacingHuge,
          //       Padding(
          //         padding: const EdgeInsets.symmetric(horizontal: 20.0),
          //         child: CustomElevatedButton(
          //           backgroundColor: theme.primaryColor,
          //           borderRadius: 12,
          //           pixelHeight: 44,
          //           label: "Explore Courses",
          //           textSize: 15,
          //           textColor: theme.onPrimary,
          //         ),
          //       ),
          //     ],
          //   ),
          // );
          return SliverToBoxAdapter(child: RecommendedSection(theme: theme));
        }
        return SliverPadding(
          padding: EdgeInsets.only(bottom: kBottomNavigationBarHeight + context.bottomPadding / 2),
          sliver: SliverList.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final content = data[index];
              final previewPath = jsonDecode(content.metadataJson)['previewPath'];
              return RecentListTile(
                isDarkMode: context.isDarkMode,
                tilePadding: context.hPadding5,
                dataModel: RecentListTileModel(
                  title: content.title ?? "No title",
                  subtitle:
                      content.description?.substring(0, content.description?.length).padRight(3, '.') ?? "No subtitle",
                  // extraContent: DummySlides.dummySlides[index]['extraContent'] as String? ?? "",
                  previewPath: previewPath,
                  progressLevel: ProgressLevel.neutral,
                  isStarred: false,
                  progress: content.progress?.clamp(0, 1.0),
                  onTapTile: () {
                    UiUtils.showCustomDialog(
                      context,
                      canPop: true,
                      blurSigma: Offset(2.0, 2.0),
                      transitionType: TransitionType.cupertinoDialog,
                      barrierColor: Colors.black.withValues(alpha: 0.6),
                      transitionDuration: Durations.short4,
                      reverseTransitionDuration: Durations.short4,
                      child: RecentDialog(
                        recentDialogModel: RecentDialogModel(
                          contentId: content.contentId,
                          imagePreview: BuildImagePathWidget(
                            fileDetails: FileDetails(filePath: previewPath ?? ''),
                            fallbackWidget: Icon(Iconsax.document_1, size: 26, color: ref.theme.primary),
                          ),
                          isStarred: false,
                          title: content.title ?? "No title",
                          description: content.description ?? "",
                          onContinueReading: () async {
                            await rda.onContinueReading(content.contentId);
                          },
                          onDelete: () async {
                            await rda.onRemoveFromRecents(content.contentId);
                          },
                        ),
                      ),
                    );
                  },
                  onLongTapTile: () {},
                ),
              );
            },
          ),
        );
      },
      error: (e, st) {
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 12,
              children: [
                Icon(Icons.error_rounded, size: 64, color: theme.primary),
                CustomText("Oops, we couldn't load up your recent reads", color: theme.onBackground),
              ],
            ),
          ),
        );
      },
      loading: () {
        return SliverToBoxAdapter(child: LoadingRecentsSection());
      },
    );
  }
}

class LoadingRecentsSection extends ConsumerWidget {
  const LoadingRecentsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          LoadingLogo(color: ref.theme.primary, rotate: false, size: context.deviceWidth * 0.4),
          CustomText(
            "Looking around for your recents...Where could they be?",
            color: ref.theme.onBackground,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class RecommendedSection extends StatelessWidget {
  const RecommendedSection({super.key, required this.theme});

  final AppThemeModel theme;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 220),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: CustomText("Recommended", fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                return SizedBox.square(
                  dimension: 180,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: 12,
                        right: 12,
                        child: Container(
                          width: 180,
                          height: 180,
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          margin: EdgeInsets.only(left: index == 0 ? 0 : 12),
                          decoration: BoxDecoration(
                            color: theme.surface.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        bottom: 12,
                        child: Container(
                          width: 180,
                          height: 180,
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          margin: EdgeInsets.only(left: index == 0 ? 0 : 12),
                          decoration: BoxDecoration(color: theme.surface, borderRadius: BorderRadius.circular(32)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(radius: 20, backgroundColor: AppThemeModel.lightenColor(theme.surface, 0.5)),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: CustomText(
                                  "Suggested $index",
                                  fontWeight: FontWeight.bold,
                                  color: theme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
