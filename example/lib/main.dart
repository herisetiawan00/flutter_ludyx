import 'package:flutter/material.dart';
import 'package:flutter_ludyx/flutter_ludyx.dart';

final GlobalKey<NavigatorState> navigatorKey = .new();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  BasicComponents.register();
  final LudyxBundleAssetConfig ludyxConfig = .new(bundlePath: 'assets/lua');
  await LudyxBundleManager.syncAndLoad(config: ludyxConfig);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ludyx Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      navigatorKey: navigatorKey,
      routes: {
        '/home': (_) => BaseScreen(routeName: '/home'),
        '/detail': (_) => BaseScreen(routeName: '/detail'),
      },
      initialRoute: '/home',
    );
  }
}

class const BaseScreen({super.key, required final String routeName})
    extends StatefulWidget {
  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  late final FlutterLudyx ludyx;
  late final ValueNotifier<Map<String, dynamic>> component;

  @override
  void initState() {
    super.initState();
    component = .new({});
    ludyx = .new();

    _setupHelpers();
    ludyx.loadMain();
    _rebuild();
  }

  void _setupHelpers() {
    LudyxHelper(ludyx)
        .withModuleSearcher()
        .withLogger()
        .withNavigatorHelper(navigatorKey)
        .withFlutterHelper(_rebuild)
        .setup();
  }

  void _rebuild() {
    component.value = ludyx.callFn('GetView', [widget.routeName]) ?? {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<Map<String, dynamic>>(
        valueListenable: component,
        builder: (context, value, child) {
          if (value.isEmpty) {
            return SizedBox.shrink();
          }
          return SizedBox(width: .infinity, child: Components.build(value));
        },
      ),
    );
  }
}
