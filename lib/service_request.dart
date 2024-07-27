import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:log_dispatcher/log_dispatcher.dart';

class ServiceRequest {
  static Future<void> sendToTelegram(String botToken, String chatId,
      LogModel? logModel, LogDispatcherOptions options) async {
    final url = 'https://api.telegram.org/bot$botToken/sendMessage';

    final payload = {
      'chat_id': chatId,
      'text': _createPayload(logModel, options),
      'parse_mode': 'MarkdownV2',
    };

    try {
      final response = await HttpClient()
          .postUrl(Uri.parse(url))
          .then((HttpClientRequest request) {
        request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
        request.write(jsonEncode(payload));
        return request.close();
      });

      final responseBody = await response.transform(utf8.decoder).join();
      final jsonResponse = jsonDecode(responseBody);

      if (jsonResponse['ok'] == true) {
        _printSuccess('Message sent to Telegram successfully.');
      } else {
        _printError(
            'Failed to send message to Telegram: ${jsonResponse['description']}');
      }
    } catch (e) {
      _printError('Error sending message to Telegram: $e');
    }
  }

  static Future<void> sendToDiscord() async {
    // Implementasi untuk Discord
  }

  static String _createPayload(
      LogModel? logModel, LogDispatcherOptions options) {
    final buffer = StringBuffer();
    final environmentText = setupOptions.environment != null
        ? '`[`${setupOptions.environment?.toUpperCase()}`]`'
        : '';

    buffer.writeln('$environmentText ${logModel?.errorFrom}`-`ERROR\n');

    buffer.writeln('`TIME`');
    buffer.writeln('```${logModel?.time}```');
    buffer.writeln('`DEVICE INFO`');
    buffer.writeln('````Type : ${logModel?.deviceType}');
    if (setupOptions.appRole != null) {
      buffer.writeln('Role : ${setupOptions.appRole}');
    }
    buffer.writeln('Id   : ${logModel?.deviceId}````');
    buffer.writeln('`FILE PATH`');
    buffer.writeln('```${logModel?.filePath}```');
    buffer.writeln('`LINE NUMBER`');
    buffer.writeln('```${logModel?.lineNumber}```');
    buffer.writeln('`COLUMN NUMBER`');
    buffer.writeln('```${logModel?.columnNumber}```');
    buffer.writeln('`EXCEPTION`');
    buffer.writeln('```${logModel?.exception}```');
    if (options.showStackTrace == true) {
      buffer.writeln('`STACK TRACE`');
      buffer.writeln('```\n${logModel?.stackTrace}\n```');
    }

    return buffer.toString();
  }

  static void _printSuccess(String message) {
    const greenColor = '\x1B[32m';
    const resetColor = '\x1B[0m';
    if (kDebugMode) {
      print('$greenColor$message$resetColor');
    }
  }

  static void _printError(String message) {
    const redColor = '\x1B[31m';
    const resetColor = '\x1B[0m';
    if (kDebugMode) {
      print('$redColor$message$resetColor');
    }
  }
}

String getDeviceLogoUrl(String? deviceType) {
  switch (deviceType) {
    case 'android':
      return '🤖';
    case 'ios':
      return '🍎';
    case 'linux':
      return '🐧';
    case 'macos':
      return '🍏';
    case 'windows':
      return '🪟';
    default:
      return '';
  }
}
