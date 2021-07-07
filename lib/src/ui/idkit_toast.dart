import 'dart:async';
import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class IDKitToast {
  /// 便捷获取单利对象
  factory IDKitToast() {
    assert(_instance != null,
        'Please first call "factory IDKitToast.init(BuildContext context)" to initialize.');
    return _instance!;
  }

  /// 组件初始化
  factory IDKitToast.init(BuildContext context) => _instanceMethod(context);

  /// 属性的声明
  static IDKitToast? _instance;
  late BuildContext _context;
  late final List<String> _markList = <String>[];
  OverlayEntry? _overlayEntry;
  late final GlobalKey<_ToastAnimationdState> _key = GlobalKey();
  Completer<bool>? completer;
  static IDKitToast _instanceMethod(BuildContext context) {
    return _instance ??= IDKitToast._init(context);
  }

  IDKitToast._init(BuildContext context) {
    _context = context;
  }

  /// 单独文本自动弹框
  ///
  /// [text] : 要展示文本
  /// [style] : 要展示弹框样式
  /// [type] : 弹框展示动画类型
  /// [animationDuration] : 弹框内容执行动画时间, 默认 1 秒
  /// [existDuration] : 内容展示时间，默认 3 秒
  /// [alignment] : 弹框内容展示位置，默认中间
  void showText({
    required String text,
    ToastStyle? style,
    AnimationType type = AnimationType.none,
    Duration? animationDuration,
    Duration? existDuration,
    AlignmentGeometry alignment = Alignment.center,
  }) {
    diyAutoToast(
      child: Text(text, style: style?.textStyle, maxLines: style?.maxLine),
      type: type,
      style: style,
      alignment: alignment,
      animationDuration: animationDuration,
      existDuration: existDuration,
    );
  }

  /// 自定义内容的自动弹框
  ///
  /// [child] : 要展组件
  /// [style] : 要展示弹框样式
  /// [type] : 弹框展示动画类型
  /// [animationDuration] : 弹框内容执行动画时间, 默认 1 秒
  /// [existDuration] : 内容展示时间，默认 3 秒
  /// [alignment] : 弹框内容展示位置，默认中间
  void diyAutoToast({
    required Widget child,
    ToastStyle? style,
    AnimationType type = AnimationType.none,
    Duration? animationDuration,
    Duration? existDuration,
    AlignmentGeometry alignment = Alignment.center,
  }) {
    if (_markList.isNotEmpty) {
      _markList.clear();
      _overlayEntry?.remove();
      _overlayEntry = null;
    }

    if (_overlayEntry != null) {
      return;
    }
    _addAnimation(
      child: child,
      auto: true,
      style: style,
      type: type,
      alignment: alignment,
      existDuration: existDuration,
      animationDuration: animationDuration,
    );
  }

  /// 自定义加载弹框
  ///
  /// [text] : 要展示文本
  /// [style] : 要展示弹框样式
  /// [type] : 弹框展示动画类型
  /// [animationDuration] : 弹框内容执行动画时间, 默认 1 秒
  /// [alignment] : 弹框内容展示位置，默认中间
  void loading({
    String? text,
    ToastStyle? style,
    Duration? animationDuration,
    AnimationType type = AnimationType.none,
    AlignmentGeometry alignment = Alignment.center,
  }) {
    late Widget child;
    if (text != null) {
      child = Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(
            width: 80,
            height: 80,
            child: CupertinoActivityIndicator(radius: 20),
          ),
          Text(text, style: style?.textStyle, maxLines: style?.maxLine)
        ],
      );
    } else {
      child = const SizedBox(
        width: 80,
        height: 80,
        child: CupertinoActivityIndicator(radius: 20),
      );
    }
    diyLoading(
      child: child,
      type: type,
      style: style,
      alignment: alignment,
      animationDuration: animationDuration,
    );
  }

  /// 自定义加载弹框
  ///
  /// [child] : 要展组件
  /// [style] : 要展示弹框样式
  /// [type] : 弹框展示动画类型
  /// [animationDuration] : 弹框内容执行动画时间, 默认 1 秒
  /// [alignment] : 弹框内容展示位置，默认中间
  void diyLoading({
    required Widget child,
    ToastStyle? style,
    Duration? animationDuration,
    AnimationType type = AnimationType.none,
    AlignmentGeometry alignment = Alignment.center,
  }) {
    if (_markList.isEmpty) {
      if (_overlayEntry != null) {
        _overlayEntry?.remove();
        _overlayEntry = null;
      }
      _addAnimation(
        auto: false,
        type: type,
        child: child,
        style: style,
        alignment: alignment,
        animationDuration: animationDuration,
      );
    }
    _markList.add('com.idkit.loading');
  }

  // 添加动画
  void _addAnimation({
    required Widget child,
    required bool auto,
    ToastStyle? style,
    Duration? existDuration,
    Duration? animationDuration,
    AnimationType type = AnimationType.none,
    AlignmentGeometry alignment = Alignment.center,
  }) {
    completer = Completer<bool>();
    _overlayEntry = OverlayEntry(builder: (_) {
      return Material(
        color: style?.baseBgColor ?? Colors.black12,
        child: SafeArea(
          child: ToastAnimationd(
            key: auto ? null : _key,
            child: child,
            auto: auto,
            type: type,
            style: style,
            alignment: alignment,
            existDuration: existDuration,
            animationDuration: animationDuration,
            end: () {
              _overlayEntry?.remove();
              _overlayEntry = null;
              completer?.complete(true);
            },
          ),
        ),
      );
    });
    Overlay.of(_context)?.insert(_overlayEntry!);
  }

  /// 清除弹框
  Future<bool> dismiss() async {
    if (_markList.length > 1) {
      _markList.removeLast();
      return false;
    }
    if (_markList.isNotEmpty) {
      _markList.clear();
      _key.currentState?.dismissToast();
      return completer!.future;
    }

    // 自动强制清除
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      return true;
    }
    return false;
  }
}

// 弹框动画组件
class ToastAnimationd extends StatefulWidget {
  const ToastAnimationd({
    Key? key,
    required this.child,
    required this.auto,
    required Function() this.end,
    this.style,
    this.type,
    this.animationDuration,
    this.existDuration,
    this.alignment,
  }) : super(key: key);

  final Widget child;
  final bool auto;
  final Function end;
  final ToastStyle? style;
  final AnimationType? type;
  final Duration? existDuration;
  final Duration? animationDuration;
  final AlignmentGeometry? alignment;

  @override
  _ToastAnimationdState createState() => _ToastAnimationdState();
}

class _ToastAnimationdState extends State<ToastAnimationd>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  late Duration _duration;
  late bool _animation;

  @override
  void initState() {
    super.initState();
    // 自动模式
    if (widget.auto) {
      _duration = widget.existDuration ?? const Duration(seconds: 3);
    }

    // 是否添加动画控制器,并监听动画状态
    _animation = widget.type != AnimationType.none;
    if (_animation) {
      _animationController = AnimationController(
        duration: widget.animationDuration ?? const Duration(seconds: 1),
        reverseDuration: const Duration(milliseconds: 500),
        vsync: this,
      );
      _animationController?.addStatusListener(
        (AnimationStatus status) {
          // 放弃枚举，因为其他类型可不处理
          if (status == AnimationStatus.completed) {
            if (widget.auto) {
              Future<dynamic>.delayed(
                  _duration, () => _animationController?.reverse());
            }
          } else if (status == AnimationStatus.dismissed) {
            widget.end.call();
          }
        },
      );
    }
  }

  @override
  void didUpdateWidget(covariant ToastAnimationd oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  /// 结束弹框
  void dismissToast() {
    if (_animation) {
      _animationController?.reverse();
    } else {
      widget.end.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget current = Align(
      alignment: widget.alignment ?? Alignment.center,
      child: Card(
        color: widget.style?.bgColor,
        shape: widget.style?.radius == null
            ? null
            : RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(widget.style!.radius!)),
        margin: widget.style?.margin,
        child: Padding(
          padding: widget.style?.padding ??
              const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: widget.child,
        ),
      ),
    );
    switch (widget.type) {
      case AnimationType.fade:
        current = FadeTransition(
          opacity: Tween<double>(begin: 0.0, end: 1.0)
              .animate(_animationController!),
          child: current,
        );
        break;
      case AnimationType.scale:
        current = ScaleTransition(
          scale: Tween<double>(begin: 0.0, end: 1.0)
              .animate(_animationController!),
          child: current,
        );
        break;
      case AnimationType.flyin:
        current = SlideTransition(
          position:
              Tween<Offset>(begin: const Offset(1, 0), end: const Offset(0, 0))
                  .animate(_animationController!),
          child: current,
        );
        break;
      default:
        if (widget.auto) {
          Future<dynamic>.delayed(_duration, () => widget.end.call());
        }
    }
    _animationController?.forward();
    return current;
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }
}

/// 动画类型
enum AnimationType {
  fade,
  scale,
  flyin,
  none,
}

/// 弹框的样式
class ToastStyle {
  const ToastStyle({
    this.baseBgColor,
    this.bgColor,
    this.textStyle,
    this.maxLine,
    this.margin,
    this.padding,
    this.radius,
  });

  final Color? baseBgColor;
  final Color? bgColor;
  final TextStyle? textStyle;
  final int? maxLine;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? radius;

  @override
  String toString() {
    return 'ToastStyle(baseBgColor:${baseBgColor ?? Colors.white},bgColor:${bgColor ?? Colors.white}),textStyle:${objectRuntimeType(textStyle, 'TextStyle')},maxLine:${maxLine ?? 1}))';
  }
}
