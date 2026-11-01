import 'package:flutter_ludyx/flutter_ludyx.dart';
import 'package:flutter_ludyx/src/helper/base_ludyx_helper.dart';
import 'package:flutter_ludyx/src/helper/ludyx_logger_helper.dart';
import 'package:flutter_ludyx/src/helper/ludyx_module_searcher_helper.dart';

class LudyxHelper(final FlutterLudyx ludyx) {
  final Set<BaseLudyxHelper> helpers = {};

  LudyxHelper withLogger([LoggerCallback? onLog]) {
    helpers.add(LudyxLoggerHelper(ludyx, onLog));
    return this;
  }

  LudyxHelper withModuleSearcher() {
    helpers.add(LudyxModuleSearcherHelper(ludyx));
    return this;
  }

  void setup() {
    ludyx.state.openLibs();
    for (final helper in helpers) {
      helper.setup();
    }
  }
}
