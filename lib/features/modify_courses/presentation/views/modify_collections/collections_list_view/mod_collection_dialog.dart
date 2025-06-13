import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/shared/components/dialogs/app_action_dialog.dart';
import 'package:slides_sync/shared/components/dialogs/app_customizable_dialog.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';

class ModCollectionDialog extends StatelessWidget {
  final String collectionTitle;
  final int courseDbId;
  final String collectionId;
  const ModCollectionDialog({super.key, required this.courseDbId, required this.collectionId, required this.collectionTitle});

  @override
  Widget build(BuildContext context) {
    return AppActionDialog(
      blurSigma: Offset(2, 2),
      backgroundColor: context.scaffoldBackgroundColor.withAlpha(180),
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0, top: 4.0),
        child: CustomText(collectionTitle, fontWeight: FontWeight.bold),
      ),
      actions: [
        AppActionDialogModel(title: "Rename", icon: Icon(Iconsax.edit_copy, color: Colors.deepPurpleAccent), onTap: () {}),
        // AppActionDialogModel(title: "Share", icon: Icon(Iconsax.share_copy), onTap: () {}),
      ],
    ).animate().scaleY(begin: 0.1, end: 1.0, curve: CustomCurves.bouncySpring, duration: Durations.extralong1);
  }
}
