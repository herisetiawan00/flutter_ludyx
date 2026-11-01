import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ludyx/flutter_ludyx.dart';
import 'package:flutter_ludyx_material_ui/flutter_ludyx_material_ui.dart';

Future<void> main() async {
  final LudyxBundleConfig ludyxConfig = .new(
    baseUrl: '',
    publicKey: '',
    aesKey: '',
  );
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
      home: const MyWidget(),
    );
  }
}

class MyWidget extends StatefulWidget {
  const new({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late final FlutterLudyx ludyx;
  late final ValueNotifier<Map<String, dynamic>> component;

  @override
  void initState() {
    super.initState();
    component = .new({});
    ludyx = .new();
    LudyxHelper(ludyx).withModuleSearcher().withLogger().setup();

    ludyx.loadMain();
    component.value = ludyx.callFn('GetView', ['home']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ValueListenableBuilder<Map<String, dynamic>>(
          valueListenable: component,
          builder: (context, json, child) {
            return Component.buildChild(json) ?? child!;
          },
          child: Text('Loading...'),
        ),
      ),
    );
  }
}
