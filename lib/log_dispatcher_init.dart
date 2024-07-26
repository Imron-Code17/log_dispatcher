import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:log_dispatcher/log_dispatcher.dart';

class LogDispatcher {
  static void init({required LogDispatcherOptions options}) {
    setupOptions = options;
    FlutterError.onError = (FlutterErrorDetails details) {
      LogDispacherExecuite.detail(details, setupOptions);
    };
  }
}
