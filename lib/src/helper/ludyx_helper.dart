// ignore_for_file: public_member_api_docs

import 'package:flutter/widgets.dart';
import 'package:flutter_ludyx/flutter_ludyx.dart';
import 'package:flutter_ludyx/src/helper/ludyx_flutter_helper.dart';
import 'package:flutter_ludyx/src/helper/ludyx_logger_helper.dart';
import 'package:flutter_ludyx/src/helper/ludyx_module_searcher_helper.dart';
import 'package:flutter_ludyx/src/helper/ludyx_navigator_helper.dart';

/// `LudyxHelper` help to handle specific action in communication between script and flutter
class LudyxHelper(final FlutterLudyx ludyx) {
  final Set<BaseLudyxHelper> _helpers = {};

  /// Include logger helper on this run
  LudyxHelper withLogger([LoggerCallback? onLog]) =>
      apply(() => _helpers.add(LudyxLoggerHelper(ludyx, onLog)));

  /// Include module searcher helper on this run
  LudyxHelper withModuleSearcher() =>
      apply(() => _helpers.add(LudyxModuleSearcherHelper(ludyx)));

  /// Include navigator helper on this run
  LudyxHelper withNavigatorHelper(GlobalKey<NavigatorState> navigatorKey) =>
      apply(
        () => _helpers.add(
          LudyxNavigatorHelper(ludyx, navigatorKey: navigatorKey),
        ),
      );

  /// Include flutter helper on this run
  LudyxHelper withFlutterHelper(VoidCallback onRebuild) =>
      apply(() => _helpers.add(LudyxFlutterHelper(ludyx, onRebuild: onRebuild)));

  /// Include custom ludyx helper on this run
  LudyxHelper withCustomHelper(BaseLudyxHelper helper) =>
      apply(() => _helpers.add(helper));

  /// Set-up and enable given ludyx helpers
  void setup([Set<String> allowedDangerousLibrary = const {}]) {
    _openLibs(allowedDangerousLibrary);
    for (final helper in _helpers) {
      helper.setup();
    }
  }

  void _openLibs([Set<String> allowedDangerousLibrary = const {}]) {
    ludyx.state.openLibs();
    final dangerousLibraries = {
      'io',
      'os',
      'debug',
      'dofile',
      'loadfile',
      'load',
      'loadstring',
    }..removeWhere(allowedDangerousLibrary.contains);

    for (final lib in dangerousLibraries) {
      ludyx.state.pushNil();
      ludyx.state.setGlobal(lib);
    }
  }
}

extension on LudyxHelper {
  LudyxHelper apply(VoidCallback callback) {
    callback.call();
    return this;
  }
}
