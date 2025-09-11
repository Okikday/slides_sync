import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/domain/models/course_model/sub/course_content.dart';

class ImageViewer extends ConsumerWidget {
  final CourseContent content;
  const ImageViewer({super.key, required this.content});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
  }
}
