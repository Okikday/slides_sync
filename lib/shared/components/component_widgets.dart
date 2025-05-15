import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ComponentWidgets {
  static backButton(BuildContext context, {Color? backgroundColor, void Function()? onPressed}) {
    backgroundColor ??= Colors.lightBlueAccent.withAlpha(40);
    return IconButton(
      onPressed: () {
        if(onPressed == null){
          context.pop();
          return;
        }
        onPressed();
      },
      icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Colors.grey),
      style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(backgroundColor)),
    );
  }
}
