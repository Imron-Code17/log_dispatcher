import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:log_dispatcher/log_dispatcher.dart';

class LogDispatcherInterceptors extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final logModel = LogModel(
      time: DateTime.now().toIso8601String(),
      endpoint: err.requestOptions.path,
      method: err.requestOptions.method,
      argument: err.requestOptions.queryParameters.toString(),
      error: err.message,
      errorFrom: 'SERVER',
      body: err.requestOptions.data != null
          ? jsonEncode(err.requestOptions.data)
          : 'N/A',
      stackTrace: err.stackTrace.toString(),
    );
    if (setupOptions.sendToTelegram && setupOptions.printOnly == false) {
      _sendToTelegram(
          setupOptions.telegramBotToken ?? '',
          setupOptions.telegramChatId ?? '',
          logModel,
          setupOptions.showStackTrace);
    }

    super.onError(err, handler);
  }

  Future<void> _sendToTelegram(String botToken, String chatId,
      LogModel? logModel, bool isStackTraceShow) async {
    final url = 'https://api.telegram.org/bot$botToken/sendMessage';

    final payload = {
      'chat_id': chatId,
      'text': _formatLogModel(logModel, isStackTraceShow),
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

  String _formatLogModel(LogModel? logModel, bool isStackTraceShow) {
    final buffer = StringBuffer();

    if (logModel?.errorFrom != null) {
      buffer.writeln('ERROR FROM ${logModel?.errorFrom}\n');
    }
    buffer.writeln('`TIME`');
    buffer.writeln('```${logModel?.time}```');
    buffer.writeln('`METHOD`');
    buffer.writeln('```${logModel?.method}```');
    buffer.writeln('`ENDPOINT`');
    buffer.writeln('```${logModel?.endpoint}```');
    if (logModel?.argument != '{}') {
      buffer.writeln('`ARGUMENTS`');
      buffer.writeln('```${logModel?.argument}```');
    }
    if (logModel?.body != 'N/A') {
      buffer.writeln('`BODY`');
      buffer.writeln('```${logModel?.body}```');
    }
    buffer.writeln('`ERROR`');
    buffer.writeln('```${logModel?.error}```');
    if (isStackTraceShow) {
      buffer.writeln('`STACK TRACE`');
      buffer.writeln('```${logModel?.stackTrace ?? 'N/A'}```');
    }

    return buffer.toString();
  }

  void _printSuccess(String message) {
    const greenColor = '\x1B[32m';
    const resetColor = '\x1B[0m';
    if (kDebugMode) {
      print('$greenColor$message$resetColor\n');
    }
  }

  void _printError(String message) {
    const redColor = '\x1B[31m';
    const resetColor = '\x1B[0m';
    if (kDebugMode) {
      print('$redColor$message$resetColor\n');
    }
  }
}
