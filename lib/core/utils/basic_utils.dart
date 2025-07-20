import 'dart:io';

import 'package:crypto/crypto.dart';

class BasicUtils {
  static Future<String> calculateFileHash(File file) async {
    final input = file.openRead(); // Stream<List<int>>
    final digest = await sha256.bind(input).first;
    return digest.toString();
  }
}
