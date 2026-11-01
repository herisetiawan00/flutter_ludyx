import 'package:flutter_ludyx/src/common/extensions/lua_extension.dart';
import 'package:lua_dardo_plus/lua.dart';

class LuaFn(final LuaState state, final int refId) {
  factory LuaFn.fromState(LuaState state, int absIndex) {
    state.pushValue(absIndex);
    final int refId = state.ref(luaRegistryIndex);
    return LuaFn(state, refId);
  }

  bool _disposed = false;

  dynamic call([List<Object> args = const []]) {
    if (_disposed) {
      throw StateError('Cannot call a disposed LuaFunction');
    }

    state.rawGetI(luaRegistryIndex, refId);

    if (!state.isFunction(-1)) {
      state.pop(1);
      throw StateError('Registry reference $refId is not a function');
    }

    for (final arg in args) {
      arg.push(state);
    }

    state.call(args.length, 1);

    final result = state.toDart(-1);
    state.pop(1);

    return result;
  }

  void dispose() {
    if (!_disposed) {
      state.unRef(luaRegistryIndex, refId);
      _disposed = true;
    }
  }
}

extension LuaFnExtension on Object {
  void push(LuaState ls) => switch (this) {
    bool val => ls.pushBoolean(val),
    int val => ls.pushInteger(val),
    double val => ls.pushNumber(val),
    String val => ls.pushString(val),
    List val => val.asMap().push(ls),
    Map val => () {
      ls.createTable(0, val.length);
      val.forEach((key, value) {
        key.push(ls);
        value.push(ls);
        ls.setTable(-3);
      });
    }(),
    _ => ls.pushNil(),
  };
}
