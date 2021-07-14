import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class IDkitGuide {
  // 单利
  factory IDkitGuide() => _instanceMethod();
  IDkitGuide._init();

  static IDkitGuide? _instance;
  static IDkitGuide _instanceMethod() => _instance ??= IDkitGuide._init();

  // 蒙层
  OverlayEntry? _overlayEntry;

  /// 展示指引层
  ///
  /// context: 指引页的上下文
  /// children: 要指引显示的元素配置集合
  /// dtcInterval: 扣取区域距离提示文本距离
  /// ctbInterval: 提示文本距离按钮的距离
  /// buttonHeight: 按钮的默认高度
  /// widthRadio: 提示文本的宽度和视图宽度的比值
  /// debitedExpand: 扣取区域扩展大小
  void showGuide(
    BuildContext context, {
    required List<GuideModel> children,
    double dtcInterval = 10,
    double ctbInterval = 5,
    double buttonHeight = 30,
    double widthRadio = 0.6,
    double debitedExpand = 2,
    EdgeInsetsGeometry btnPadding =
        const EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
    double debitedRadius = 5,
  }) {
    if (_overlayEntry != null) {
      return;
    }
    _overlayEntry = OverlayEntry(builder: (_) {
      return _GuidePage(
        children: children,
        dtcInterval: dtcInterval,
        ctbInterval: ctbInterval,
        buttonHeight: buttonHeight,
        widthRadio: widthRadio,
        debitedExpand: debitedExpand,
        debitedRadius: debitedRadius,
        btnPadding: btnPadding,
        end: () {
          _overlayEntry?.remove();
          _overlayEntry = null;
        },
      );
    });
    Overlay.of(context)?.insert(_overlayEntry!);
  }
}

/// 内容实现
class _GuidePage extends StatefulWidget {
  const _GuidePage({
    Key? key,
    required this.end,
    required this.children,
    required this.widthRadio,
    required this.btnPadding,
    required this.dtcInterval,
    required this.ctbInterval,
    required this.buttonHeight,
    required this.debitedExpand,
    required this.debitedRadius,
  }) : super(key: key);

  final Function() end;
  final double dtcInterval;
  final double ctbInterval;
  final List<GuideModel> children;
  final double buttonHeight;
  final double widthRadio;
  final double debitedExpand;
  final EdgeInsetsGeometry btnPadding;
  final double debitedRadius;

  @override
  __GuidePageState createState() => __GuidePageState();
}

class __GuidePageState extends State<_GuidePage> {
  // 当前索引
  late int curIndex = 0;
  // 扣取索引的流控制器
  late StreamController<Assist> assistStream =
      StreamController<Assist>.broadcast();

  // 计算扣取区域矩形
  Rect _getDeductRect(GuideModel model) {
    final RenderBox renderBox = _getRenderBoxAtIndex(model);
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;
    final Rect rect =
        Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height);
    return rect.inflate(model.debitedExpand ?? widget.debitedExpand);
  }

  // 获取每个组件的渲染 RenderBox 对象
  RenderBox _getRenderBoxAtIndex(GuideModel model) {
    final RenderObject? renderObject =
        model.markKey.currentContext?.findRenderObject();
    assert(renderObject != null, '获取组件的渲染对象失败。');
    return renderObject! as RenderBox;
  }

  // 调整视图
  Future<bool> adjustView(GuideModel model) async {
    // 获取当前元素
    if (model.scrollController != null) {
      final double? distance = model.scrollDistance;
      if (distance != null) {
        model.scrollController!.jumpTo(distance);
        return true;
      }
    }
    return false;
  }

  /// 获取控制对象
  Assist _getAssistAtIndex(BuildContext context, int index) {
    final GuideModel model = widget.children[index];
    // 扣去视图大小
    final Rect dstRect = _getDeductRect(model);
    // 获取屏幕大小
    final Size screenSize = MediaQuery.of(context).size;
    // 绘制文本高度
    final double contentWidth = screenSize.width * widget.widthRadio;
    // 文本绘制对象
    final ui.Paragraph paragraph = _getParagraph(context, model, contentWidth);
    // 获取文本绘制方位
    late PositionType positionType;
    final double bottomLast = screenSize.height -
        dstRect.bottom -
        widget.dtcInterval -
        widget.ctbInterval;
    if (bottomLast > 0) {
      positionType = PositionType.bottom;
    } else {
      positionType = PositionType.top;
    }
    // 获取按钮的绘制方位
    late ButtonPosition buttonPosition;
    final double rightLast = screenSize.width - dstRect.left;
    if (rightLast > contentWidth) {
      buttonPosition = ButtonPosition.left;
    } else {
      buttonPosition = ButtonPosition.right;
    }

    return Assist(
      model: model,
      dstRect: dstRect,
      paragraph: paragraph,
      screenSize: screenSize,
      position: buttonPosition,
      positionType: positionType,
      widthRadio: widget.widthRadio,
      btnHeight: widget.buttonHeight,
      dtcInterval: widget.dtcInterval,
      ctbInterval: widget.ctbInterval,
      debitedRadius: widget.debitedRadius,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StreamBuilder<Assist>(
          stream: assistStream.stream,
          initialData: _getAssistAtIndex(context, 0),
          builder: (_, AsyncSnapshot<Assist> snapshot) {
            final Assist assist = snapshot.data!;
            return SizedBox.expand(
              child: CustomPaint(
                painter: _DeductPainter(assist: assist),
                foregroundPainter: _ParagraphPainter(assist: assist),
              ),
            );
          },
        ),
        StreamBuilder<Assist>(
          stream: assistStream.stream,
          initialData: _getAssistAtIndex(context, 0),
          builder: (_, AsyncSnapshot<Assist> snapshot) {
            final Assist assist = snapshot.data!;
            return Positioned(
              top: assist.top(),
              left: assist.left(),
              right: assist.right(),
              child: GestureDetector(
                onTap: () async {
                  curIndex += 1;
                  if (curIndex < widget.children.length) {
                    final GuideModel model = widget.children[curIndex];
                    final bool isDelay = await adjustView(model);
                    if (isDelay) {
                      await Future<dynamic>.delayed(
                          const Duration(seconds: 1), null);
                    }
                    final Assist assist = _getAssistAtIndex(context, curIndex);
                    assistStream.add(assist);
                  } else {
                    widget.end.call();
                  }
                },
                child: UnconstrainedBox(
                  child: Card(
                    margin: EdgeInsets.zero,
                    child: SizedBox(
                      height: assist.model.btnHeight ?? widget.buttonHeight,
                      width: assist.model.btnWidth,
                      child: Container(
                        decoration: assist.model.btnDecoration,
                        alignment: Alignment.center,
                        padding: assist.model.btnPadding ?? widget.btnPadding,
                        child: Text(
                          assist.model.buttonTitle,
                          style: assist.model.btnTextStyle,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // 释放控制器
  @override
  void dispose() {
    assistStream.close();
    super.dispose();
  }
}

// 绘制中继
class Assist {
  const Assist({
    required this.model,
    required this.dstRect,
    required this.position,
    required this.paragraph,
    required this.screenSize,
    required this.positionType,
    required this.dtcInterval,
    required this.ctbInterval,
    required this.btnHeight,
    required this.widthRadio,
    required this.debitedRadius,
  });
  final Rect dstRect;
  final Size screenSize;
  final GuideModel model;
  final ui.Paragraph paragraph;
  final ButtonPosition position;
  final PositionType positionType;
  final double dtcInterval;
  final double ctbInterval;
  final double btnHeight;
  final double widthRadio;
  final double debitedRadius;

  double? left() {
    if (position == ButtonPosition.left) {
      return dstRect.left;
    }
    return null;
  }

  double? right() {
    if (position == ButtonPosition.right) {
      return screenSize.width - dstRect.right;
    }
    return null;
  }

  double? top() {
    if (positionType == PositionType.top) {
      return dstRect.top -
          paragraph.height -
          dtcInterval -
          ctbInterval -
          btnHeight;
    } else {
      return dstRect.bottom + paragraph.height + dtcInterval + ctbInterval;
    }
  }

  @override
  String toString() {
    return 'Assist(dstRect:$dstRect,paragraph:$paragraph,positionType:$positionType, position:$position)';
  }
}

// 提示文字位置方位
enum PositionType { top, bottom }
// 按钮位置方位
enum ButtonPosition { left, right }

/// 获取文本段落对象
ui.Paragraph _getParagraph(
    BuildContext context, GuideModel model, double width) {
  final ui.ParagraphBuilder paragraphBuilder =
      ui.ParagraphBuilder(ui.ParagraphStyle());
  if (model.contentTextStyle != null) {
    paragraphBuilder.pushStyle(model.contentTextStyle!);
  }

  paragraphBuilder.addText(model.tipContent);
  final ui.ParagraphConstraints paragraphConstraints =
      ui.ParagraphConstraints(width: width);
  final ui.Paragraph paragraph = paragraphBuilder.build()
    ..layout(paragraphConstraints);
  return paragraph;
}

// 绘制提示文本
class _ParagraphPainter extends CustomPainter {
  const _ParagraphPainter({required this.assist});
  final Assist assist;

  @override
  void paint(Canvas canvas, Size size) {
    late double dx;
    if (assist.position == ButtonPosition.left) {
      dx = assist.dstRect.left;
    } else {
      dx = assist.dstRect.right - size.width * assist.widthRadio;
    }
    late double dy;
    if (assist.positionType == PositionType.top) {
      dy = assist.dstRect.top - assist.paragraph.height - assist.dtcInterval;
    } else {
      dy = assist.dstRect.bottom + assist.dtcInterval;
    }
    canvas.drawParagraph(assist.paragraph, Offset(dx, dy));
  }

  @override
  bool shouldRepaint(covariant _ParagraphPainter oldDelegate) {
    return oldDelegate.assist != assist;
  }
}

/// 绘制扣取视图
class _DeductPainter extends CustomPainter {
  const _DeductPainter({required this.assist});
  final Assist assist;

  @override
  void paint(Canvas canvas, Size size) {
    // 声明画笔对象
    final Paint paint = Paint();
    canvas.save();
    // 创建遮罩层
    paint.color = Colors.black54;
    canvas.saveLayer(Offset.zero & size, paint);
    canvas.drawRect(Offset.zero & size, paint);

    // 扣去区域
    paint.blendMode = BlendMode.dstOut;
    canvas.drawRRect(
        RRect.fromRectAndRadius(
          assist.dstRect,
          Radius.circular(assist.model.debitedRadius ?? assist.debitedRadius),
        ),
        paint);

    // 释放图层
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _DeductPainter oldDelegate) {
    // 是否从新绘制
    return oldDelegate.assist != assist;
  }
}

/// 元素配置对象
class GuideModel {
  const GuideModel({
    required this.markKey,
    required this.tipContent,
    required this.buttonTitle,
    this.btnWidth,
    this.btnHeight,
    this.btnPadding,
    this.btnDecoration,
    this.btnTextStyle,
    this.contentTextStyle,
    this.scrollController,
    this.scrollDistance,
    this.debitedExpand,
    this.debitedRadius,
  });

  /// 元素的标识 key
  final GlobalKey markKey;

  /// 要提示的文本内容
  final String tipContent;

  /// 按钮的文字
  final String buttonTitle;

  /// 按钮的宽度
  final double? btnWidth;

  /// 按钮的高度
  final double? btnHeight;

  /// 按钮文字距离边缘的边距
  final EdgeInsetsGeometry? btnPadding;

  /// 按钮的装饰对象
  final BoxDecoration? btnDecoration;

  /// 按钮文字的样式
  final TextStyle? btnTextStyle;

  /// 提示文本的样式
  final ui.TextStyle? contentTextStyle;

  /// 元素所在滚动组件的控制器
  final ScrollController? scrollController;

  /// 元素要滚动多少才能出现在可视视图的距离
  final double? scrollDistance;

  /// 扣取范围的增加量
  final double? debitedExpand;

  /// 扣取范围的轮廓的圆角
  final double? debitedRadius;

  @override
  String toString() {
    return 'GuideModel(markKey:$markKey, tipContent:$tipContent, buttonTitle:$buttonTitle '
        'btnWidth:$btnWidth,btnHeight:$btnHeight,btnPadding:$btnPadding,btnDecoration:$btnDecoration)'
        'btnTextStyle:$btnTextStyle,btnTextStyle:$btnTextStyle,contentTextStyle:$contentTextStyle'
        'scrollController:$scrollController,scrollDistance:$scrollDistance,debitedExpand:$debitedExpand'
        'debitedRadius:$debitedRadius';
  }
}
