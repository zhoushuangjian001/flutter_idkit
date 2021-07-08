import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

const String _textLayoutId = 'button_text';
const String _imageLayoutId = 'button_image';

class IDKitButton extends StatelessWidget {
  const IDKitButton({
    Key? key,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.title,
    this.imageChild,
    this.interval = 5,
    this.type = ButtonType.lr,
    this.onTap,
    this.enable = true,
    this.selecd = false,
    this.duration = const Duration(milliseconds: 500),
    this.textStyle,
    this.disableTextStyle,
    this.selecdTextStyle,
    this.decoration,
    this.disableDecoration,
    this.selecdDecoration,
    this.bgColor,
    this.disableBgColor,
    this.selecdBgColor,
    this.clipBehavior = Clip.none,
    this.overflow,
    this.textAlign,
    this.radius,
    this.shadowColor,
    this.elevation = 0,
    this.shadowRadius,
  })  : assert(duration != null),
        assert(interval > 0),
        assert(
          bgColor == null || decoration == null,
          'Cannot provide both a bgColor and a decoration\n'
          'To provide both, use "decoration: BoxDecoration(color: bgColor)".',
        ),
        assert(
          bgColor == null || disableDecoration == null,
          'Cannot provide both a bgColor and a disableDecoration\n'
          'To provide both, use "decoration: BoxDecoration(color: bgColor)".',
        ),
        assert(
          bgColor == null || selecdDecoration == null,
          'Cannot provide both a bgColor and a selecdDecoration\n'
          'To provide both, use "decoration: BoxDecoration(color: bgColor)".',
        ),
        assert(
          disableBgColor == null || disableDecoration == null,
          'Cannot provide both a disableBgColor and a disableDecoration\n'
          'To provide both, use "decoration: BoxDecoration(color: disableBgColor)".',
        ),
        assert(
          disableBgColor == null || decoration == null,
          'Cannot provide both a disableBgColor and a decoration\n'
          'To provide both, use "decoration: BoxDecoration(color: disableBgColor)".',
        ),
        assert(
          disableBgColor == null || selecdDecoration == null,
          'Cannot provide both a disableBgColor and a selecdDecoration\n'
          'To provide both, use "decoration: BoxDecoration(color: disableBgColor)".',
        ),
        assert(
          selecdBgColor == null || decoration == null,
          'Cannot provide both a selecdBgColor and a decoration\n'
          'To provide both, use "decoration: BoxDecoration(color: selecdBgColor)".',
        ),
        assert(
          selecdBgColor == null || disableDecoration == null,
          'Cannot provide both a selecdBgColor and a disableDecoration\n'
          'To provide both, use "decoration: BoxDecoration(color: selecdBgColor)".',
        ),
        assert(
          selecdBgColor == null || selecdDecoration == null,
          'Cannot provide both a selecdBgColor and a selecdDecoration\n'
          'To provide both, use "decoration: BoxDecoration(color: selecdBgColor)".',
        ),
        assert(radius != 0),
        assert(
          radius == null || decoration == null,
          'Cannot provide both a radius and a decoration\n'
          'To provide both, use "decoration: BoxDecoration(borderRadius: BorderRadius.circular)".',
        ),
        assert(
          radius == null || disableDecoration == null,
          'Cannot provide both a radius and a disableDecoration\n'
          'To provide both, use "decoration: BoxDecoration(borderRadius: BorderRadius.circular)".',
        ),
        assert(
          radius == null || selecdDecoration == null,
          'Cannot provide both a radius and a selecdDecoration\n'
          'To provide both, use "decoration: BoxDecoration(borderRadius: BorderRadius.circular)".',
        ),
        assert(
          shadowColor == null || decoration == null,
          'Cannot provide both a shadowColor and a decoration\n'
          'To provide both, use "decoration: BoxDecoration(boxShadow: <List<BoxShadow>>[])".',
        ),
        assert(
          shadowColor == null || disableDecoration == null,
          'Cannot provide both a shadowColor and a disableDecoration\n'
          'To provide both, use "decoration: BoxDecoration(boxShadow: <List<BoxShadow>>[])".',
        ),
        assert(
          shadowColor == null || selecdDecoration == null,
          'Cannot provide both a shadowColor and a selecdDecoration\n'
          'To provide both, use "decoration: BoxDecoration(boxShadow: <List<BoxShadow>>[])".',
        ),
        super(key: key);

  /// The width of button.
  final double? width;

  /// The height of button.
  final double? height;

  /// Empty space to inscribe inside the [decoration]. The [child], if any, is
  /// placed inside this padding.
  ///
  /// This padding is in addition to any padding inherent in the [decoration];
  /// see [Decoration.padding].
  final EdgeInsetsGeometry? padding;

  /// Empty space to surround the [decoration] and [child].
  final EdgeInsetsGeometry? margin;

  /// The title of button.
  final String? title;

  /// The image widget of button.
  final Image? imageChild;

  /// The space between the image and text of the button.
  final double interval;

  /// Button image and text typesetting form.
  final ButtonType? type;

  /// The property of buttons respond to events.
  final bool enable;

  /// The callback func of  button response event.
  final VoidCallback? onTap;

  /// The duration is button event throttle.
  final Duration duration;

  /// The property of button title.
  final TextStyle? textStyle;

  /// The property of inactive button title.
  final TextStyle? disableTextStyle;

  /// The decoration properties of button appearance.
  final Decoration? decoration;

  /// The decoration properties of inactive button appearance.
  final Decoration? disableDecoration;

  /// The background color property of the button.
  final Color? bgColor;

  /// The background color property of the inactive button.
  final Color? disableBgColor;

  /// The clipping shape of buttons' subcomponents.
  final Clip clipBehavior;

  /// This property is selected of button.
  final bool selecd;

  /// This property is selected style of button title.
  final TextStyle? selecdTextStyle;

  /// This property is selected background color of button.
  final Color? selecdBgColor;

  /// This property is selected decoration of button.
  final Decoration? selecdDecoration;

  /// How overflowing text should be handled.
  final TextOverflow? overflow;

  /// Whether and how to align text horizontally.
  final TextAlign? textAlign;

  /// Tangent angle of button.
  final double? radius;

  /// Shadow color of button.
  final Color? shadowColor;

  /// The height of the button shadow.
  final double? elevation;

  /// The tangent angle of the button's shadow.
  final double? shadowRadius;

  // Padding
  EdgeInsetsGeometry? get _paddingIncludingDecoration {
    late EdgeInsetsGeometry? decorationPadding;
    if (selecd) {
      if (selecdDecoration == null || selecdDecoration!.padding == null) {
        return padding;
      }
      decorationPadding = selecdDecoration!.padding;
    } else if (!enable) {
      if (disableDecoration == null || disableDecoration!.padding == null) {
        return padding;
      }
      decorationPadding = disableDecoration!.padding;
    } else {
      if (decoration == null || decoration!.padding == null) {
        return padding;
      }
      decorationPadding = decoration!.padding;
    }

    if (padding == null) {
      return decorationPadding;
    }
    return padding!.add(decorationPadding!);
  }

  // Build
  @override
  Widget build(BuildContext context) {
    Widget? current;
    late LayoutId? textLayoutWidget;
    late LayoutId? imageLayoutWidget;

    if (title != null && imageChild != null) {
      late final TextStyle? _style = enable ? textStyle : disableTextStyle;
      textLayoutWidget = LayoutId(
        id: _textLayoutId,
        child: Text(
          title!,
          textAlign: textAlign,
          style: selecd ? selecdTextStyle : _style,
          overflow: overflow,
        ),
      );
      imageLayoutWidget = LayoutId(id: _imageLayoutId, child: imageChild!);
      current = CustomMultiChildLayout(
        delegate: _IDKitButtonMultiChildLayoutDelegate(
          type: type,
          interval: interval,
        ),
        children: [textLayoutWidget, imageLayoutWidget],
      );
    } else {
      if (title == null && imageChild == null) {
        current = LimitedBox(
          maxWidth: 0.0,
          maxHeight: 0.0,
          child: ConstrainedBox(constraints: const BoxConstraints.expand()),
        );
      } else {
        late final TextStyle? _style = enable ? textStyle : disableTextStyle;
        current = CustomSingleChildLayout(
          delegate: _IDKitButtonSingleChildLayoutDelegate(),
          child: imageChild ??
              Text(
                title ?? '',
                style: selecd ? selecdTextStyle : _style,
                overflow: overflow,
                textAlign: textAlign,
              ),
        );
      }
    }

    // Padding
    final EdgeInsetsGeometry? effectivePadding = _paddingIncludingDecoration;
    if (effectivePadding != null) {
      assert(effectivePadding.isNonNegative,
          'The effectivePadding contain negative.');
      current = Padding(
        padding: effectivePadding,
        child: current,
      );
    }

    // Clipping patterns for components.
    if (clipBehavior != Clip.none) {
      if (selecd) {
        assert(selecdDecoration != null);
        current = ClipPath(
          clipper: _DecorationClipper(
            textDirection: Directionality.maybeOf(context),
            decoration: selecdDecoration!,
          ),
          clipBehavior: clipBehavior,
          child: current,
        );
      } else if (enable) {
        assert(decoration != null);
        current = ClipPath(
          clipper: _DecorationClipper(
            textDirection: Directionality.maybeOf(context),
            decoration: decoration!,
          ),
          clipBehavior: clipBehavior,
          child: current,
        );
      } else {
        assert(disableDecoration != null);
        current = ClipPath(
          clipper: _DecorationClipper(
            textDirection: Directionality.maybeOf(context),
            decoration: disableDecoration!,
          ),
          clipBehavior: clipBehavior,
          child: current,
        );
      }
    }

    // Decoration of
    if (decoration != null && enable && !selecd) {
      current = DecoratedBox(
        decoration: decoration!,
        child: current,
      );
    }

    // DisableDecoration
    if (disableDecoration != null && !enable && !selecd) {
      current = DecoratedBox(
        decoration: disableDecoration!,
        child: current,
      );
    }

    // SelecdDecoration
    if (selecdDecoration != null && selecd) {
      current = DecoratedBox(
        decoration: selecdDecoration!,
        child: current,
      );
    }

    // Color
    if (bgColor != null && enable && !selecd) {
      current = ColoredBox(
        color: bgColor!,
        child: current,
      );
    }

    if (disableBgColor != null && !enable && !selecd) {
      current = ColoredBox(
        color: disableBgColor!,
        child: current,
      );
    }

    if (selecdBgColor != null && selecd) {
      current = ColoredBox(
        color: selecdBgColor!,
        child: current,
      );
    }

    // Radius
    if (radius != null) {
      current = ClipRRect(
        borderRadius: BorderRadius.circular(radius!),
        child: current,
      );
    }

    // Margin
    if (margin != null) {
      assert(margin!.isNonNegative, 'The margin contain negative.');
      current = Padding(
        padding: margin!,
        child: current,
      );
    }

    // Enable
    if (enable) {
      current = GestureDetector(
        onTap: _throttle(() async {
          await Future<dynamic>.delayed(duration);
          onTap?.call();
        }),
        child: SizedBox(
          width: width,
          height: height,
          child: current,
        ),
      );
    } else {
      current = SizedBox(
        width: width,
        height: height,
        child: current,
      );
    }

    // ShadowColor
    if (shadowColor != null) {
      current = PhysicalModel(
        color: Colors.transparent,
        shadowColor: shadowColor!,
        child: current,
        elevation: elevation!,
        borderRadius:
            shadowRadius == null ? null : BorderRadius.circular(shadowRadius!),
      );
    }

    return current;
  }
}

// Click event throttling.
void Function() _throttle(Future<dynamic> Function() func) {
  bool enable = true;
  return () {
    if (enable == true) {
      enable = false;
      func().then((dynamic _) {
        enable = true;
      });
    }
  };
}

// MultiChildLayoutDelegate
class _IDKitButtonMultiChildLayoutDelegate extends MultiChildLayoutDelegate {
  _IDKitButtonMultiChildLayoutDelegate({required this.interval, this.type});
  final ButtonType? type;
  final double interval;

  @override
  void performLayout(Size size) {
    final Size imageSize =
        layoutChild(_imageLayoutId, BoxConstraints.loose(size));
    late double dx1, dx2, dy1, dy2;
    switch (type) {
      case ButtonType.rl:
        final Size _looseSize =
            Size(size.width - imageSize.width - interval, size.height);
        final Size textSize =
            layoutChild(_textLayoutId, BoxConstraints.loose(_looseSize));
        dx1 = (size.width - textSize.width - imageSize.width - interval) * 0.5;
        dy1 = (size.height - textSize.height) * 0.5;
        dy2 = (size.height - imageSize.height) * 0.5;
        positionChild(_textLayoutId, Offset(dx1, dy1));
        dx2 = dx1 + textSize.width + interval;
        positionChild(_imageLayoutId, Offset(dx2, dy2));
        break;
      case ButtonType.td:
        final Size _looseSize =
            Size(size.width, size.height - imageSize.height - interval);
        final Size textSize =
            layoutChild(_textLayoutId, BoxConstraints.loose(_looseSize));
        dx1 = (size.width - imageSize.width) * 0.5;
        dy1 =
            (size.height - imageSize.height - textSize.height - interval) * 0.5;
        dx2 = (size.width - textSize.width) * 0.5;
        positionChild(_imageLayoutId, Offset(dx1, dy1));
        dy2 = dy1 + imageSize.height + interval;
        positionChild(_textLayoutId, Offset(dx2, dy2));
        break;
      case ButtonType.dt:
        final Size _looseSize =
            Size(size.width, size.height - imageSize.height - interval);
        final Size textSize =
            layoutChild(_textLayoutId, BoxConstraints.loose(_looseSize));
        dx1 = (size.width - textSize.width) * 0.5;
        dy1 =
            (size.height - textSize.height - imageSize.height - interval) * 0.5;
        dx2 = (size.width - imageSize.width) * 0.5;
        positionChild(_textLayoutId, Offset(dx1, dy1));
        dy2 = dy1 + textSize.height + interval;
        positionChild(_imageLayoutId, Offset(dx2, dy2));
        break;
      default:
        final Size _looseSize =
            Size(size.width - imageSize.width - interval, size.height);
        final Size textSize =
            layoutChild(_textLayoutId, BoxConstraints.loose(_looseSize));
        dx1 = (size.width - textSize.width - imageSize.width - interval) * 0.5;
        dy1 = (size.height - imageSize.height) * 0.5;
        dy2 = (size.height - textSize.height) * 0.5;
        positionChild(_imageLayoutId, Offset(dx1, dy1));
        final double dx2 = dx1 + imageSize.width + interval;
        positionChild(_textLayoutId, Offset(dx2, dy2));
    }
  }

  @override
  bool shouldRelayout(
      covariant _IDKitButtonMultiChildLayoutDelegate oldDelegate) {
    return oldDelegate.interval != interval || oldDelegate.type != type;
  }
}

// Layout of individual components.
class _IDKitButtonSingleChildLayoutDelegate extends SingleChildLayoutDelegate {
  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // Loosen constraints of child
    return constraints.loosen();
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    // Drawing location of child
    final double dx = (size.width - childSize.width) * 0.5;
    final double dy = (size.height - childSize.height) * 0.5;
    return Offset(dx, dy);
  }

  @override
  bool shouldRelayout(
      covariant _IDKitButtonSingleChildLayoutDelegate oldDelegate) {
    return oldDelegate != this;
  }
}

/// The style of graphic layout.
enum ButtonType {
  lr,
  td,
  rl,
  dt,
}

/// A clipper that uses [Decoration.getClipPath] to clip.
class _DecorationClipper extends CustomClipper<Path> {
  _DecorationClipper({
    TextDirection? textDirection,
    required this.decoration,
  }) : textDirection = textDirection ?? TextDirection.ltr;

  final TextDirection textDirection;
  final Decoration decoration;

  @override
  Path getClip(Size size) {
    return decoration.getClipPath(Offset.zero & size, textDirection);
  }

  @override
  bool shouldReclip(_DecorationClipper oldClipper) {
    return oldClipper.decoration != decoration ||
        oldClipper.textDirection != textDirection;
  }
}
