#import "FlutterExitAppPlugin.h"
#if __has_include(<flutter_exit_app/flutter_exit_app-Swift.h>)
#import <flutter_exit_app/flutter_exit_app-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_exit_app-Swift.h"
#endif

@implementation FlutterExitAppPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterExitAppPlugin registerWithRegistrar:registrar];
}
@end
