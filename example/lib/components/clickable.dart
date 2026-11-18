import 'package:flutter_ludyx_annotations/flutter_ludyx_annotations.dart';
import 'package:material_ui/material_ui.dart';

@LudyxComponent('clickable')
class ClickableWidget extends StatelessWidget {
  final VoidCallback onClick;
  final Widget child;

  const new({super.key, required this.onClick, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onClick, child: child);
  }
}
