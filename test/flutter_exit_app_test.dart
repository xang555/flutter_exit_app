import 'package:flutter/services.dart';
import 'package:flutter_exit_app/src/channel_name.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel('flutter_exit_app');
  final List<MethodCall> log = <MethodCall>[];

  setUp(() {
    log.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      log.add(methodCall);

      switch (methodCall.method) {
        case 'getPlatformVersion':
          return 'Android 13';
        case ChannelName.exitApp:
          return 'Done';
        default:
          return null;
      }
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  group('FlutterExitApp', () {
    test('platformVersion returns version', () async {
      final version = await FlutterExitApp.platformVersion;

      expect(version, 'Android 13');
      expect(log, <Matcher>[
        isMethodCall('getPlatformVersion', arguments: null),
      ]);
    });

    test('platformVersion throws on error', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        throw PlatformException(code: 'ERROR', message: 'Test error');
      });

      expect(
        () => FlutterExitApp.platformVersion,
        throwsA(isA<Exception>()),
      );
    });

    test('exitApp returns true on success', () async {
      final result = await FlutterExitApp.exitApp();

      expect(result, true);
      expect(log, <Matcher>[
        isMethodCall(
          ChannelName.exitApp,
          arguments: <String, dynamic>{"killIosProcess": false},
        ),
      ]);
    });

    test('exitApp returns false on failure', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        throw PlatformException(code: 'ERROR', message: 'Test error');
      });

      final result = await FlutterExitApp.exitApp();

      expect(result, false);
    });

    test('exitApp handles iosForceExit parameter', () async {
      final result = await FlutterExitApp.exitApp(iosForceExit: true);

      expect(result, true);
      expect(log, <Matcher>[
        isMethodCall(
          ChannelName.exitApp,
          arguments: <String, dynamic>{"killIosProcess": true},
        ),
      ]);
    });

    test('exitApp returns false on non-platform exception', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        throw Exception('Generic error');
      });

      final result = await FlutterExitApp.exitApp();

      expect(result, false);
    });
  });
}
