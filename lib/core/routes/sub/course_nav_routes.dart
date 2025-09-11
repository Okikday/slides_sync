import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:slides_sync/core/routes/routes.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/features/content_viewer/presentation/views/content_view_gate.dart';
import 'package:slides_sync/features/content_viewer/presentation/views/viewers/pdf_document_viewer/pdf_document_viewer.dart';
import 'package:slides_sync/features/content_viewer/presentation/views/viewers/image_viewer.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_details_view.dart';
import 'package:slides_sync/core/routes/routes_strings.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_materials_view.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class CourseNavRoutes {
  static List<GoRoute> routes = [
    //COURSE NAVIGATION

    // COURSE DETAILS VIEW
    GoRoute(
      path: RoutesStrings.courseDetailsView,

      pageBuilder:
          (context, state) => defaultTransition(
            state.pageKey,
            defaultIncoming: TransitionType.fade,
            // defaultIncomingDuration: Durations.medium2,
            // defaultIncomingCurve: Curves.fastEaseInToSlowEaseOut,
            child: CourseDetailsView(course: state.extra as Course),
          ),
      routes: [
        GoRoute(
          path: RoutesStrings.courseMaterialsView,
          pageBuilder:
              (context, state) => defaultTransition(
                state.pageKey,
                child: CourseMaterialsView(collection: state.extra as CourseCollection),
              ),
          routes: [
            GoRoute(
              path: RoutesStrings.contentViewGate,
              pageBuilder:
                  (context, state) => PageAnimation.buildCustomTransitionPage(
                    state.pageKey,
                    type: TransitionType.fade,
                    duration: Durations.extralong1,
                    reverseDuration: Durations.medium1,
                    curve: CustomCurves.defaultIosSpring,
                    opaque: false,
                    barrierColor: context.theme.scaffoldBackgroundColor.withValues(alpha: 0.5),
                    child: ContentViewGate(content: state.extra as CourseContent),
                  ),
            ),
          ],
        ),
      ],
    ),

    // VIEWERS
    // DOCUMENT VIEWER ROUTE
    GoRoute(
      path: RoutesStrings.documentViewer,
      pageBuilder:
          (context, state) => PageAnimation.buildCustomTransitionPage(
            state.pageKey,
            type: TransitionType.rightToLeftWithFade,
            duration: Durations.extralong1,
            reverseDuration: Durations.medium1,
            curve: CustomCurves.defaultIosSpring,
            child: PdfDocumentViewer(content: state.extra as CourseContent),
          ),
    ),
    GoRoute(
      path: RoutesStrings.imageViewer,
      pageBuilder:
          (context, state) => PageAnimation.buildCustomTransitionPage(
            state.pageKey,
            type: TransitionType.rightToLeftWithFade,
            duration: Durations.extralong1,
            reverseDuration: Durations.medium1,
            curve: CustomCurves.defaultIosSpring,
            child: ImageViewer(content: state.extra as CourseContent),
          ),
    ),
  ];
}
