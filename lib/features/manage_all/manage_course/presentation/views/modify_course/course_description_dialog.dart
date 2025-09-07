import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class CourseDescriptionDialog extends ConsumerStatefulWidget {
  final String description;

  const CourseDescriptionDialog({super.key, required this.description});

  @override
  ConsumerState createState() => _CourseDescriptionDialogState();
}

class _CourseDescriptionDialogState extends ConsumerState<CourseDescriptionDialog> {
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        Positioned.fill(child: GestureDetector(onTap: () => CustomDialog.hide(context))),
        Align(
          alignment: Alignment.center,
          child: Container(
            decoration: BoxDecoration(color: context.scaffoldBackgroundColor.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(12)),
            width: context.deviceWidth > context.deviceHeight ? context.deviceHeight * 0.85 : context.deviceWidth * 0.85,
            height: context.deviceWidth > context.deviceHeight ? context.deviceHeight * 0.75 : context.deviceWidth * 0.75,
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            child: RawScrollbar(
              mainAxisMargin: 0,
              thumbColor: Colors.grey.withAlpha(60),
              padding: EdgeInsets.only(top: 64),
              thumbVisibility: true,
              controller: scrollController,
              radius: Radius.circular(12),
              thickness: 8,
              interactive: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstantSizing.columnSpacingSmall,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Center(
                      child: CustomText(
                        "Course description",
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        textAlign: TextAlign.center,
                        color: ref.theme.onBackground,
                      ),
                    ),
                  ),
                  ConstantSizing.columnSpacingSmall,
                  Divider(color: context.isDarkMode ? Colors.lightBlue.withAlpha(40) : Colors.grey.withAlpha(40)),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      controller: scrollController,
                      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                      child: CustomText(
                        widget.description,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: ref.theme.onBackground,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
