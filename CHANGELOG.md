# Changelog

## [1.1.0] - 2024-07-27
- Added support for including device information in logs.
- Added `LogType` enum values to control how logs are dispatched:
  - `printOnly`: Print logs to the console.
  - `sendToChannelOnly`: Send logs to channels only.
  - `printAndSendToChannel`: Print logs to the console and send them to channels.
- Updated `LogDispatcherOptions` to include new fields for device info and log types.

## [1.0.0] - 2024-07-26
- Initial release of the log_dispatcher package.
  - Added core functionalities for dispatching logs to Telegram and Discord.
  - Included support for capturing Flutter errors and server errors using Dio interceptors.
  - Implemented `LogDispatcher` and `LogDispatcherInterceptors`.

