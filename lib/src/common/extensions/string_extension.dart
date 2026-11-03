import 'package:flutter/widgets.dart';

extension StringExtension on String {
  Color toColor() {
    return Color(int.parse(replaceFirst('#', '0xFF')));
  }
}
