import 'package:flutter/foundation.dart';
import 'package:log_dispatcher/log_dispatcher.dart';

class LogDispacherExecuite {
  static void detail(
      FlutterErrorDetails details, LogDispatcherOptions options) {
    LogModel? logModel;

    if (details.stack != null) {
      final stackTraceString = details.stack.toString().split('\n');
      if (stackTraceString.isNotEmpty) {
        for (final line in stackTraceString) {
          final regex = RegExp(r'\((package:.+?)/(.+?):(\d+):(\d+)\)');
          final match = regex.firstMatch(line);
          if (match != null) {
            final filePath = match.group(2);
            final lineNumber = match.group(3);
            final columnNumber = match.group(4);
            logModel = LogModel(
              time: DateTime.now().toIso8601String(),
              filePath: filePath,
              lineNumber: int.tryParse(lineNumber ?? '0'),
              columnNumber: int.tryParse(columnNumber ?? '0'),
              exception: details.exception.toString(),
              stackTrace: details.stack.toString(),
              errorFrom: 'FLUTTER',
            );
            break;
          }
        }
      }
    }
    _printLogInBox('Time', '${logModel?.time}');
    _printLogInBox('File Path', ' ${logModel?.filePath}');
    _printLogInBox('Line', ' ${logModel?.lineNumber}');
    _printLogInBox('Column', ' ${logModel?.columnNumber}');
    _printLogInBox('Exception', ' ${logModel?.exception}');
    if (options.showStackTrace == true) {
      PrintLogs.show("Stack:${logModel?.stackTrace}");
    }
    if (options.sendToTelegram && options.printOnly == false) {
      if (options.telegramBotToken == null || options.telegramChatId == null) {
        PrintLogs.show('Telegram Bot Token or Chat ID not provided.');
        return;
      } else {
        ServiceRequest.sendToTelegram(
            options.telegramBotToken ?? '',
            options.telegramChatId ?? '',
            logModel,
            options.showStackTrace == true);
      }
    }
    // if (options.sendToDiscord && options.printOnly == false) {
    //   if (options.discordWebhookUrl == null) {
    //     PrintLogs.show('Discord Webhook URL not provided.');
    //     return;
    //   }
    // }
  }

  static void _printLogInBox(String label, String message) {
    const borderChar = '-';
    PrintLogs.show(borderChar * 70);

    PrintLogs.show("* ${label.padRight(10)} | $message");

    if (label == 'Exception') {
      PrintLogs.show(borderChar * 70);
    }
  }
}
