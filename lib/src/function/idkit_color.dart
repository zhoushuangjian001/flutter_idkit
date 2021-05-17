import 'package:flutter/material.dart' show Color, Colors;

/// The extension of String get color.
extension IDKitColor on String {
  /// Get color using hexadecimal string.
  ///
  /// Support example:
  /// '#FFABC'、'FFABC'、'#FFF' 、'FFF'、'#FFABCDEA'、'#ABCDEA'、'ABCDEA'、'FFABCDEA'.
  Color toColor() {
    if (this == null || isEmpty) {
      return Colors.white;
    }
    String trim = this.trim();
    int length = trim.length;
    if (trim.startsWith('#')) {
      trim = substring(1);
      length = trim.length;
    }
    switch (length) {
      case 3:
        trim = 'FF' + repeat(trim);
        break;
      case 5:
        trim = substring(2);
        trim = 'FF' + repeat(trim);
        break;
      case 6:
        trim = 'FF' + trim;
        break;
      case 8:
        trim = substring(2);
        trim = 'FF' + trim;
        break;
      default:
        trim = 'FFFFFFFF';
    }
    late int hex;
    try {
      hex = int.parse(trim, radix: 16);
    } catch (e) {
      hex = 0xFFFFFFFF;
    }
    return Color(hex);
  }
}

/// Get duplicate string.
String repeat(String obj) {
  final Iterable<String> repeat = obj.split('').map((String e) => e * 2);
  return repeat.join();
}
