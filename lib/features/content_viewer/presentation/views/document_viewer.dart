import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/shared/components/app_bar_container.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/styles/colors.dart';

class DocumentViewer extends ConsumerWidget {
  const DocumentViewer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnnotatedRegion(
      value: UiUtils.getSystemUiOverlayStyle(context.scaffoldBackgroundColor, context.isDarkMode),
      child: Scaffold(
        appBar: AppBarContainer(
          appBarHeight: kToolbarHeight + 12,
          padding: EdgeInsets.zero,
          scaffoldBgColor: ref.theme.altBackgroundPrimary.withValues(
            alpha: 0.4,
          ),
          child: Stack(
            children: [
              Positioned.fill(child: LinearProgressIndicator(color: AppColors.primary(context).withAlpha(20), value: 0.6, backgroundColor: Colors.transparent,)),
              Positioned.fill(child: AppBarContainerChild(context.isDarkMode, title: "Document 1",)),

            ],
          ),
        ),

        floatingActionButton: FloatingActionButton(onPressed: (){}, shape: const CircleBorder(), child: Icon(Iconsax.menu, color: AppColors.primaryText(context),),),


        body: Container(),
      ),
    );
  }
}