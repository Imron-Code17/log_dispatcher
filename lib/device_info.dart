import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

String deviceId = '';
String deviceType = '';

Future<String> getDeviceId() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String id = '';
  if (kIsWeb) {
    WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
    deviceId = webBrowserInfo.userAgent ?? '';
  } else {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      id = androidInfo.id;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      id = iosInfo.identifierForVendor ?? '';
    } else if (Platform.isLinux) {
      LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
      id = linuxInfo.id;
    } else if (Platform.isMacOS) {
      MacOsDeviceInfo macOsInfo = await deviceInfo.macOsInfo;
      id = macOsInfo.systemGUID ?? '';
    } else if (Platform.isWindows) {
      WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
      id = windowsInfo.computerName;
    } else {
      id = 'UNKNOWN';
    }
  }

  return id;
}

String get getDeviceType {
  if (Platform.isAndroid) {
    return 'ANDROID';
  } else if (Platform.isIOS) {
    return 'IOS';
  } else if (Platform.isLinux) {
    return 'LINUX';
  } else if (Platform.isMacOS) {
    return 'MACOS';
  } else if (Platform.isWindows) {
    return 'WINDOWS';
  } else {
    return 'UNKNOWN';
  }
}
