import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/app.dart';
import 'package:slides_sync/data/hive_data/app_hive_data.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/states/app_ui_state.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await AppHiveData.instance.initialize();

  final container = ProviderContainer();
  container.read(appUiStateProvider.notifier).initAppUiState();

  runApp(UncontrolledProviderScope(
      container: container,
      child: const App()
  ));
}