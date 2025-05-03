import 'dart:ui';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/app/models/app_ui_model.dart';
import 'package:slides_sync/app/states/app_ui_state.dart';
import 'package:slides_sync/use_cases/library/library_ui_funcs.dart';
import 'package:slides_sync/views/library/sub_widgets/all_courses_header.dart';
import 'package:slides_sync/views/library/sub_widgets/all_courses_section.dart';
import 'package:slides_sync/views/library/sub_widgets/library_view_header.dart';

class LibraryView extends ConsumerWidget {
  final NotifierProvider<AppUiState, AppUiModel> appUiStateProvider;
  const LibraryView(this.appUiStateProvider, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appUiModel = ref.watch(appUiStateProvider);
    final double topPadding = MediaQuery.paddingOf(context).top;
    final Color scaffoldBgColor = Theme.of(context).scaffoldBackgroundColor;
    return NotificationListener(
      onNotification: (notification) => true,
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle(statusBarColor: scaffoldBgColor),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: ConstantSizing.columnSpacing(kToolbarHeight)),

            LibraryViewHeader(appUiModel: appUiModel),
            
            PinnedHeaderSliver(child: ConstantSizing.columnSpacing(topPadding)),

            // All Courses Header
            AllCoursesHeader(appUiModel: appUiModel, onTap: (){PrimaryScrollController.of(context).animateTo(0, duration: Durations.extralong1, curve: CustomCurves.defaultIosSpring);},),

            SliverToBoxAdapter(child: ConstantSizing.columnSpacingMedium),

            AllCoursesSection(appUiStateProvider),

            SliverToBoxAdapter(child: ConstantSizing.columnSpacing(kBottomNavigationBarHeight + topPadding + 24)),

            // TODO: there's be a My Books grid for custom additions or starred books
          ],
        ),
      ),
    );
  }


}














// Widget buildGridItem({required String title, required Widget icon}) {
//   return InkWell(
//     borderRadius: BorderRadius.circular(8),
//     onTap: () {},
//     child: Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             width: 60,
//             height: 60,
//             decoration: LibraryUiFuncs.getBoxDecorationStyle(appUiModel.isDarkMode),
//             child: icon,
//           ),
//           ConstantSizing.columnSpacingMedium,
//           CustomText(title, textAlign: TextAlign.center, fontSize: 12),
//         ],
//       ),
//     ),
//   );
// }