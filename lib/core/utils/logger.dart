import 'dart:developer' as developer;

class AppLogger {
  static void log(String message, {String tag = "APP"}) {
    developer.log("[$tag] $message");
  }

  static void error(String message, {String tag = "APP_ERROR"}) {
    developer.log("[$tag] $message", level: 1000);
  }
}
