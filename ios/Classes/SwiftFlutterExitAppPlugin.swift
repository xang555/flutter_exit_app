import Flutter
import UIKit

public class SwiftFlutterExitAppPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_exit_app", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterExitAppPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      
      if call.method == "getPlatformVersion" {
            result("iOS " + UIDevice.current.systemVersion)
      } else if call.method == "com.laoitdev.exit.app" {
            quit()
            result("Done")
      }else {
            result("NOT_IMPLEMENT")
    }

  }
    
    
 // Will quit the application with animation
 private func quit() {
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
    }
}
