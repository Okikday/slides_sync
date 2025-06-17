import 'package:flutter/widgets.dart';
import 'package:slides_sync/shared/helpers/device_helper.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class ResponsivenessHelper {
  EdgeInsets resolvePadding(BuildContext context) {
    final DeviceType deviceType = DeviceHelper.getDeviceType(context);
    final Size size = MediaQuery.of(context).size;
    final double width = size.width;

    double horizontalPadding;

    switch (deviceType) {
      case DeviceType.mobile:
      case DeviceType.webMobile:
        horizontalPadding = _responsivePadding(width, base: 20, max: 28);
        break;
      case DeviceType.tablet:
      case DeviceType.webTablet:
        horizontalPadding = _responsivePadding(width, base: 24, max: 40);
        break;
      case DeviceType.desktop:
      case DeviceType.webDesktop:
        horizontalPadding = _responsivePadding(width, base: 32, max: 96);
        break;
      default:
        horizontalPadding = 24;
    }

    return EdgeInsets.symmetric(horizontal: horizontalPadding);
  }

  double _responsivePadding(double width, {double base = 24, double max = 64}) {
    /// Grows gradually with screen size, but clamps to avoid too much padding
    final double calculated = width * 0.06;
    return calculated.clamp(base, max);
  }
}
