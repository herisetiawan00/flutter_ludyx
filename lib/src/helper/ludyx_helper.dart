import 'package:flutter/widgets.dart';
import 'package:flutter_ludyx/flutter_ludyx.dart';
import 'package:flutter_ludyx/src/helper/ludyx_flutter_helper.dart';
import 'package:flutter_ludyx/src/helper/ludyx_logger_helper.dart';
import 'package:flutter_ludyx/src/helper/ludyx_module_searcher_helper.dart';
import 'package:flutter_ludyx/src/helper/ludyx_navigator_helper.dart';

class LudyxHelper(final FlutterLudyx ludyx) {
  final Set<BaseLudyxHelper> helpers = {};

  LudyxHelper withLogger([LoggerCallback? onLog]) =>
      apply(() => helpers.add(LudyxLoggerHelper(ludyx, onLog)));

  LudyxHelper withModuleSearcher() =>
      apply(() => helpers.add(LudyxModuleSearcherHelper(ludyx)));

  LudyxHelper withNavigatorHelper(GlobalKey<NavigatorState> navigatorKey) =>
      apply(
        () => helpers.add(
          LudyxNavigatorHelper(ludyx, navigatorKey: navigatorKey),
        ),
      );

  LudyxHelper withFlutterHelper(VoidCallback onRebuild) =>
      apply(() => helpers.add(LudyxFlutterHelper(ludyx, onRebuild: onRebuild)));

  LudyxHelper withCustomHelper(BaseLudyxHelper helper) =>
      apply(() => helpers.add(helper));

  void setup() {
    ludyx.state.openLibs();
    for (final helper in helpers) {
      helper.setup();
    }
  }
}

extension on LudyxHelper {
  LudyxHelper apply(VoidCallback callback) {
    callback.call();
    return this;
  }
}
