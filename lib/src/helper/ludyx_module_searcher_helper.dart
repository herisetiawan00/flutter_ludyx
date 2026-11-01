import 'package:flutter_ludyx/src/helper/base_ludyx_helper.dart';
import 'package:flutter_ludyx/ludyx_bundle_manager.dart';
import 'package:lua_dardo_plus/lua.dart';

class LudyxModuleSearcherHelper(super.ludyx) extends BaseLudyxHelper {
  @override
  void setup() {
    ludyx.state
      ..getGlobal('package')
      ..getField(-1, 'searchers');

    final int searchersTableIndex = ludyx.state.getTop();

    ludyx.state.pushDartFunction((LuaState state) {
      final String moduleName = state.toStr(1)!;
      final memoryCode = LudyxBundleManager.load(moduleName);
      if (memoryCode != null) {
        state.loadString(memoryCode);
        return 1;
      }

      state.pushString("\n\tno dynamic bundle file '$moduleName'");
      return 1;
    });

    final int len = ludyx.state.rawLen(searchersTableIndex);
    for (int i = len; i >= 2; i--) {
      ludyx.state
        ..rawGetI(searchersTableIndex, i)
        ..rawSetI(searchersTableIndex, i + 1);
    }
    ludyx.state
      ..rawSetI(searchersTableIndex, 2)
      ..pop(2);
  }
}
