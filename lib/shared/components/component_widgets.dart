import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class ComponentWidgets {
  static backButton(BuildContext context, {Color? backgroundColor, void Function()? onPressed}) {
    backgroundColor ??= context.theme.colorScheme.onSurface;
    return IconButton(
      color: context.theme.colorScheme.onTertiary,
      onPressed: () {
        if(onPressed == null){
          context.pop();
          return;
        }
        onPressed();
      },
      icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: context.theme.colorScheme.onTertiary),
      style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(backgroundColor)),
    );
  }
}
