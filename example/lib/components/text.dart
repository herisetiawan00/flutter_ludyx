import 'package:flutter_ludyx_annotations/flutter_ludyx_annotations.dart';
import 'package:material_ui/material_ui.dart';
import 'package:ludyx_example/common/extensions/string_extension.dart';

@LudyxComponent('text')
class TextWidget extends StatelessWidget {
  final String value;
  final Map<String, dynamic>? style;

  const new({super.key, required this.value, this.style});

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: switch (style) {
        Map style => TextStyle(
          fontSize: (style['fontSize'] as num).toDouble(),
          fontFamily: style['fontFamily'],
          fontWeight: switch (style['fontWeight']) {
            int fontWeight => .new(fontWeight),
            _ => null,
          },
          fontStyle: switch (style['fontStyle']) {
            String fontStyle => .values.byName(fontStyle),
            _ => null,
          },
          color: switch (style['color']) {
            String color => color.toColor(),
            _ => null,
          },
          backgroundColor: switch (style['backgroundColor']) {
            String color => color.toColor(),
            _ => null,
          },
        ),
        _ => null,
      },
    );
  }
}
