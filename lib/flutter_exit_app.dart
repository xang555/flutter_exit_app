import 'dart:async';
import 'package:flutter/services.dart';

import 'src/channel_name.dart';

/// provides access to the native platform's exit app
class FlutterExitApp {
  /// create flutter exit app instance
  FlutterExitApp();

  static const MethodChannel _channel = MethodChannel('flutter_exit_app');

  /// get platform version
  ///
  /// return platform version string
  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// exit app
  ///
  /// return `true` if exit app success, otherwise `false`
  static Future<bool?> exitApp() async {
    try {
      final String? res = await _channel.invokeMethod(ChannelName.exitApp);
      return res == "Done";
    } catch (e) {
      return false;
    }
  }
}
