import Flutter
import UIKit

public class SwiftFlutterExitAppPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_exit_app", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterExitAppPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)

        case "com.laoitdev.exit.app":
            guard let arguments = call.arguments as? [String: Any],
                  let killIosProcess = arguments["killIosProcess"] as? Bool else {
                quit(killIosProcess: false)
                result("Done")
                return
            }
            quit(killIosProcess: killIosProcess)
            result("Done")

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    /// Quits the application with animation
    ///
    /// - Parameter killIosProcess: If true, forcibly terminates the app after 1 second.
    ///   Default behavior (false) only suspends the app, which is Apple guideline compliant.
    private func quit(killIosProcess: Bool = false) {
        // Suspend the application with animation
        UIApplication.shared.perform(#selector(URLSessionTask.suspend))

        // Optionally force-kill the process (not recommended by Apple)
        if killIosProcess {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                exit(0)
            }
        }
    }
}
