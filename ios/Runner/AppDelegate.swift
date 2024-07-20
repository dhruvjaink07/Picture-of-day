import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let toastChannel = FlutterMethodChannel(name: "toast.flutter.io/toast",
                                              binaryMessenger: controller.binaryMessenger)
    toastChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if call.method == "showToast" {
        if let args = call.arguments as? Dictionary<String, Any>,
           let message = args["message"] as? String {
          self.showToast(message: message)
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    })
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func showToast(message: String) {
    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
        alert.dismiss(animated: true, completion: nil)
    }
  }
}
