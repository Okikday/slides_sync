import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/features/manage_all/manage_contents/presentation/actions/add_contents_actions.dart';

class AddContentsBsProvider {
  static final StateProvider<AppClipboardData?> lastClipboardData = StateProvider((cb) => null);
  static final StateProvider<OverlayEntry?> addFromClipboardOverlayEntry = StateProvider((cb) => null);
}