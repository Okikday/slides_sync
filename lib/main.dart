import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/app.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  runApp(ProviderScope(child: const App()));
}