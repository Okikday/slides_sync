import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:slides_sync/features/content_viewer/domain/services/drive_browser.dart';
import 'firebase_options.dart';
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
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AppHiveData.instance.initialize();
  final dotenv = DotEnv();
  await dotenv.load();
  // Get Drive API KEY
  final String? driveApiKey = dotenv.env['DRIVE_API_KEY'];
  if (driveApiKey != null) await DriveBrowser.initialize(apiKey: driveApiKey);

  if (!kIsWeb) await IsarData.initialize(collectionSchemas: isarSchemas);
  pdfrxFlutterInitialize();

  runApp(ProviderScope(child: const App()));
}
