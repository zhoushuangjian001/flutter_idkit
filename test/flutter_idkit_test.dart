import 'package:flutter_idkit/src/function/idkit_desensitization.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('adds one to input values', () {
    String result = '123456789012345';
    result =
        result.replaceRange(6, result.length - 4, "*" * (result.length - 10));
    print(result);
  });
}
