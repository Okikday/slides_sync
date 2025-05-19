
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/app.dart';
import 'package:slides_sync/data/hive_data/app_hive_data.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:slides_sync/data/isar_data/isar_data.dart';
import 'package:slides_sync/data/isar_data/isar_schemas.dart';

import 'core/utils/app_ui_state.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await AppHiveData.instance.initialize();
  await IsarData.initialize(collectionSchemas: isarSchemas);
  log("Initialized data...");



  runApp(ProviderScope(
      child: const App()
  ));
}
