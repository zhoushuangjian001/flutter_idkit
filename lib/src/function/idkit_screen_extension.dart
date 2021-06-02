import 'package:flutter_idkit/src/function/idkit_screen.dart' show IDKitScreen;

extension IDKitScreenNum on num {
  /// Width factor mapping.
  double get w => IDKitScreen.setWidth(this);

  /// Height factor mapping.
  double get h => IDKitScreen.setHeight(this);

  /// Get the mapping width not less than the width factor.
  double get cw => IDKitScreen.setWidth(this).ceilToDouble();

  /// Get the mapping height not less than the height factor
  double get ch => IDKitScreen.setHeight(this).ceilToDouble();

  /// Gets the mapping width not greater than the width factor.
  double get fw => IDKitScreen.setWidth(this).floorToDouble();

  /// Gets the mapping height not greater than the height factor.
  double get fh => IDKitScreen.setHeight(this).floorToDouble();

  /// Get the closest width factor mapping width.
  double get rw => IDKitScreen.setWidth(this).roundToDouble();

  /// Get the closest height factor mapping height.
  double get rh => IDKitScreen.setHeight(this).roundToDouble();

  /// Get font mapping value.
  double get sp => IDKitScreen.setSp(this);

  /// Get not less than the font mapping value.
  double get cSp => IDKitScreen.setSp(this).ceilToDouble();

  /// Get the value that is not greater than the font mapping value.
  double get fSp => IDKitScreen.setSp(this).floorToDouble();

  /// Gets the closest font mapping value.
  double get rSp => IDKitScreen.setSp(this).roundToDouble();
}
