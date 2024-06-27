import 'dart:async';
import 'package:flutter/services.dart';

import 'src/channel_name.dart';

/// provides access to the native platform's exit app
class FlutterExitApp {
  /// create flutter exit app instance
  FlutterExitApp();

  static MethodChannel channel = MethodChannel('flutter_exit_app');

  /// get platform version
  ///
  /// return platform version string
  static Future<String?> get platformVersion async {
    final String? version = await channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// exit app
  ///
  /// return `true` if exit app success, otherwise `false`
  /// [iosForceExit] if `true` ios force exit  default `false`.  No affect in android
  static Future<bool?> exitApp({bool iosForceExit = false}) async {
    try {
      final String? res = await channel.invokeMethod<String>(
        ChannelName.exitApp,
        {"killIosProcess": iosForceExit},
      );
      return res == "Done";
    } catch (_) {
      return false;
    }
  }
}
