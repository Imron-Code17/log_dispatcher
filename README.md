# Log Dispatcher

[![pub package](https://img.shields.io/badge/pub-v1.1.1-blue?logo=dart&logoColor=00b9fc)](https://pub.dev/packages/log_dispatcher)


The Log Dispatcher package provides a simple and efficient way to handle and dispatch error logs from both Flutter applications and server requests to various channels such as Telegram. This package supports sending detailed error reports including stack traces and request details, making it easier to monitor and debug issues in your application.

## Usage

Initialize Log Dispatcher
Before you can use the Log Dispatcher, you need to initialize it with configuration options. This setup will configure how logs are dispatched and to which channels (e.g., Telegram).

Add the following setup to your main function:

```dart
import 'package:log_dispatcher/log_dispatcher.dart';

void main() {
  // Initialize LogDispatcher with options
 LogDispatcher.init(
  options: LogDispatcherOptions(
    sendToTelegram: true, // Set to false if you don't want to send logs to Telegram
    telegramBotToken: 'your-telegram-bot-token',
    telegramChatId: 'your-chat-id',
    showStackTrace: true, // Set to false if you don't want to include stack traces in logs
    logType: LogType.printAndSendToChannel, // Choose the type of log dispatching
    appRole: 'YourAppRole', // (Optional) Specify the app role
    environment: 'Production', // (Optional) Specify the environment
  ),
);
  runApp(MyApp());
}
```
To handle server-side errors and dispatch them using Dio interceptors, add the LogDispatcherInterceptors to your Dio instance:

```dart
import 'package:dio/dio.dart';
import 'package:log_dispatcher/log_dispatcher.dart';

void setupDio() {
  final dio = Dio();

  // Add LogDispatcher interceptor
  dio.interceptors.add(LogDispatcherInterceptors());

  // Use dio instance for network requests
}

```


## Explanation
In the main function:

 - Initialization: Configure the LogDispatcher with options for Telegram and/or Discord, and set whether to print logs or send them to channels.
 - Error Handling: Override FlutterError.onError to capture and dispatch Flutter errors.

With Dio Interceptors:

 - Setup: Add the LogDispatcherInterceptors to your Dio instance to automatically capture and dispatch errors from HTTP requests.

## Summary
  - The Log Dispatcher package simplifies error handling and reporting for both Flutter applications and server requests. By integrating with Telegram, you ensure that critical errors are communicated effectively and can be acted upon promptly. For more details, refer to the package documentation or source code. If you have any questions or issues, feel free to open an issue on the package repository.

## Authors
- [@Imron-Code17](https://github.com/Imron-Code17)


