import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateCollectionBottomSheet extends ConsumerWidget {
  const CreateCollectionBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DraggableScrollableSheet(
      builder: (context, controller) {
        return Container();
      },
    );
  }
}
