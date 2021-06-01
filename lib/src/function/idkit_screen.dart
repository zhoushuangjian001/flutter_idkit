import 'dart:math';
import 'package:flutter/material.dart';

class IDKitScreen {
  /// Factory method construction.
  factory IDKitScreen() => _instance;
  IDKitScreen._();
  static late final IDKitScreen _instance = IDKitScreen._();

  ///
  static const Size defaultUISize = Size(1080, 1920);
  void build(
    BuildContext context,
    Orientation orientation, {
    Size? designSize,
  }) {
    // The configure of device.
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    _orientation = orientation;
    _screenHeight = mediaQueryData.size.width;
    _screenWidth = mediaQueryData.size.height;
    final Size _size = designSize ??= defaultUISize;
    _uiSize = orientation == Orientation.portrait ? _size : _size.flipped;
    _devicePixelRatio = mediaQueryData.devicePixelRatio;
    _textScaleFactor = mediaQueryData.textScaleFactor;
    _statusBarHeight = mediaQueryData.padding.top;
    _bottomBarHeight = mediaQueryData.padding.bottom;
  }

  /// the orientation of the screen.
  late Orientation _orientation;
  late double _devicePixelRatio;
  late double _textScaleFactor;
  late double _screenWidth;
  late double _screenHeight;
  late double _statusBarHeight;
  late double _bottomBarHeight;
  late Size _uiSize;

  /// Get the orientation of the screen.
  static Orientation get orientation => IDKitScreen()._orientation;
  static double get devicePixelRatio => IDKitScreen()._devicePixelRatio;

  /// Get the width of the screen.
  static double get screenWidth => IDKitScreen()._screenWidth;

  /// Get the height of the screen.
  static double get screenHeight => IDKitScreen()._screenHeight;

  static double get statusBarHeight => IDKitScreen()._statusBarHeight;

  static double get bottomBarHeight => IDKitScreen()._bottomBarHeight;

  /// Get the ratio of the screen width to the design width.
  static double get scaleWidth => screenWidth / IDKitScreen()._uiSize.width;

  /// Get the ratio of the screen height to the design height.
  static double get scaleHeight => screenHeight / IDKitScreen()._uiSize.height;

  /// Get the ratio of the text font to the design text font.
  static double get scaleFont => min(scaleWidth, scaleHeight);

  /// Get the mapping value of design width through width ratio.
  static double setWidth(num width) => scaleWidth * width;

  /// Get the mapping value of design height through height ratio.
  static double setHeight(num height) => scaleHeight * height;

  /// Get the mapping value of design text font through text font ratio.
  /// [allowFontScaling] is following system font scaling.
  static double setSp(num fontSize) => fontSize * scaleFont;
}
