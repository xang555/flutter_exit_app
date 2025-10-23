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
                exitApp(forceKill: false)
                result("Done")
                return
            }
            exitApp(forceKill: killIosProcess)
            result("Done")

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    /// Exits the application using the appropriate method
    ///
    /// - Parameter forceKill: If true, forcibly terminates the app process.
    ///   Default behavior (false) moves the app to background and suspends it gracefully.
    ///
    /// **Important Notes:**
    /// - Apple's Human Interface Guidelines discourage programmatic app termination
    /// - The app will appear to "crash" to the user if force-killed
    /// - For a better user experience, consider minimizing to background instead
    private func exitApp(forceKill: Bool = false) {
        // Ensure execution on main thread for smooth animations
        DispatchQueue.main.async { [weak self] in
            self?.performExitAnimation(forceKill: forceKill)
        }
    }

    /// Performs the exit animation on the main thread
    private func performExitAnimation(forceKill: Bool) {
        if forceKill {
            // Force kill: Simple fade out and exit immediately
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                exit(0)
            }
        } else {
            // Graceful exit: Suspend the app
            // Resign first responder to trigger proper lifecycle events
            UIApplication.shared.resignFirstResponder()

            // Suspend the app (moves to background)
            // Note: This uses a private API and may be rejected by App Store
            UIApplication.shared.perform(#selector(URLSessionTask.suspend))
        }
    }

    /// Gets all app windows, compatible with iOS 12+
    private func getAppWindows() -> [UIWindow] {
        if #available(iOS 13.0, *) {
            // iOS 13+: Use scene-based API
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
        } else {
            // iOS 12: Use deprecated windows property
            return UIApplication.shared.windows
        }
    }
}
