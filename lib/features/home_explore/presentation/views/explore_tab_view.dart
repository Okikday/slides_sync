import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExploreTabView extends ConsumerWidget {
  const ExploreTabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(child: CustomText("Explore"),);
  }
}
