import 'package:flutter/widgets.dart';
import 'package:flutter_ludyx/src/common/extensions/lua_extension.dart';
import 'package:flutter_ludyx/src/helper/base_ludyx_helper.dart';
import 'package:lua_dardo_plus/lua.dart';

class LudyxNavigatorHelper(
  super.ludyx, {
  required final GlobalKey<NavigatorState> navigatorKey,
}) extends BaseLudyxHelper {
  @override
  void setup() {
    ludyx.state
      ..createTable(0, 2)
      ..pushString('pushNamed')
      ..pushDartFunction((LuaState state) {
        final String routeName = state.toStr(1)!;
        dynamic args;
        if (state.getTop() >= 2) {
          args = state.toDart(2);
        }

        navigatorKey.currentState?.pushNamed(routeName, arguments: args);
        return 0;
      });
    ludyx.state.setTable(-3);

    ludyx.state
      ..pushString('pop')
      ..pushDartFunction((LuaState state) {
        dynamic result;
        if (state.getTop() >= 1) {
          result = state.toDart(1);
        }

        navigatorKey.currentState?.pop(result);
        return 0;
      });
    ludyx.state.setTable(-3);

    ludyx.state.setGlobal('Navigator');
  }
}
