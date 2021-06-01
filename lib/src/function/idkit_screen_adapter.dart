import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class IDKitScreenAdapter {
  /// Factory method construction.
  factory IDKitScreenAdapter() => _instance;
  IDKitScreenAdapter._();
  static late IDKitScreenAdapter _instance = IDKitScreenAdapter._();

  ///
  static const Size defaultUISize = Size(1080, 1920);
  static void build(
    BoxConstraints constraints,
    Orientation orientation, {
    Size? designSize,
  }) {
    _instance = IDKitScreenAdapter._();
    _orientation = orientation;
    _screenHeight = constraints.maxHeight;
    _screenWidth = constraints.maxWidth;
    final Size _size = designSize ??= defaultUISize;
    _uiSize = orientation == Orientation.portrait ? _size : _size.flipped;
    // The configure of device.
    final ui.SingletonFlutterWindow window =
        WidgetsBinding.instance?.window ?? ui.window;
    _devicePixelRatio = window.devicePixelRatio;
    _textScaleFactor = window.textScaleFactor;
    _statusBarHeight = window.padding.top;
    _bottomBarHeight = window.padding.bottom;
    _padding = window.viewPadding;
    _ins = window.viewInsets;
  }

  /// the orientation of the screen.
  static late Orientation _orientation;
  static late double _devicePixelRatio;
  static late double _textScaleFactor;
  static late double _screenWidth;
  static late double _screenHeight;
  static late double _statusBarHeight;
  static late double _bottomBarHeight;
  static late Size _uiSize;
  static late ui.WindowPadding _padding;
  static late ui.WindowPadding _ins;

  /// Get the orientation of the screen.
  static Orientation get orientation => _orientation;
  static double get devicePixelRatio => _devicePixelRatio;

  /// Get the width of the screen.
  static double get screenWidth => _screenWidth;

  static ui.WindowPadding get padding => _padding;

  static ui.WindowPadding get ins => _ins;

  /// Get the height of the screen.
  static double get screenHeight => _screenHeight;

  static double get statusBarHeight => _statusBarHeight;

  static double get bottomBarHeight => _bottomBarHeight;

  /// Get the ratio of the screen width to the design width.
  static double get scaleWidth => _screenWidth / _uiSize.width;

  /// Get the ratio of the screen height to the design height.
  static double get scaleHeight => _screenHeight / _uiSize.height;

  /// Get the ratio of the text font to the design text font.
  static double get scaleFont => min(scaleWidth, scaleHeight);

  /// Get the mapping value of design width through width ratio.
  static double setWidth(num width) => scaleWidth * width;

  /// Get the mapping value of design height through height ratio.
  static double setHeight(num height) => scaleHeight * height;

  /// Get the mapping value of design text font through text font ratio.
  /// [allowFontScaling] is following system font scaling.
  static double setSp(num fontSize, {bool allowFontScaling = true}) =>
      allowFontScaling
          ? fontSize * scaleFont * _textScaleFactor
          : fontSize * scaleFont;
}
