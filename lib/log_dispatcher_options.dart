class LogDispatcherOptions {
  final bool sendToTelegram;
  // final bool sendToDiscord;
  final String? telegramBotToken;
  final String? telegramChatId;
  // final String? discordWebhookUrl;
  final bool printOnly;
  final bool showStackTrace;

  LogDispatcherOptions({
    this.sendToTelegram = false,
    // this.sendToDiscord = false,
    this.telegramBotToken,
    this.telegramChatId,
    // this.discordWebhookUrl,
    this.printOnly = false,
    this.showStackTrace = false,
  });
}

late LogDispatcherOptions setupOptions;
