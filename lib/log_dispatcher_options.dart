class LogDispatcherOptions {
  final bool sendToTelegram;
  // final bool sendToDiscord;
  final String? telegramBotToken;
  final String? telegramChatId;
  // final String? discordWebhookUrl;
  final bool showStackTrace;
  final LogType logType;

  LogDispatcherOptions({
    this.sendToTelegram = false,
    // this.sendToDiscord = false,
    this.telegramBotToken,
    this.telegramChatId,
    // this.discordWebhookUrl,
    this.showStackTrace = false,
    this.logType = LogType.printAndSendToChannel,
  });
}

late LogDispatcherOptions setupOptions;

enum LogType { printOnly, sendToChannelOnly, printAndSendToChannel }
