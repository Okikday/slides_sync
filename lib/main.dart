import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/app.dart';
import 'package:slides_sync/data/hive_data/hive_data.dart';

import 'app/states/app_ui_state.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await HiveData.instance.initialize();

  final container = ProviderContainer();
  container.read(appUiStateProvider.notifier).initAppUiState();

  runApp(UncontrolledProviderScope(
      container: container,
      child: const App()
  ));
}