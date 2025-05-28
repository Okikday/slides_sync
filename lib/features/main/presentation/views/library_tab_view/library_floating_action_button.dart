
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/features/main/presentation/views/library_tab_view/manage_course_dialog.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';

class LibraryFloatingActionButton extends ConsumerWidget {
  const LibraryFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () {
        LoadingDialog.showLoadingDialog(
          context,
          canPop: true,
          blurSigma: Offset(3.0, 3.0),
          transitionType: TransitionType.fade,
          transitionDuration: Durations.short1,
          reverseTransitionDuration: Durations.medium1,
          curve: CustomCurves.decelerate,
          barrierColor: Colors.black.withAlpha(100),
          loadingInfoWidget: ManageCourseDialog(),
        );
      },
      elevation: 1.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(18)),
      backgroundColor:  Colors.lightBlueAccent.withAlpha(80),
      

      child: ClipRSuperellipse(
        borderRadius: BorderRadius.circular(16.0),
        child: ColoredBox(
          color: context.isDarkMode ? Colors.lightBlueAccent : Colors.deepPurpleAccent,
          child: SizedBox(
            width: 51,
            height: 51,
            child: Icon(Iconsax.setting_4, color: context.isDarkMode ? Colors.black : Colors.white),
          ),
        ),
      ),
    );
  }
}









