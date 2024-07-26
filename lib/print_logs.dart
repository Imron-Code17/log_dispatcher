import 'package:flutter/foundation.dart';

class PrintLogs {
  static void show(String message) {
    const String redDark = '\x1B[31;1m';
    const String reset = '\x1B[0m';
    if (kDebugMode) {
      print('$redDark: $message$reset');
    }
  }
}
