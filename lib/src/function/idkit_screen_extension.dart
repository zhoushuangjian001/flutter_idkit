import 'package:flutter_idkit/src/function/idkit_screen_adapter.dart';

extension IDKitScreenNum on num {
  double get w => IDKitScreenAdapter().setWidth(this);
  double get h => IDKitScreenAdapter().setHeight(this);

  /// 不小于
  double get cw => IDKitScreenAdapter().setWidth(this).ceilToDouble();
  double get ch => IDKitScreenAdapter().setHeight(this).ceilToDouble();

  /// 不大于
  double get fw => IDKitScreenAdapter().setWidth(this).floorToDouble();
  double get fh => IDKitScreenAdapter().setHeight(this).floorToDouble();

  /// 最接近
  double get rw => IDKitScreenAdapter().setWidth(this).roundToDouble();
  double get rh => IDKitScreenAdapter().setHeight(this).roundToDouble();
}
