import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class InputCourseCodeField extends ConsumerWidget {
   final AutoDisposeStateProvider<bool> isCourseCodeFieldVisible;
  final TextEditingController courseCodeController;
  const InputCourseCodeField({super.key, required this.courseCodeController, required this.isCourseCodeFieldVisible});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isCourseVisible = ref.watch(isCourseCodeFieldVisible);
    return AnimatedSize(
      duration: Durations.extralong4,
      curve: CustomCurves.bouncySpring,
      child: SizedBox(
        height: isCourseVisible ? 76 : 0,
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: CustomTextfield(
                controller: courseCodeController,
                backgroundColor: ref.theme.altBackgroundPrimary,
                cursorColor: ref.theme.primaryText,
                selectionHandleColor: ref.theme.primaryColor,
                autoDispose: false,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color:
                        context.isDarkMode
                            ? context.theme.colorScheme.secondary.withAlpha(80)
                            : ref.theme.primaryColor.withAlpha(20),
                  ),
                ),
                onTapOutside: () {},
                constraints: BoxConstraints(maxWidth: 200),
                pixelHeight: 60,
                inputContentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                hint: "Optional course code",
                inputTextStyle: TextStyle(
                  fontSize: 16,
                  color: ref.theme.primaryText,
                ),
              ),
            ),
        
            Positioned(
              left: 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 32,
                    width: 4,
                    decoration: BoxDecoration(color: Colors.grey.withAlpha(40), borderRadius: BorderRadius.circular(12)),
                  ),
                  Container(
                    width: (context.deviceWidth - 48 - 200).clamp(80, context.deviceWidth),
                    height: 4,
                    decoration: BoxDecoration(color: Colors.grey.withAlpha(40), borderRadius: BorderRadius.circular(12)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
