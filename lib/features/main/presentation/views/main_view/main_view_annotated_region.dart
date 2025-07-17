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
        statusBarColor: ref.watch(isMainScrolledProvider) ? context.theme.colorScheme.secondary.withAlpha(100) : context.scaffoldBackgroundColor,
        statusBarBrightness: brightness,
        statusBarIconBrightness: brightness,
        systemNavigationBarIconBrightness: brightness,
        systemNavigationBarColor: context.theme.cardColor,
      ),

      child: child,
    );
  }
}
