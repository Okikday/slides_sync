import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class PdfScrollbarOverlay extends ConsumerWidget {
  final String pageProgress;
  const PdfScrollbarOverlay({super.key, required this.pageProgress});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.theme;
    return Transform.translate(
      offset: Offset(16, 0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Page indicator container
          Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey[800],
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              constraints: const BoxConstraints(minWidth: 60),
              child: Text(
                pageProgress,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
          ),
      
          SizedBox.square(
            dimension: 48,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.surface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(-2, 2)),
                ],
              ),
              child: Center(child: Icon(Icons.drag_indicator, color: theme.onSurface, size: 24)),
            ),
          ),
        ],
      ),
    );
  }
}
