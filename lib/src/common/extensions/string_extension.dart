import 'package:flutter/widgets.dart';

/// Custom reusable extension on string
extension StringExtension on String {
  /// Convert hex string color to f`Color` class
  Color toColor() {
    return Color(int.parse(replaceFirst('#', '0xFF')));
  }
}
