import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/features/main/presentation/providers/main_providers.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class MainViewAnnotatedRegion extends ConsumerWidget {
  final Widget child;
  const MainViewAnnotatedRegion({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = context.isDarkMode;
    final Brightness brightness = isDarkMode ? Brightness.light : Brightness.dark;
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: ref.watch(isMainScrolledProvider) ? Colors.lightBlueAccent.withAlpha(100) : context.scaffoldBackgroundColor,
        statusBarBrightness: brightness,
        statusBarIconBrightness: brightness,
        systemNavigationBarIconBrightness: brightness,
        systemNavigationBarColor: (isDarkMode ? Color(0xff0e1d27) : Color(0xffd6ebf9)),
      ),

      child: child,
    );
  }
}
