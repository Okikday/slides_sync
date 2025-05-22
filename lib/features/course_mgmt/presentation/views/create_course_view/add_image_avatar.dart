import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';

class AddImageAvatar extends ConsumerWidget {
  const AddImageAvatar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClipOval(
          child: InkWell(
            customBorder: CircleBorder(),
            onTap: () {},
            child: CircleAvatar(
              backgroundColor: Colors.lightBlueAccent.withAlpha(40),
              radius: context.deviceHeight > context.deviceWidth ? context.deviceWidth * 0.4 / 2 : context.deviceHeight * 0.4 / 2,
              child: Icon(Iconsax.folder_add, size: 72)
                  .animate()
                  .scale(
                    begin: Offset(0.4, 0.4),
                    duration: Durations.extralong4,
                    delay: Durations.medium1,
                    curve: CustomCurves.bouncySpring,
                  )
                  .moveY(begin: -20, duration: Durations.extralong4, delay: Durations.medium1),
            ),
          ),
        )
        .animate()
        .moveY(begin: -20, duration: Durations.medium2, delay: Durations.medium1, curve: CustomCurves.decelerate)
        .fadeIn(begin: 0.3, duration: Durations.medium2, delay: Durations.medium1, curve: CustomCurves.decelerate);
  }
}
