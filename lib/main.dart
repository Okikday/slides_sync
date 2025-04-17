import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/app.dart';

import 'app/states/app_ui_state.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  container.read(appUiStateProvider.notifier).initAppUiState();

  runApp(UncontrolledProviderScope(
      container: container,
      child: const App()
  ));
}