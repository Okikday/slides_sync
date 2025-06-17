
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class AppBarContainer extends ConsumerWidget implements PreferredSizeWidget {
  final Color? scaffoldBgColor;
  final EdgeInsets? padding;
  final Widget child;
  final double? deviceWidth;
  final double? appBarHeight;
  final double? deviceHeight;
  final double? topPadding;

  const AppBarContainer({
    super.key,
    this.scaffoldBgColor,
    this.deviceHeight,
    this.deviceWidth,
    this.topPadding,
    this.padding,
    required this.child,
    this.appBarHeight = kToolbarHeight + 12,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = context.screenSize;
    return _AppBarContainerWidget(
      key: key,
      deviceWidth: screenSize.width,
      deviceHeight: screenSize.height,
      appBarHeight: appBarHeight,
      scaffoldBgColor: context.scaffoldBackgroundColor,
      padding: padding,
      topPadding: topPadding,
      child: child,
    );
  }

  @override
  Size get preferredSize {
    if (deviceWidth != null) return Size(deviceWidth!, appBarHeight ?? kToolbarHeight);
    return Size.fromHeight(appBarHeight ?? kToolbarHeight);
  }
}

class _AppBarContainerWidget extends ConsumerWidget {
  final double deviceWidth;
  final double deviceHeight;
  final double? appBarHeight;
  final Widget child;
  final EdgeInsets? padding;
  final Color? scaffoldBgColor;
  final double? topPadding;

  const _AppBarContainerWidget({
    super.key,
    required this.deviceWidth,
    required this.deviceHeight,
    this.appBarHeight,
    required this.child,
    this.padding,
    this.scaffoldBgColor,
    this.topPadding,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double topPadding = MediaQuery.paddingOf(context).top;
    return ColoredBox(
      color: context.scaffoldBackgroundColor,
      child: Padding(
        padding: EdgeInsets.only(top: this.topPadding ?? topPadding),
        child: SizedBox(
          width: deviceWidth,
          height: appBarHeight ?? kToolbarHeight + topPadding,
          child: Padding(
            padding: padding ?? EdgeInsets.only(left: deviceWidth > deviceHeight ? 24 : 16, right: deviceWidth > deviceHeight ? 24 : 16),
            child: child,
          ),
        ),
      ),
    );
  }
}
