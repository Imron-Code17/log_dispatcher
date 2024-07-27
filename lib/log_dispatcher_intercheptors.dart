import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:log_dispatcher/log_dispatcher.dart';

class LogDispatcherInterceptors extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    bool isBadConnection = err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.unknown ||
        err.type == DioExceptionType.receiveTimeout;
    final logModel = LogModel(
      time: DateTime.now().toIso8601String(),
      endpoint: err.requestOptions.path,
      method: err.requestOptions.method,
      argument: err.requestOptions.queryParameters.toString(),
      error: err.message ?? err.response?.data.toString(),
      errorFrom: 'SERVER',
      body: err.requestOptions.data != null
          ? jsonEncode(err.requestOptions.data)
          : 'N/A',
      deviceId: deviceId,
      deviceType: deviceType,
      stackTrace: err.stackTrace.toString(),
    );

    _handleLog(logModel, isBadConnection);

    super.onError(err, handler);
  }

  Future<void> _handleLog(LogModel logModel, bool isBadConnection) async {
    if (setupOptions.sendToTelegram &&
        (setupOptions.logType == LogType.sendToChannelOnly ||
            setupOptions.logType == LogType.printAndSendToChannel)) {
      await _sendToTelegram(
          setupOptions.telegramBotToken ?? '',
          setupOptions.telegramChatId ?? '',
          logModel,
          setupOptions.showStackTrace,
          isBadConnection);
    }
  }

  Future<void> _sendToTelegram(String botToken, String chatId,
      LogModel? logModel, bool isStackTraceShow, bool isBadConnection) async {
    final url = 'https://api.telegram.org/bot$botToken/sendMessage';

    final payload = {
      'chat_id': chatId,
      'text': _formatLogModel(logModel, isStackTraceShow, isBadConnection),
      'parse_mode': 'MarkdownV2',
    };

    try {
      final response = await HttpClient()
          .postUrl(Uri.parse(url))
          .timeout(const Duration(seconds: 30))
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
    } on SocketException catch (e) {
      _printError('Network error: $e');
    } on TimeoutException catch (e) {
      _printError('Request timeout: $e');
    } catch (e) {
      _printError('Error sending message to Telegram: $e');
    }
  }

  String _formatLogModel(
      LogModel? logModel, bool isStackTraceShow, bool isBadConnection) {
    final buffer = StringBuffer();
    if (isBadConnection) {
      buffer.writeln('CONNECTION`-`ERROR\n');
      buffer.writeln('`Connection Issue Detected`');
      buffer.writeln(
          '````it seems there is a problem with your internet connection. '
          'Please check your network settings, ensure you are connected to the internet, '
          'and try again. If the issue persists, you may want to restart your router or contact your internet service provider for further assistance.````');
    } else {
      final environmentText = setupOptions.environment != null
          ? '`[`${setupOptions.environment?.toUpperCase()}`]`'
          : '';

      buffer.writeln('$environmentText ${logModel?.errorFrom}`-`ERROR\n');
      buffer.writeln('`TIME`');
      buffer.writeln('```${logModel?.time}```');
      buffer.writeln('`DEVICE INFO`');
      buffer.writeln('````Type : ${logModel?.deviceType}');
      buffer.writeln('Id   : ${logModel?.deviceId}````');
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
