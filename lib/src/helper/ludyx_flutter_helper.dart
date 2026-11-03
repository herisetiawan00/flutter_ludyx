// ignore_for_file: public_member_api_docs

import 'package:flutter/widgets.dart';
import 'package:flutter_ludyx/src/helper/base_ludyx_helper.dart';
import 'package:lua_dardo_plus/lua.dart';

/// Help to handle flutter helper inside the script
class LudyxFlutterHelper(
  super.ludyx, {
  required final VoidCallback onRebuild,
}) extends BaseLudyxHelper {
  @override
  void setup() {
    ludyx.state
      ..createTable(0, 1)
      ..pushString('rebuild')
      ..pushDartFunction((LuaState state) {
        onRebuild.call();
        return 0;
      });
    ludyx.state.setTable(-3);

    ludyx.state.setGlobal('Flutter');
  }
}
