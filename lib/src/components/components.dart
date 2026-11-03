import 'package:flutter/widgets.dart';
import 'package:flutter_ludyx/src/common/exceptions/ludyx_exception.dart';

/// `ComponentWidget` is abstraction to make sure component has identifier and data
abstract interface class ComponentWidget implements Widget {
  /// Component identifier [component]
  String get component;

  /// Data to be used in the component
  Map<String, dynamic> get data;
}

/// Customized `StatefulWidget` with `ComponentWidget` implementation
abstract class StatefulComponentWidget extends StatefulWidget
    implements ComponentWidget {
  /// main constructor for `StatefulComponentWidget`
  const new({super.key, required this._data});
  final Map<String, dynamic> _data;

  @override
  Map<String, dynamic> get data => _data;
}

/// Customized `StatelessWidget` with `ComponentWidget` implementation
abstract class StatelessComponentWidget extends StatelessWidget
    implements ComponentWidget {
  /// main constructor for `StatelessComponentWidget`
  const new({super.key, required this._data});
  final Map<String, dynamic> _data;

  @override
  Map<String, dynamic> get data => _data;
}

/// Type definition for widget function
typedef ComponentBuilder = ComponentWidget Function({
  Key? key,
  required Map<String, dynamic> data,
});

/// Singleton instance to manage components
class Components {
  static final Map<String, ComponentBuilder> _registeredComponents = {};

  /// Register component, existing component with same [name] will be replaced
  static void register(String name, ComponentBuilder builder) =>
      _registeredComponents[name] = builder;

  /// Component builder to be used on the widget tree
  static ComponentWidget build(Map<String, dynamic> data) {
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
