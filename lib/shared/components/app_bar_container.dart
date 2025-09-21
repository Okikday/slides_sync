import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

export 'app_bar_container_child.dart';

class AppBarContainer extends ConsumerWidget implements PreferredSizeWidget {
  final Color? scaffoldBgColor;
  final EdgeInsets? padding;
  final Widget child;
  final double? deviceWidth;
  final double? appBarHeight;
  final double? deviceHeight;

  const AppBarContainer({
    super.key,
    this.scaffoldBgColor,
    this.deviceHeight,
    this.deviceWidth,
    this.padding,
    required this.child,
    this.appBarHeight,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = context.screenSize;
    return _AppBarContainerWidget(
      key: key,
      deviceWidth: screenSize.width,
      deviceHeight: screenSize.height,
      appBarHeight: appBarHeight,
      scaffoldBgColor: scaffoldBgColor,
      padding: padding,
      child: child,
    );
  }

  @override
  Size get preferredSize {
    if (deviceWidth != null) return Size(deviceWidth!, appBarHeight ?? kToolbarHeight + 8);
    return Size.fromHeight(appBarHeight ?? kToolbarHeight + 8);
  }
}

class _AppBarContainerWidget extends ConsumerWidget {
  final double deviceWidth;
  final double deviceHeight;
  final double? appBarHeight;
  final Widget child;
  final EdgeInsets? padding;
  final Color? scaffoldBgColor;
  const _AppBarContainerWidget({
    super.key,
    required this.deviceWidth,
    required this.deviceHeight,
    this.appBarHeight,
    required this.child,
    this.padding,
    this.scaffoldBgColor,
  });

  EdgeInsets? _resolvePadding(double topPadding) {
    if (padding == null) {
      return EdgeInsets.only(
        left: deviceWidth > deviceHeight ? 24 : 12,
        right: deviceWidth > deviceHeight ? 24 : 12,
        top: topPadding + 4,
        bottom: 4,
      );
    } else if (padding == EdgeInsets.zero) {
      return EdgeInsets.only(top: topPadding + 4, bottom: 4);
    } else {
      return padding;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double topPadding = MediaQuery.paddingOf(context).top;
    return AnimatedContainer(
      curve: CustomCurves.decelerate,
      duration: Durations.medium2,
      width: deviceWidth,
      clipBehavior: Clip.hardEdge,
      height: (appBarHeight ?? (kToolbarHeight + 8 + topPadding)),
      decoration: BoxDecoration(
        color: scaffoldBgColor ?? context.scaffoldBackgroundColor,
        border: Border(bottom: BorderSide(color: ref.theme.bgLightenColor(.89, .11))),
      ),
      padding: _resolvePadding(topPadding),
      child: child,
    );
  }
}




// class _AppBarContainerWidget extends ConsumerWidget {
//   final double deviceWidth;
//   final double deviceHeight;
//   final double? appBarHeight;
//   final Widget child;
//   final EdgeInsets? padding;
//   final Color? scaffoldBgColor;
//   final double? topPadding;

//   const _AppBarContainerWidget({
//     super.key,
//     required this.deviceWidth,
//     required this.deviceHeight,
//     this.appBarHeight,
//     required this.child,
//     this.padding,
//     this.scaffoldBgColor,
//     this.topPadding,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final double topPadding = MediaQuery.paddingOf(context).top;
//     return ColoredBox(
//       color: scaffoldBgColor ?? context.scaffoldBackgroundColor,
//       child: Padding(
//         padding: EdgeInsets.only(top: this.topPadding ?? topPadding),
//         child: SizedBox(
//           width: deviceWidth,
//           height: appBarHeight ?? kToolbarHeight + topPadding,
//           child: Padding(
//             padding: padding ?? EdgeInsets.only(left: deviceWidth > deviceHeight ? 24 : 16, right: deviceWidth > deviceHeight ? 24 : 16),
//             child: child,
//           ),
//         ),
//       ),
//     );
//   }
// }