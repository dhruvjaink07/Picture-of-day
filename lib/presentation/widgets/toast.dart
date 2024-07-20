import 'package:flutter/services.dart';

class Toast {
  static const MethodChannel _channel = MethodChannel('toast.flutter.io/toast');

  static Future<void> showToast(String message) async {
    try {
      await _channel.invokeMethod('showToast', {"message": message});
    } on PlatformException catch (e) {
      print("Failed to show toast: '${e.message}'.");
    }
  }
}
