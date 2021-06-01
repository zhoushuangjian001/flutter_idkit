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
    _instance = IDKitScreenAdapter._()
      .._orientation = orientation
      .._screenHeight = constraints.maxHeight
      .._screenWidth = constraints.maxWidth;
    final Size _size = designSize ??= defaultUISize;
    _instance._uiSize =
        orientation == Orientation.portrait ? _size : _size.flipped;
    // The configure of device.
    final ui.SingletonFlutterWindow window =
        WidgetsBinding.instance?.window ?? ui.window;
    _instance
      .._devicePixelRatio = window.devicePixelRatio
      .._textScaleFactor = window.textScaleFactor
      .._statusBarHeight = window.padding.top
      .._bottomBarHeight = window.padding.bottom;
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
  Orientation get orientation => _orientation;

  /// Get the width of the screen.
  double get screenWidth => _screenWidth;

  /// Get the height of the screen.
  double get screenHeight => _screenHeight;

  double get statusBarHeight => _statusBarHeight;

  double get bottomBarHeight => _bottomBarHeight;

  /// Get the ratio of the screen width to the design width.
  double get scaleWidth => _screenWidth / _uiSize.width;

  /// Get the ratio of the screen height to the design height.
  double get scaleHeight => _screenHeight / _uiSize.height;

  /// Get the ratio of the text font to the design text font.
  double get scaleFont => min(scaleWidth, scaleHeight);

  /// Get the mapping value of design width through width ratio.
  double setWidth(num width) => scaleWidth * width;

  /// Get the mapping value of design height through height ratio.
  double setHeight(num height) => scaleHeight * height;

  /// Get the mapping value of design text font through text font ratio.
  /// [allowFontScaling] is following system font scaling.
  double setSp(num fontSize, {bool allowFontScaling = true}) => allowFontScaling
      ? fontSize * scaleFont * _textScaleFactor
      : fontSize * scaleFont;
}
