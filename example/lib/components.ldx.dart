// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// LudyxAggregatorGenerator
// **************************************************************************

// ignore_for_file: sort_child_properties_last
import 'package:flutter/widgets.dart';
import 'package:flutter_ludyx/flutter_ludyx.dart';
import 'package:ludyx_example/components/clickable.dart';
import 'package:ludyx_example/components/multi.dart';
import 'package:ludyx_example/components/text.dart';

class _$ClickableWidgetComponent extends StatelessComponentWidget {
  const new({super.key, required super.data});

  @override
  Widget build(BuildContext context) => ClickableWidget(
    onClick: () => (data['onClick'] as LudyxFn).call([]),
    child: Components.build(data['child']),
  );

  @override
  String get component => 'clickable';
}

class _$MultiWidgetComponent extends StatelessComponentWidget {
  const new({super.key, required super.data});

  @override
  Widget build(BuildContext context) => MultiWidget(
    alignment: data['alignment'] != null
        ? MainAxisAlignment.values.byName(data['alignment'] as String)
        : null,
    crossAlignment: data['crossAlignment'] != null
        ? CrossAxisAlignment.values.byName(data['crossAlignment'] as String)
        : null,
    spacing: data['spacing'] != null
        ? (data['spacing'] as num).toDouble()
        : null,
    children: List<Map<String, dynamic>>.from(data['children'])
        .map(Components.build)
        .toList(),
    direction: Axis.values.byName(data['direction'] as String),
  );

  @override
  String get component => 'multi';
}

class _$TextWidgetComponent extends StatelessComponentWidget {
  const new({super.key, required super.data});

  @override
  Widget build(BuildContext context) => TextWidget(
    value: data['value'] as String,
    style: data['style'] != null
        ? data['style'] as Map<String, dynamic>?
        : null,
  );

  @override
  String get component => 'text';
}

void setup() {
  Components.register('clickable', _$ClickableWidgetComponent.new);
  Components.register('multi', _$MultiWidgetComponent.new);
  Components.register('text', _$TextWidgetComponent.new);
}
