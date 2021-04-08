import 'package:flutter_idkit/src/idkit_time.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('adds one to input values', () {
    // 测试
    expect("2021-04-08 14:21:01",
        IDKitTime().timeFormat(time: 1617862861, type: TimeType.second));
    expect("2021-04-08 14:21:01", IDKitTime().timeFormat(time: 1617862861000));
    expect(
        "2021-04-08 14:21:01",
        IDKitTime()
            .timeFormat(time: 1617862861000000, type: TimeType.microsecond));

    expect(
        "21-4-8 14:21:1",
        IDKitTime().timeFormat(
            time: 1617862861000000,
            type: TimeType.microsecond,
            format: "yy-M-d hh:m:s"));

    expect(
        "21-4-8",
        IDKitTime().timeFormat(
            time: 1617862861000000,
            type: TimeType.microsecond,
            format: "yy-M-d "));

    expect("2021-04-08 14:21:01",
        IDKitTime().stampFormat(stamp: "1617862861", type: TimeType.second));
    expect(
        "2021-04-08 14:21:01", IDKitTime().stampFormat(stamp: "1617862861000"));
    expect(
        "2021-04-08 14:21:01",
        IDKitTime().stampFormat(
            stamp: "1617862861000000", type: TimeType.microsecond));

    expect("2021-04-08 14:21:01",
        IDKitTime().customFarmat(stamp: "1617862861", type: TimeType.second));
    expect("2021-04-08 14:21:01",
        IDKitTime().customFarmat(stamp: "1617862861000"));
    expect(
        "2021-04-08 14:21:01",
        IDKitTime().customFarmat(
            stamp: "1617862861000000", type: TimeType.microsecond));

    expect("2021-04-08 14:21:01",
        IDKitTime().customFarmat(time: 1617862861, type: TimeType.second));
    expect(
        "2021-04-08 14:21:01", IDKitTime().customFarmat(time: 1617862861000));
    expect(
        "2021-04-08 14:21:01",
        IDKitTime()
            .customFarmat(time: 1617862861000000, type: TimeType.microsecond));

    expect("sss", IDKitTime().customFarmat(defValue: "sss"));
  });
}
