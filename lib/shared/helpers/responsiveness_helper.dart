import 'package:flutter/widgets.dart';
import 'package:slides_sync/shared/helpers/device_helper.dart';

class ResponsivenessHelper {
  /// Resolve Horizontal Padding...
  static double resolveHPadding(BuildContext context, [Size? deviceSize]) {
    final DeviceType deviceType = DeviceHelper.getDeviceType(context);
    final Size size;
    size = deviceSize ?? (MediaQuery.of(context).size);
    final double width = size.width;

    double horizontalPadding;

    double responsivePadding(double width, {double base = 24, double max = 64}) => (width * 0.06).clamp(base, max);

    switch (deviceType) {
      case DeviceType.mobile:
      case DeviceType.webMobile:
        horizontalPadding = responsivePadding(width, base: 20, max: 28);
        break;
      case DeviceType.tablet:
      case DeviceType.webTablet:
        horizontalPadding = responsivePadding(width, base: 24, max: 40);
        break;
      case DeviceType.desktop:
      case DeviceType.webDesktop:
        horizontalPadding = responsivePadding(width, base: 32, max: 96);
        break;
      default:
        horizontalPadding = 24;
    }

    return horizontalPadding;
  }

  static double resolveSquareButtonSize(BuildContext context) {
    final DeviceType deviceType = DeviceHelper.getDeviceType(context);
    final Size size = MediaQuery.of(context).size;
    final double width = size.width;

    double base, max, scaleFactor;

    switch (deviceType) {
      case DeviceType.mobile:
      case DeviceType.webMobile:
        base = 48;
        max = 64;
        scaleFactor = 0.125;
        break;
      case DeviceType.tablet:
      case DeviceType.webTablet:
        base = 56;
        max = 72;
        scaleFactor = 0.11;
        break;
      case DeviceType.desktop:
      case DeviceType.webDesktop:
        base = 64;
        max = 96;
        scaleFactor = 0.1;
        break;
      default:
        base = 48;
        max = 64;
        scaleFactor = 0.125;
    }

    final double calculated = width * scaleFactor;
    return calculated.clamp(base, max);
  }
}
