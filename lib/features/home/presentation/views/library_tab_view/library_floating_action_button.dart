import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/shared/strings/routes_strings.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';

class LibraryFloatingActionButton extends ConsumerWidget {
  const LibraryFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () {
        context.push(RoutesStrings.manageCoursesView);
      },
      elevation: 40,
      backgroundColor: context.isDarkMode ? Colors.lightBlueAccent.withAlpha(40) : Colors.lightBlueAccent.withAlpha(80),
      shape: CircleBorder(),

      child: CircleAvatar(radius: 25, backgroundColor: Colors.deepPurple, child: Icon(Iconsax.setting_4, color: Colors.white)),
    );
  }
}
