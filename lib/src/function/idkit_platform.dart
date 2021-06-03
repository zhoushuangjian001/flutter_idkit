import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class IDKitPlatform {
  IDKitPlatform.empty();

  /// Whether the operating system is a version of
  /// [Android](https://en.wikipedia.org/wiki/Android_%28operating_system%29).
  static bool get isAndroid => kIsWeb ? _getFalse() : Platform.isAndroid;

  /// Whether the operating system is a version of
  /// [Fuchsia](https://en.wikipedia.org/wiki/Google_Fuchsia).
  static bool get isFuchsia => kIsWeb ? _getFalse() : Platform.isFuchsia;

  /// Whether the operating system is a version of
  /// [macOS](https://en.wikipedia.org/wiki/MacOS).
  static bool get isMacOS => kIsWeb ? _getFalse() : Platform.isMacOS;

  /// Whether the operating system is a version of
  /// [iOS](https://en.wikipedia.org/wiki/IOS).
  static bool get isIOS => kIsWeb ? _getFalse() : Platform.isIOS;

  /// Whether the operating system is a version of
  /// [Linux](https://en.wikipedia.org/wiki/Linux).
  static bool get isLinux => kIsWeb ? _getFalse() : Platform.isLinux;

  /// Whether the operating system is a version of
  /// [Microsoft Windows](https://en.wikipedia.org/wiki/Microsoft_Windows).
  static bool get isWindows => kIsWeb ? _getFalse() : Platform.isWindows;

  /// A constant that is true if the application was compiled to run on the web.
  static bool get isWeb => kIsWeb;
  static bool _getFalse() => false;
}
