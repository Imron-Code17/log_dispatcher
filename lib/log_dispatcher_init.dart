import 'package:flutter/material.dart';
import 'package:log_dispatcher/log_dispatcher.dart';

class LogDispatcher {
  static void init({required LogDispatcherOptions options}) async {
    WidgetsFlutterBinding.ensureInitialized();
    setupOptions = options;
    deviceType = getDeviceType;
    deviceId = await getDeviceId();
    FlutterError.onError = (FlutterErrorDetails details) {
      LogDispacherExecuite.detail(details, setupOptions);
    };
  }
}
