import 'dart:ui';
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/providers/library_tab_view_providers.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/library_tab_view_app_bar/library_tab_view_header_text.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/library_tab_view_app_bar/library_tab_view_layout_button.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/library_tab_view_app_bar/library_tab_view_search_button.dart';
import 'package:slides_sync/shared/assets/assets.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class LibraryTabViewAppBar extends ConsumerWidget {
  const LibraryTabViewAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // const double maxHeight = 240;
    const double maxHeight = 200;
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

                        // ALL COURSES HEADER
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child: Row(
                            spacing: 8.0,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(child: SizedBox()),
                              LibraryTabViewSearchButton(onTap: () {}),
                              LibraryTabViewLayoutButton(isListLayoutProvider: LibraryTabViewProviders.isListLayout,),
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
