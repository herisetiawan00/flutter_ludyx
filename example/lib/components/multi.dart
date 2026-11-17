import 'package:flutter_ludyx_annotations/flutter_ludyx_annotations.dart';
import 'package:material_ui/material_ui.dart';

@LudyxComponent('multi')
class MultiWidget extends StatelessWidget {
  final MainAxisAlignment? alignment;
  final CrossAxisAlignment? crossAlignment;
  final double? spacing;
  final Axis direction;
  final List<Widget> children;

  const new({
    super.key,
    this.alignment,
    this.crossAlignment,
    this.spacing,
    required this.children,
    required this.direction,
  });

  @override
  Widget build(BuildContext context) {
    return switch (direction) {
      .horizontal => Row(
        spacing: spacing ?? 0,
        mainAxisAlignment: alignment ?? .start,
        crossAxisAlignment: crossAlignment ?? .center,
        children: children,
      ),
      .vertical => Column(
        spacing: spacing ?? 0,
        mainAxisAlignment: alignment ?? .start,
        crossAxisAlignment: crossAlignment ?? .center,
        children: children,
      ),
    };
  }
}
