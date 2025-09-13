import 'dart:developer';
import 'dart:ui';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/routes/app_route_navigator.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/shared/assets/assets.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/styles/colors.dart';
import 'package:slides_sync/test/file_manager_page.dart';

class ExploreTabView extends ConsumerStatefulWidget {
  const ExploreTabView({super.key});

  @override
  ConsumerState<ExploreTabView> createState() => _ExploreTabViewState();
}

class _ExploreTabViewState extends ConsumerState<ExploreTabView> {
  @override
  Widget build(BuildContext context) {
    final theme = ref.theme;

    return Stack(
      children: [
        Positioned.fill(
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(
                Assets.images.wpImage1,
                fit: BoxFit.cover,
                color: theme.background.withAlpha(200),
                colorBlendMode: BlendMode.colorBurn,
              ),
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomElevatedButton(
                backgroundColor: theme.primary,
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                onClick: () {
                  Navigator.push(context, PageAnimation.pageRouteBuilder(FileManagerPage()));
                },
                child: CustomText(
                  'Welcome to Explore',
                  color: ref.theme.onPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (kDebugMode)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomElevatedButton(
                    backgroundColor: theme.primary,
                    onClick: () {
                      Navigator.push(context, PageAnimation.pageRouteBuilder(FileManagerPage()));
                    },
                    child: CustomText('File Manager page', color: ref.theme.onBackground),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
