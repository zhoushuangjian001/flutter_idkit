import 'package:flutter/material.dart'
    show
        Axis,
        BoxConstraints,
        BuildContext,
        Canvas,
        Center,
        Color,
        Colors,
        CustomPaint,
        CustomPainter,
        Key,
        LayoutBuilder,
        Offset,
        Paint,
        Size,
        SizedBox,
        StatelessWidget,
        Widget;

/// IDKitDivider
class IDKitDivider extends StatelessWidget {
  /// This widget is used for drawing lines, including solid line, dotted line and dot line.
  /// The [type] is set draw line type,default is solid.
  const IDKitDivider({
    Key? key,
    this.height,
    this.width,
    this.thickness,
    this.indent,
    this.endIndent,
    this.dottedUnitLength,
    this.dottedUnitInterval,
    this.color,
    this.axis = Axis.horizontal,
    this.type = LineType.solid,
  })  : assert(height == null || width == null,
            'Can not provide width and height at the same time.'),
        super(key: key);

  /// The height of the widget.
  final double? height;

  /// The width of the widget.
  final double? width;

  /// The thickness of the line.
  final double? thickness;

  /// The dottedUnitLength is unit length of dotted line.
  final double? dottedUnitLength;

  /// The dottedUnitInterval is unit interval of dotted line.
  final double? dottedUnitInterval;

  /// The beginning of the line is indented.
  final double? indent;

  /// The end indent of the line.
  final double? endIndent;

  /// The color of draw line.
  final Color? color;

  /// The axis of draw line.
  final Axis axis;

  /// The type of draw line.
  final LineType type;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Center(
        child: LayoutBuilder(
          builder: (_, BoxConstraints constraints) {
            return CustomPaint(
              size: Size(constraints.maxWidth, constraints.maxHeight),
              painter: _DividerPainter(
                color: color ?? Colors.black,
                axis: axis,
                type: type,
                thickness: thickness ?? 1,
                indent: indent ?? 0,
                endIndent: endIndent ?? 0,
                dottedUnitInterval: dottedUnitInterval ?? 3,
                dottedUnitLength: dottedUnitLength ?? 5,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DividerPainter extends CustomPainter {
  _DividerPainter({
    this.axis,
    this.type,
    this.color,
    this.thickness,
    this.indent,
    this.endIndent,
    this.dottedUnitLength,
    this.dottedUnitInterval,
  });
  final Axis? axis;
  final LineType? type;
  final Color? color;
  final double? thickness;
  final double? indent;
  final double? endIndent;
  final double? dottedUnitLength;
  final double? dottedUnitInterval;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    final Paint paint = Paint()
      ..color = color!
      ..strokeWidth = thickness!;
    final bool isAxis = axis == Axis.horizontal;

    switch (type) {
      case LineType.dotted:
        drawDotted(canvas, size, paint, isAxis, indent, endIndent,
            dottedUnitLength, dottedUnitInterval);
        break;
      case LineType.dot:
        drawDot(canvas, size, paint, isAxis, indent, endIndent,
            dottedUnitLength, dottedUnitInterval);
        break;
      default:
        drawSolid(canvas, size, paint, isAxis, indent, endIndent);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _DividerPainter oldDelegate) {
    if (oldDelegate.axis != axis ||
        oldDelegate.color != color ||
        oldDelegate.dottedUnitInterval != dottedUnitInterval ||
        oldDelegate.dottedUnitLength != dottedUnitLength ||
        oldDelegate.endIndent != endIndent ||
        oldDelegate.indent != indent) {
      return true;
    }
    return false;
  }
}

// Draw Dot lines.
extension _PainterDot on _DividerPainter {
  void drawDot(
    Canvas canvas,
    Size size,
    Paint paint,
    bool isAxis,
    double? indent,
    double? endIndent,
    double? dottedUnitLength,
    double? dottedUnitInterval,
  ) {
    final double lastLength =
        (isAxis ? size.width : size.height) - indent! - endIndent!;
    final double paintWidth = paint.strokeWidth;
    final double paintStartPoint = paintWidth * 0.5;

    final double minUnitLength =
        (dottedUnitLength! + dottedUnitInterval!) * 2 + paintWidth;
    assert(lastLength > minUnitLength,
        'The layout is not suitable for dot line drawing.');

    double cellLength = dottedUnitLength + dottedUnitInterval * 2 + paintWidth;
    final double intactLength = lastLength - dottedUnitLength;
    final int count = intactLength ~/ cellLength;

    dottedUnitInterval =
        (intactLength - count * (dottedUnitLength + paintWidth)) / (count * 2);
    cellLength = dottedUnitLength + dottedUnitInterval * 2 + paintWidth;

    for (int i = 0; i <= count; i++) {
      final double offset = cellLength * i + indent;

      final double p1dx = isAxis ? offset : paintStartPoint;
      final double p1dy = isAxis ? paintStartPoint : offset;
      final Offset p1 = Offset(p1dx, p1dy);
      final Offset p2 = isAxis
          ? p1.translate(dottedUnitLength, 0)
          : p1.translate(0, dottedUnitLength);
      canvas.drawLine(p1, p2, paint);

      if (i == count) {
        break;
      }
      final double circleOffset = dottedUnitInterval + paintStartPoint;
      canvas.drawCircle(
          isAxis
              ? p2.translate(circleOffset, 0)
              : p2.translate(0, circleOffset),
          paintStartPoint,
          paint);
    }
  }
}

// Draw dotted lines.
extension _PainterDotted on _DividerPainter {
  void drawDotted(
    Canvas canvas,
    Size size,
    Paint paint,
    bool isAxis,
    double? indent,
    double? endIndent,
    double? dottedUnitLength,
    double? dottedUnitInterval,
  ) {
    final double lastLength =
        (isAxis ? size.width : size.height) - indent! - endIndent!;
    final double minLength = dottedUnitLength! * 2 + dottedUnitInterval!;
    assert(lastLength > minLength,
        'The layout is not suitable for dotted line drawing.');
    double cellLength = dottedUnitLength + dottedUnitInterval;
    final double intactLength = lastLength - dottedUnitLength;
    final int count = intactLength ~/ cellLength;

    dottedUnitInterval = (intactLength - count * dottedUnitLength) / count;
    cellLength = dottedUnitLength + dottedUnitInterval;
    final double paintStartPoint = paint.strokeWidth * 0.5;

    for (int i = 0; i <= count; i++) {
      final double offset = cellLength * i + indent;
      final double p1dx = isAxis ? offset : paintStartPoint;
      final double p1dy = isAxis ? paintStartPoint : offset;
      final Offset p1 = Offset(p1dx, p1dy);
      final Offset p2 = isAxis
          ? p1.translate(dottedUnitLength, 0)
          : p1.translate(0, dottedUnitLength);
      canvas.drawLine(p1, p2, paint);
    }
  }
}

// Draw solid lines.
extension _PainterSolid on _DividerPainter {
  void drawSolid(
    Canvas canvas,
    Size size,
    Paint paint,
    bool isAxis,
    double? indent,
    double? endIndent,
  ) {
    final double paintStartPoint = paint.strokeWidth * 0.5;

    final double p1dx = isAxis ? indent! : paintStartPoint;
    final double p1dy = isAxis ? paintStartPoint : indent!;
    final Offset p1 = Offset(p1dx, p1dy);

    final double p2dx = isAxis ? size.width - endIndent! : paintStartPoint;
    final double p2dy = isAxis ? paintStartPoint : size.height - endIndent!;
    final Offset p2 = Offset(p2dx, p2dy);
    canvas.drawLine(p1, p2, paint);
  }
}

/// The type of drawing line.
enum LineType {
  solid,
  dotted,
  dot,
}
