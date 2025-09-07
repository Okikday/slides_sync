import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

class BasicUtils {
  static Future<String> calculateFileHash(File file) async {
    final input = file.openRead(); // Stream<List<int>>
    final digest = await sha256.bind(input).first;
    return digest.toString();
  }
  static String calculateStringHash(String str) {
    final bytes = utf8.encode(str);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

}
