import 'package:flutter_ludyx/ludyx_bundle_manager.dart';
import 'package:flutter_ludyx/src/common/extensions/lua_extension.dart';
import 'package:flutter_ludyx/src/common/types/lua_fn.dart';
import 'package:lua_dardo_plus/lua.dart';

export 'package:flutter_ludyx/ludyx_bundle_manager.dart';
export 'package:flutter_ludyx/ludyx_bundle_config.dart';
export 'package:flutter_ludyx/src/helper/ludyx_helper.dart';


class FlutterLudyx {
  final LuaState _state;

  FlutterLudyx() : _state = LuaState.newState();

  LuaState get state => _state;

  void loadMain([String? path]) {
    final code = LudyxBundleManager.loadMain(path);
    state.loadString(code);
    state.call(0, 0);
  }

  T callFn<T>(String name, [List<Object> args = const []]) {
    state.getGlobal(name);

    for (final arg in args) {
      arg.push(state);
    }

    state.call(args.length, 1);

    return state.toDart();
  }
}
