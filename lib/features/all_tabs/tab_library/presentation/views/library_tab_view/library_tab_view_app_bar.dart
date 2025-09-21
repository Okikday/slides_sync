import 'dart:ui';
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/core/global_providers/global_providers.dart';
import 'package:slides_sync/core/storage/hive_data/app_hive_data.dart';
import 'package:slides_sync/core/storage/hive_data/hive_data_paths.dart';
import 'package:slides_sync/core/utils/result.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/actions/courses_view_actions.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/providers/courses_view_providers.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/providers/library_tab_view_providers.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/library_search_view/library_search_view.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/library_tab_view_app_bar/build_button.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/library_tab_view_app_bar/library_tab_view_filter_button.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/library_tab_view_app_bar/library_tab_view_header_text.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/library_tab_view_app_bar/library_tab_view_layout_button.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/library_tab_view_app_bar/library_tab_view_search_button.dart';
import 'package:slides_sync/shared/assets/assets.dart';
import 'package:slides_sync/shared/common_widgets/app_popup_menu_button.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/styles/theme/app_theme_model.dart';

class LibraryTabViewAppBar extends ConsumerWidget {
  const LibraryTabViewAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const double maxHeight = 220;
    // const double maxHeight = 200;
    const double minHeight = kToolbarHeight;
    final theme = ref.theme;

    return SliverAppBar(
      pinned: true,
      collapsedHeight: minHeight,
      expandedHeight: maxHeight,
      surfaceTintColor: Colors.transparent,
      backgroundColor: theme.background.withAlpha(200),

      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        expandedTitleScale: 1.0,
        titlePadding: EdgeInsets.all(0),
        background: DecoratedBox(
          decoration: BoxDecoration(
            color: theme.background.withAlpha(200),
            borderRadius: BorderRadius.circular(24),
            image: DecorationImage(
              image: Assets.images.eduElements.asImageProvider,
              repeat: ImageRepeat.repeat,
              // fit: BoxFit.cover,
              opacity: 0.02,
              colorFilter: ColorFilter.mode(theme.primaryColor, BlendMode.srcIn),
            ),
          ),
        ),
        title: GestureDetector(
          onTap: () {
            PrimaryScrollController.of(
              context,
            ).animateTo(0, duration: Durations.extralong1, curve: CustomCurves.defaultIosSpring);
          },
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Stack(
                children: [
                  ColoredBox(
                    color: Colors.transparent,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Expanded(child: SizedBox()),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child: Row(
                            spacing: 8.0,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(child: SizedBox()),
                              LibraryTabViewSearchButton(),
                              Container(
                                decoration: BoxDecoration(
                                  color: theme.surface.withValues(alpha: 0.75),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    LibraryTabViewFilterButton(),
                                    LibraryTabViewLayoutButton(
                                      isListLayoutProvider: LibraryTabViewProviders.cardViewType,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  LibraryTabViewHeaderText(minHeight: minHeight, maxHeight: maxHeight),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
