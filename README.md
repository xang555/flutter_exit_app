# flutter_exit_app

A flutter plugin provides the best way to exit the app doesn't call `exit(0)` in dart code.

## Install

add plugin to your `pubspec.yaml`

```yaml
flutter_exit_app: ^1.0.3
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

