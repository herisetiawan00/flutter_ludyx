// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:flutter_ludyx/src/common/extensions/lua_extension.dart';
import 'package:flutter_ludyx/src/helper/base_ludyx_helper.dart';
import 'package:lua_dardo_plus/lua.dart';

/// custom log handler if needed
typedef LoggerCallback = void Function(String message);

/// Help to handle print logging inside the script
class LudyxLoggerHelper(super.ludyx, [final LoggerCallback? onLog])
    extends BaseLudyxHelper {
  LoggerCallback get logger => onLog ?? debugPrint;

  @override
  void setup() {
    ludyx.state.pushDartFunction((LuaState state) {
      final int top = state.getTop();
      final List<String> outputs = [];

      for (int i = 1; i <= top; i++) {
        outputs.add(state.toDart(i).toString());
      }

      final message = outputs.join('\t');

      logger(message);
      return 0;
    });
    ludyx.state.setGlobal('print');
  }
}
