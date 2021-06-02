import 'dart:math' show pow;

/// The method extension of int and double.
extension IDKitNum on num {
  /// Amount formatting.
  ///
  /// [round]: Did The object round at specifies the object of reserved digits, default value is true.
  ///
  /// [digit]: Specifies the object of reserved digits.
  ///
  /// [separator]: The shape of the thousandth.
  ///
  String addThousandth({
    bool round = true,
    int? digit,
    String separator = ',',
  }) {
    late String result;
    final String numStr = toString();
    if (this is int) {
      result = _noDecimalHandleMethod(numStr, digit, separator);
    } else {
      if (numStr.contains('.')) {
        result = _decimalHandleMethod(numStr, digit, separator, round);
      } else {
        result = _noDecimalHandleMethod(numStr, digit, separator);
      }
    }
    return result.trim();
  }
}

/// The method extension of string.
extension IDKitString on String {
  /// Amount formatting.
  ///
  /// [round]: Did The object round at specifies the object of reserved digits, default value is true.
  ///
  /// [digit]: Specifies the object of reserved digits.
  ///
  /// [separator]: The shape of the thousandth.
  ///
  String addThousandth({
    bool round = true,
    int? digit,
    String separator = ',',
  }) {
    late String result;
    if (isNotEmpty) {
      final double? temp = double.tryParse(this);
      if (temp == null) {
        throw 'The『$this』is malformed.';
      } else {
        final bool isPoint = contains('.');
        if (isPoint) {
          result = _decimalHandleMethod(this, digit, separator, round);
        } else {
          result = _noDecimalHandleMethod(this, digit, separator);
        }
      }
    } else {
      result = this;
    }
    return result.trim();
  }
}

/// The result of occupying position is used zero.
String _occupyingPosition(int digit) {
  return '.' + '0' * digit;
}

/// The string is divided into three segments.
List<String> _decollate(String str) {
  final int length = str.length;
  final int remainder = length % 3;
  final List<String> list = <String>[];
  int e = 0;
  for (int i = remainder == 0 ? 3 : remainder; i <= length; i += 3) {
    final String temp = str.substring(e, i);
    e = i;
    list.add(temp);
  }
  return list;
}

/// No decimal processing.
String _noDecimalHandleMethod(String str, int? digit, String separator) {
  String result = str;
  if (str.length > 3) {
    result = _decollate(str).join(separator);
  }
  if (digit != null && digit != 0) {
    result += _occupyingPosition(digit);
  }
  return result;
}

/// decimal processing.
String _decimalHandleMethod(
    String str, int? digit, String separator, bool round) {
  late String result;
  final List<String> list = str.split('.');
  if (digit == null) {
    result = _noDecimalHandleMethod(list.first, digit, separator);
    final String last = list.last;
    if (last.isNotEmpty) {
      result += '.$last';
    }
  } else if (digit == 0) {
    final double decimal = double.parse('0.' + list.last);
    if (round && (decimal >= 0.5)) {
      final int integer = int.parse(list.first) + 1;
      result = _noDecimalHandleMethod(integer.toString(), digit, separator);
    } else {
      result = _noDecimalHandleMethod(list.first, digit, separator);
    }
  } else {
    final int decimalLength = list.last.length;
    if (digit >= decimalLength) {
      final String tempInteger = _decollate(list.first).join(separator);
      result = tempInteger + '.' + list.last + '0' * (digit - decimalLength);
    } else {
      final String decimalPart = list.last;
      final String carryStandard = decimalPart.substring(digit, digit + 1);
      final int carryValue = int.parse(carryStandard);
      if (carryValue >= 5 && round) {
        final double decimalValue =
            double.parse('0.' + decimalPart.substring(0, digit));
        final double carryAdd = 1.0 / pow(10, digit);
        final double tempDecimalValue = decimalValue + carryAdd;
        final String integerPart = list.first;
        int tempInteger = int.parse(integerPart);
        if (tempDecimalValue >= 1.0) {
          tempInteger += 1;
        }
        final String tempIntegerPart =
            _decollate(tempInteger.toString()).join(separator);
        final String sCarry =
            tempDecimalValue.toStringAsFixed(digit).split('.').last;
        final String tempDecimailPart = sCarry + '0' * (digit - sCarry.length);
        result = tempIntegerPart + '.' + tempDecimailPart;
      } else {
        final String integerPart = _decollate(list.first).join(separator);
        result = integerPart + '.' + decimalPart.substring(0, digit);
      }
    }
  }
  return result.trim();
}
