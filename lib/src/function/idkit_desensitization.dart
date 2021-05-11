/// The important information desensitization.
extension IDKitDesensitization on String {
  String desensitization({
    DesensitizationType type = DesensitizationType.none,
    String mark = '*',
  }) {
    String result = trimAll();
    if (result.isNotEmpty) {
      switch (type) {
        case DesensitizationType.name:
          final bool isQualified = RegExp(r'[\u4e00-\u9fa5]').hasMatch(result);
          if (isQualified) {
            result = result.replaceRange(1, result.length, mark * 2);
          } else {
            throw "The『$this』format isn't qualified.";
          }
          break;
        case DesensitizationType.phone:
          final bool isQualified = RegExp(r'\d{11}$').hasMatch(result);
          if (isQualified) {
            result = result.replaceRange(3, 7, mark * 4);
          } else {
            throw "The『$this』format isn't qualified.";
          }
          break;
        case DesensitizationType.id:
          final bool isQualified = RegExp(r'[\dX]{18}$').hasMatch(result);
          if (isQualified) {
            result = result.replaceRange(6, 14, mark * 8);
          } else {
            throw "The『$this』format isn't qualified.";
          }
          break;
        case DesensitizationType.bank:
          final bool isQualified = RegExp(r'\d{15,19}$').hasMatch(result);
          if (isQualified) {
            result = result.replaceRange(
                6, result.length - 4, mark * (result.length - 10));
          } else {
            throw "The『$this』format isn't qualified.";
          }
          break;
        default:
          result = this;
      }
    }
    return result;
  }
}

/// Desensitization type.
enum DesensitizationType {
  none,
  id,
  name,
  phone,
  bank,
}

/// Remove whitespace.
extension IDKitTrim on String {
  /// The string without any  whitespace.
  String trimAll() {
    return replaceAll(RegExp(r'\s+\b|\b\s'), '');
  }
}
