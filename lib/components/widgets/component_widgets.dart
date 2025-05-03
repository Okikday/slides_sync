import 'package:flutter/material.dart';

class ComponentWidgets {
  static backButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Colors.grey),
      style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.lightBlueAccent.withAlpha(40))),
    );
  }
}
