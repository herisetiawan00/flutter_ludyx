import 'package:flutter_ludyx/src/common/types/lua_fn.dart';
import 'package:lua_dardo_plus/lua.dart';

extension LuaStateExtension on LuaState {
  T nestedFields<T>(String path, T Function(LuaState ls) action) {
    final chunks = path.split('.');
    for (final chunk in chunks) {
      getField(-1, chunk);
    }
    final result = action(this);
    pop(chunks.length);
    return result;
  }

  int toAbsIndex(int idx) {
    if (idx > 0) return idx;
    return getTop() + idx + 1;
  }

  dynamic toDart([int stackIndex = -1]) {
    final int absIndex = toAbsIndex(stackIndex);

    final LuaType type = this.type(absIndex);
    return switch (type) {
      .luaNil || .luaNone => null,
      .luaBoolean => toBoolean(absIndex),
      .luaNumber =>
        isInteger(absIndex) ? toInteger(absIndex) : toNumber(absIndex),
      .luaString => toStr(absIndex),
      .luaTable => _tableToDart(absIndex),
      .luaFunction => LudyxFn.fromState(this, absIndex),
      _ => null,
    };
  }

  dynamic _tableToDart(int absTableIndex) {
    final int arrayLen = rawLen(absTableIndex);
    final bool isList = _isSequence(absTableIndex, arrayLen);

    if (isList) {
      final List<dynamic> list = [];
      for (int i = 1; i <= arrayLen; i++) {
        pushInteger(i);
        getTable(absTableIndex);

        list.add(toDart(-1));
        pop(1);
      }
      return list;
    }

    final Map<String, dynamic> map = {};

    pushNil();

    while (next(absTableIndex)) {
      final String? key = toStr(-2);

      if (key == null) {
        pop(1);
        continue;
      }

      final dynamic value = toDart(-1);

      map[key] = value;

      pop(1);
    }

    return map;
  }

  bool _isSequence(int absTableIndex, int arrayLen) {
    if (arrayLen == 0) {
      pushNil();
      if (!next(absTableIndex)) {
        return true;
      }
      pop(2);
      return false;
    }

    int keyCount = 0;
    pushNil();
    while (next(absTableIndex)) {
      keyCount++;
      pop(1);
    }

    return keyCount == arrayLen;
  }
}
