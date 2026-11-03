import 'package:flutter/material.dart';
import 'package:flutter_ludyx/src/common/extensions/string_extension.dart';
import 'package:flutter_ludyx/src/common/types/lua_fn.dart';
import 'package:flutter_ludyx/src/components/components.dart';

abstract class BasicComponents {
  static Map<String, ComponentBuilder> items = {
    'text': TextComponent.new,
    'clickable': ClickableComponent.new,
    'multi': MultiComponent.new,
  };

  static void register() {
    for (var entry in items.entries) {
      Components.register(entry.key, entry.value);
    }
  }
}

class const TextComponent({super.key, required super.data})
    extends StatelessComponentWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      data['value'],
      style: switch (data['style']) {
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

  @override
  String get component => 'text';
}

class const ClickableComponent({super.key, required super.data})
    extends StatelessComponentWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: switch (data['onClick']) {
        LudyxFn fn => fn.call,
        _ => null,
      },
      child: Components.build(data['child']),
    );
  }

  @override
  String get component => 'clickable';
}

class const MultiComponent({super.key, required super.data})
    extends StatelessComponentWidget {
  @override
  Widget build(BuildContext context) {
    final MainAxisAlignment? alignment = switch (data['alignment']) {
      'start' => .start,
      'end' => .end,
      'center' => .center,
      'space_between' => .spaceBetween,
      'space_around' => .spaceAround,
      'space_evenly' => .spaceEvenly,
      _ => null,
    };
    final CrossAxisAlignment? crossAlignment = switch (data['crossAlignment']) {
      'start' => .start,
      'end' => .end,
      'center' => .center,
      'stretch' => .stretch,
      'baseline' => .baseline,
      _ => null,
    };

    return switch (data['direction']) {
      'horizontal' => Row(
        spacing: data['spacing'],
        mainAxisAlignment: alignment ?? .start,
        crossAxisAlignment: crossAlignment ?? .center,
        children: switch (data['children']) {
          List children =>
            children.map((child) => Components.build(child)).toList(),
          _ => [],
        },
      ),
      'vertical' => Column(
        spacing: (data['spacing'] as num?)?.toDouble() ?? 0,
        mainAxisAlignment: alignment ?? .start,
        crossAxisAlignment: crossAlignment ?? .center,
        children: switch (data['children']) {
          List children =>
            children.map((child) => Components.build(child)).toList(),
          _ => [],
        },
      ),
      _ => throw UnimplementedError(),
    };
  }

  @override
  String get component => 'multi';
}
