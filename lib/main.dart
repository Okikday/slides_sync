import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/app.dart';
import 'package:slides_sync/core/storage/hive_data/app_hive_data.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:slides_sync/core/storage/isar_data/isar_data.dart';
import 'package:slides_sync/core/storage/isar_data/isar_schemas.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Firebase.initializeApp();
  await AppHiveData.instance.initialize();

  if (!kIsWeb) await IsarData.initialize(collectionSchemas: isarSchemas);

  runApp(ProviderScope(child: const App()));
}

