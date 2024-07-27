class LogDispatcherOptions {
  final bool sendToTelegram;
  final String? telegramBotToken;
  final String? telegramChatId;
  final bool showStackTrace;
  final LogType logType;
  final String? appRole;
  final String? environment;

  LogDispatcherOptions(
      {this.sendToTelegram = false,
      this.telegramBotToken,
      this.telegramChatId,
      this.showStackTrace = false,
      this.logType = LogType.printAndSendToChannel,
      this.appRole,
      this.environment});
}

late LogDispatcherOptions setupOptions;

enum LogType { printOnly, sendToChannelOnly, printAndSendToChannel }
