import 'package:flutter/material.dart';

class ComponentWidgets {
  static backButton(BuildContext context, {Color? backgroundColor}) {
    backgroundColor ??= Colors.lightBlueAccent.withAlpha(40);
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Colors.grey),
      style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(backgroundColor)),
    );
  }
}
