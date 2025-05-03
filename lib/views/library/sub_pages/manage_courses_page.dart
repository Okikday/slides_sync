import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/components/widgets/app_bar_container.dart';
import 'package:slides_sync/components/widgets/component_widgets.dart';

class ManageCoursesPage extends ConsumerWidget {
  const ManageCoursesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBarContainer(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            ComponentWidgets.backButton(context),
            ConstantSizing.rowSpacingMedium,
            Expanded(child: CustomText("Manage Courses", fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomElevatedButton(label: "Explore Online Library", pixelHeight: 48, backgroundColor: Colors.deepPurple.withAlpha(80), textColor: Colors.white, borderRadius: 24,),
            ConstantSizing.columnSpacingMedium,
            CustomElevatedButton(label: "Auto-Scan folder for files", pixelHeight: 48, backgroundColor: Colors.deepPurple.withAlpha(80), textColor: Colors.white, borderRadius: 24,),
            ConstantSizing.columnSpacingMedium,
            CustomElevatedButton(label: "Create course", pixelHeight: 48, backgroundColor: Colors.deepPurple.withAlpha(80), textColor: Colors.white, borderRadius: 24,),
            ConstantSizing.columnSpacingMedium,
            CustomElevatedButton(label: "Get file from Link", pixelHeight: 48, backgroundColor: Colors.deepPurple.withAlpha(80), textColor: Colors.white, borderRadius: 24,),

          ],
        ),
      ),
    );
  }
}
