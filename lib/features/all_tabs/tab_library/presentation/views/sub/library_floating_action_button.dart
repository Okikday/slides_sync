import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/core/routes/app_route_navigator.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/providers/library_tab_view_providers.dart';
import 'package:slides_sync/features/main/presentation/providers/main_providers.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class LibraryFloatingActionButton extends ConsumerWidget {
  const LibraryFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canShow =
        ref.watch(MainProviders.mainTabViewIndexProvider) == 1 &&
        ref.watch(LibraryTabViewProviders.scrollPosition) < 240;
    if (!canShow) return const SizedBox();
    final theme = ref.theme;
    return FloatingActionButton(
      onPressed: () {
        AppRouteNavigator.to(context).createCourseRoute();
      },
      tooltip: "Create course",
      shape: const CircleBorder(),
      backgroundColor: theme.primaryColor,
      child: ClipOval(
        child: ColoredBox(
          color: context.theme.colorScheme.primary,
          child: SizedBox.square(dimension: 51, child: Icon(Iconsax.add_copy, color: theme.onPrimary)),
        ),
      ),
    ).animate().scale(
      alignment: Alignment.bottomRight,
      curve: CustomCurves.bouncySpring,
      duration: Durations.extralong3,
    );
  }
}
