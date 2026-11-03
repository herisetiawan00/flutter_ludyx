import 'package:flutter/widgets.dart';
import 'package:flutter_ludyx/src/common/exceptions/ludyx_exception.dart';

abstract interface class ComponentWidget {
  String get component;
  Map<String, dynamic> get data;
}

abstract class StatefulComponentWidget extends StatefulWidget
    implements ComponentWidget {
  const StatefulComponentWidget({
    super.key,
    required this._data,
  });
  final Map<String, dynamic> _data;

  @override
  Map<String, dynamic> get data => _data;
}

abstract class StatelessComponentWidget extends StatelessWidget
    implements ComponentWidget {
  const StatelessComponentWidget({
    super.key,
    required this._data,
  });
  final Map<String, dynamic> _data;

  @override
  Map<String, dynamic> get data => _data;
}

typedef ComponentBuilder = Widget Function({
  Key? key,
  required Map<String, dynamic> data,
});

class Components {
  static final Map<String, ComponentBuilder> _registeredComponents = {};

  static void register(String name, ComponentBuilder builder) =>
      _registeredComponents[name] = builder;

  static Widget build(Map<String, dynamic> data) {
    final name = data['component'];

    if (name is! String) {
      throw LudyxComponentInvalidException();
    }

    final builder = _registeredComponents[name];

    if (builder == null) {
      throw LudyxComponentNotFoundException();
    }

    return builder(data: data);
  }
}
