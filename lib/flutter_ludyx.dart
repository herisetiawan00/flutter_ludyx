import 'package:flutter_ludyx/ludyx_bundle_manager.dart';
import 'package:flutter_ludyx/src/common/extensions/lua_extension.dart';
import 'package:flutter_ludyx/src/common/types/lua_fn.dart';
import 'package:lua_dardo_plus/lua.dart';

export 'package:flutter_ludyx/ludyx_bundle_manager.dart';
export 'package:flutter_ludyx/ludyx_bundle_config.dart';
export 'package:flutter_ludyx/src/helper/base_ludyx_helper.dart';
export 'package:flutter_ludyx/src/helper/ludyx_helper.dart';
export 'package:flutter_ludyx/src/common/types/lua_fn.dart';

export 'package:flutter_ludyx/src/components/components.dart';
export 'package:flutter_ludyx/src/components/basic_components.dart';

/// This is `FlutterLudyx` instance that maintaining current running script
class FlutterLudyx {
  final LuaState _state;

  /// Create new `FlutterLudyx` instance
  FlutterLudyx() : _state = LuaState.newState();

  /// current `state` to do manual action
  LuaState get state => _state;

  /// Loading main script to use, `path` by default routing to `main.lua`
  void loadMain([String path = 'main.lua']) {
    final code = LudyxBundleManager.loadMain(path);
    state.loadString(code);
    state.call(0, 0);
  }

  /// Call function inside the script with given [name] as function name inside the script and [args] as arguments needed
  ///
  /// on the script:
  /// ```lua
  /// function SomeFunc(a, b)
  ///   return a + b
  /// end
  /// ```
  ///
  /// on flutter side:
  /// ```dart
  /// final result = callFn('SomeFunc', [a, b]);
  /// ```
  T callFn<T>(String name, [List<Object> args = const []]) {
    state.getGlobal(name);

    for (final arg in args) {
      arg.push(state);
    }

    state.call(args.length, 1);

    return state.toDart();
  }
}
