import 'package:flutter/material.dart'
    show StatefulWidget, Key, Widget, State, BuildContext, GestureDetector;
import 'package:flutter_idkit/src/common/idkit_tap.dart';
import 'package:rxdart/rxdart.dart';

class IDKitControl extends StatefulWidget {
  const IDKitControl({
    Key? key,
    required this.child,
    this.enable = true,
    this.onTap,
    this.onDoubleTap,
    this.duration,
  }) : super(key: key);

  /// The widget below this widget in the tree.
  final Widget child;

  /// Is the widget possible to interact, default [true].
  final bool enable;

  /// Single click event callback method.
  final IDKitTapCallback? onTap;

  /// Double click event callback method.
  final IDKitTapCallback? onDoubleTap;

  /// The duration is prevent clicking events repeated of widget.
  final Duration? duration;

  @override
  _IDKitControlState createState() => _IDKitControlState();
}

class _IDKitControlState extends State<IDKitControl> {
  late bool _enable;
  late PublishSubject<GestureDetectorType> _publishSubject;

  @override
  void initState() {
    super.initState();
    _enable = widget.enable;
    _publishSubject = PublishSubject<GestureDetectorType>()
      ..throttleTime(widget.duration ?? const Duration(microseconds: 500))
      ..listen((GestureDetectorType event) {
        switch (event) {
          case GestureDetectorType.onTap:
            widget.onTap?.call();
            break;
          case GestureDetectorType.onDoubleTap:
            widget.onDoubleTap?.call();
            break;
          default:
            widget.onTap?.call();
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: widget.child,
      onTap: _enable ? _onTap : null,
      onDoubleTap: _enable ? _onDoubleTap : null,
    );
  }

  // The onTap event.
  void _onTap() {
    if (widget.onTap != null) {
      _publishSubject.add(GestureDetectorType.onTap);
    }
  }

  // The onDoubleTap event.
  void _onDoubleTap() {
    if (widget.onDoubleTap != null) {
      _publishSubject.add(GestureDetectorType.onDoubleTap);
    }
  }

  // Is the widget can interact.
  bool _isWidgetEnable(IDKitControl widget) {
    return widget.enable &&
        (widget.onTap != null || widget.onDoubleTap != null);
  }

  // Component parameter update.
  @override
  void didUpdateWidget(IDKitControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isWidgetEnable(widget) == _isWidgetEnable(oldWidget)) {
      _enable = _isWidgetEnable(widget);
    }
  }

  // Destruction of page.
  @override
  void dispose() {
    _publishSubject.close();
    super.dispose();
  }
}

/// Event click type.
enum GestureDetectorType {
  onTap,
  onDoubleTap,
}
