import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/features/main/presentation/providers/main_providers.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/sub/manage_course_dialog.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/styles/colors.dart';

class LibraryFloatingActionButton extends ConsumerWidget {
  const LibraryFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canShow = ref.watch(mainTabViewIndexProvider) == 1;
   if(!canShow) return SizedBox.shrink();
    return FloatingActionButton(
      onPressed: () {
        CustomDialog.show(
          context,
          canPop: true,
          transitionType: TransitionType.fade,
          transitionDuration: Durations.short1,
          reverseTransitionDuration: Durations.medium1,
          curve: CustomCurves.decelerate,
          barrierColor: Colors.black.withAlpha(160),
          child: ManageCourseDialog(),
        );
      },
      elevation: 1.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(18)),
      backgroundColor: context.theme.colorScheme.secondary,

      child: ClipRSuperellipse(
        borderRadius: BorderRadius.circular(16.0),
        child: ColoredBox(
          color: context.theme.colorScheme.primary,
          child: SizedBox(width: 51, height: 51, child: Icon(Iconsax.setting_4, color: AppColors.lightenColor(context.theme.colorScheme.primary, 0.98))),
        ),
      ),
    );
  }
}
