import 'dart:developer';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroine/heroine.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/core/routes/routes.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/domain/models/course_model/sub/course_content.dart';
import 'package:slides_sync/shared/components/app_bar_container.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/styles/colors.dart';

class DocumentViewer extends ConsumerWidget {
  final CourseContent content;
  const DocumentViewer({super.key, required this.content});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        
        //  if(didPop) {
        //   log("Tring to pop");
        //    rootNavigatorKey.currentContext?.pop();
        //  }
      },
      child: AnnotatedRegion(
        value: UiUtils.getSystemUiOverlayStyle(context.scaffoldBackgroundColor, context.isDarkMode),
        child: Heroine(
          tag: "CourseMaterialGridCard=>ContentViewGate=>${content.contentId}",
          spring: Spring.withDamping(durationSeconds: 0.4),
          adjustToRouteTransitionDuration: true,
          child: Scaffold(
            appBar: AppBarContainer(
              appBarHeight: kToolbarHeight + 12,
              padding: EdgeInsets.zero,
              scaffoldBgColor: ref.theme.altBackgroundPrimary.withValues(
                alpha: 0.4,
              ),
              child: Stack(
                children: [
                  Positioned.fill(child: LinearProgressIndicator(color: AppColors.primary(context).withAlpha(20), value: 0.6, backgroundColor: Colors.transparent,)),
                  Positioned.fill(child: AppBarContainerChild(context.isDarkMode, onBackButtonClicked: () {
                    
                  }, title: "Document 1",)),
          
                ],
              ),
            ),
          
            floatingActionButton: FloatingActionButton(onPressed: (){}, shape: const CircleBorder(), child: Icon(Iconsax.menu, color: AppColors.primaryText(context),),),
          
          
            body: Container(),
          ),
        ),
      ),
    );
  }
}