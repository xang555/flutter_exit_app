import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_exit_app/src/channel_name.dart';

class FlutterExitApp {
  static const MethodChannel _channel = MethodChannel('flutter_exit_app');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// exit app
  static Future<bool> exitApp() async {
    try {
      final String? res = await _channel.invokeMethod(ChannelName.exitApp);
      return res == 'Done';
    } catch (e) {
      return false;
    }
  }
}
