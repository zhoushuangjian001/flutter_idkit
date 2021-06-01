import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_idkit/src/common/idkit_tap.dart';
import 'package:flutter_idkit/src/function/idkit_screen_adapter.dart';

class IDKitScreen extends StatelessWidget {
  const IDKitScreen({
    Key? key,
    required this.builder,
    this.designSize,
    this.isFollow,
  })  : assert(builder != null),
        super(key: key);

  final IDKitScreenBuilder builder;

  final Size? designSize;

  final bool? isFollow;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQueryData.fromWindow(
            WidgetsBinding.instance?.window ?? ui.window),
        child: LayoutBuilder(builder: (_, BoxConstraints constraints) {
          return OrientationBuilder(builder: (_, Orientation orientation) {
            if (constraints.maxHeight != 0 || constraints.maxWidth != 0) {
              IDKitScreenAdapter.build(
                constraints,
                orientation,
                designSize: designSize,
              );
              return builder.call();
            }
            throw 'The upper transitive constraint [maxHeight] and [maxWidth] is zero.';
          });
        }));
  }
}
