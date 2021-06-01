import 'package:flutter_idkit/src/function/idkit_screen.dart';

extension IDKitScreenNum on num {
  double get w => IDKitScreen.setWidth(this);
  double get h => IDKitScreen.setHeight(this);

  /// 不小于
  double get cw => IDKitScreen.setWidth(this).ceilToDouble();
  double get ch => IDKitScreen.setHeight(this).ceilToDouble();

  /// 不大于
  double get fw => IDKitScreen.setWidth(this).floorToDouble();
  double get fh => IDKitScreen.setHeight(this).floorToDouble();

  /// 最接近
  double get rw => IDKitScreen.setWidth(this).roundToDouble();
  double get rh => IDKitScreen.setHeight(this).roundToDouble();

  double get sp => IDKitScreen.setSp(this);

  /// 不小于
  double get cSp => IDKitScreen.setSp(this).ceilToDouble();

  /// 不大于
  double get fSp => IDKitScreen.setSp(this).floorToDouble();

  /// 最接近
  double get rSp => IDKitScreen.setSp(this).roundToDouble();
}
