import 'package:flutter/services.dart';
import 'package:flutter_exit_app/src/channel_name.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';

import 'flutter_exit_app_test.mocks.dart';

@GenerateMocks([MethodChannel])
void main() {
  late MockMethodChannel mockChannel;

  setUp(() {
    mockChannel = MockMethodChannel();
    FlutterExitApp.channel = mockChannel;
  });

  group('FlutterExitApp', () {
    test('platformVersion returns version', () async {
      when(mockChannel.invokeMethod<String>('getPlatformVersion'))
          .thenAnswer((_) async => '1.0.0');

      final version = await FlutterExitApp.platformVersion;

      expect(version, '1.0.0');
    });

    test('exitApp returns true on success', () async {
      when(mockChannel.invokeMethod<String>(
        ChannelName.exitApp,
        {"killIosProcess": false},
      )).thenAnswer((_) async => 'Done');

      final result = await FlutterExitApp.exitApp();

      expect(result, true);
    });

    test('exitApp returns false on failure', () async {
      when(mockChannel.invokeMethod<String>(
        ChannelName.exitApp,
        {"killIosProcess": false},
      )).thenThrow(PlatformException(code: 'ERROR'));

      final result = await FlutterExitApp.exitApp();

      expect(result, false);
    });

    test('exitApp handles iosForceExit parameter', () async {
      when(mockChannel.invokeMethod<String>(
        ChannelName.exitApp,
        {"killIosProcess": true},
      )).thenAnswer((_) async => 'Done');

      final result = await FlutterExitApp.exitApp(iosForceExit: true);

      expect(result, true);
    });
  });
}
