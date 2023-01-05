import 'dart:async';
import 'dart:io';
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
  /// [waitExitTimeSeconds] time waiting before exit this is for ios only
  static Future<bool?> exitApp({int waitExitTimeSeconds = 1}) async {
    try {
      final String? res = await _channel.invokeMethod(ChannelName.exitApp);
      if (Platform.isIOS) {
        await Future.delayed(Duration(seconds: waitExitTimeSeconds));
        exit(0);
      }
      return res == "Done";
    } catch (e) {
      return false;
    }
  }
}
