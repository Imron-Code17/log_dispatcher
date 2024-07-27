class LogModel {
  final String? filePath;
  final int? lineNumber;
  final int? columnNumber;
  final String? exception;
  final String? stackTrace;
  final String? time;
  final String? errorFrom;
  final String? endpoint;
  final String? method;
  final String? argument;
  final String? error;
  final String? body;
  final String? deviceId;
  final String? deviceType;

  LogModel(
      {this.filePath,
      this.lineNumber,
      this.columnNumber,
      this.exception,
      this.stackTrace,
      this.time,
      this.errorFrom,
      this.endpoint,
      this.method,
      this.argument,
      this.error,
      this.body,
      this.deviceId,
      this.deviceType});
}
