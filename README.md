# flutter_exit_app

A flutter plugin provides the best way to exit the app doesn't call `exit(0)` in dart code.

## Install

add plugin to your `pubspec.yaml`

```yaml
flutter_exit_app: release
```

## Usage

* import plugin

```dart
import 'package:flutter_exit_app/flutter_exit_app.dart';
```

* call exit app static method

```dart
// call this to exit app
FlutterExitApp.exitApp();
```

for IOS if you need to force exit app set `iosForceExit` to `true`

```dart
// force exit in ios
FlutterExitApp.exitApp(iosForceExit: true);
```
