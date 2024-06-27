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
            let passData = parseArg(call)
          quit(killIosProcess: passData.killIosProcess)
            result("Done")
      }else {
            result("NOT_IMPLEMENT")
    }

  }
    
    
    // Will quit the application with animation
  private func quit(killIosProcess: Bool? = false) {
        UIApplication.shared.perform(#selector(URLSessionTask.suspend))
        
        if killIosProcess == true {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                exit(0)
            }
        }
  }
    
 
// parse argument pass from flutter
private func parseArg(_ call: FlutterMethodCall) -> ArgDataStruct {
    let arguments = call.arguments as! [String : Any?]
    
    let killIosProcess = arguments["killIosProcess"] as? Bool
    
    return ArgDataStruct(
        killIosProcess: killIosProcess
    )
}
    
// arg pass data struct
struct ArgDataStruct {
    var killIosProcess: Bool?
}
    
    
}
