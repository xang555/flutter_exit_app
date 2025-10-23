# flutter_exit_app

A Flutter plugin that provides a platform-specific way to exit your application without calling `exit(0)` in Dart code.

## Features

- **Android**: Cleanly finishes the activity and removes it from the task list
- **iOS**: Suspends the application (Apple guideline compliant) with optional force-exit
- **Modern implementation**: Written in Kotlin (Android) and Swift (iOS)
- **Type-safe**: Full null-safety support
- **Well-tested**: Comprehensive unit tests

## Platform Support

| Platform | Minimum Version |
|----------|----------------|
| Android  | API 21 (Android 5.0) |
| iOS      | 12.0 |

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_exit_app: ^2.0.0
```

Then run:

```bash
flutter pub get
```

## Usage

### Import the package

```dart
import 'package:flutter_exit_app/flutter_exit_app.dart';
```

### Basic exit (recommended)

```dart
// Exit the app using platform-specific methods
// iOS: Suspends the app (Apple guideline compliant)
// Android: Finishes activity and exits
await FlutterExitApp.exitApp();
```

### Force exit on iOS (not recommended)

```dart
// Force-kill the iOS app process (against Apple guidelines)
// Only use when absolutely necessary
await FlutterExitApp.exitApp(iosForceExit: true);
```

### Complete example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';

class ExitButton extends StatelessWidget {
  const ExitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        // Show confirmation dialog
        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Are you sure you want to exit?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Exit'),
              ),
            ],
          ),
        );

        if (shouldExit == true) {
          await FlutterExitApp.exitApp();
        }
      },
      child: const Text('Exit App'),
    );
  }
}
```

## Important Notes

### iOS Guidelines

Apple's Human Interface Guidelines discourage apps from programmatically exiting. The default behavior (`iosForceExit: false`) suspends the app, which is the recommended approach. Only use `iosForceExit: true` if you have a specific requirement.

### Android Behavior

On Android, the plugin finishes the current activity and removes it from the recent tasks list, then exits the process after a 1-second delay to ensure clean shutdown.

## API Reference

### `FlutterExitApp.exitApp({bool iosForceExit = false})`

Exits the application using platform-specific methods.

**Parameters:**
- `iosForceExit` (optional): If `true`, forces the iOS app to terminate. Default is `false`.

**Returns:** `Future<bool>` - `true` if exit was initiated successfully, `false` otherwise.

### `FlutterExitApp.platformVersion`

Gets the current platform version.

**Returns:** `Future<String?>` - A string like "Android 13" or "iOS 16.0", or `null` if unavailable.

## Migration Guide

### From 1.x to 2.0

Version 2.0 includes breaking changes:

1. **Minimum requirements updated:**
   - Flutter 3.10.0+ required
   - Dart 3.0.0+ required
   - Android API 21+ (was 16)
   - iOS 12.0+ (was 9.0)

2. **Return type changed:**
   - `exitApp()` now returns `Future<bool>` instead of `Future<bool?>`

3. **Android now uses Kotlin** (transparent to users)

4. **Improved error handling** with better exception messages

## License

See the [LICENSE](LICENSE) file for details.
