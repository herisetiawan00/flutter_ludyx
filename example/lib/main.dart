import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ludyx/flutter_ludyx.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
  late final ValueNotifier<num> number;

  late final TextEditingController aController, bController;

  @override
  void initState() {
    super.initState();
    number = .new(0);
    ludyx = .new();

    LudyxHelper(ludyx).withModuleSearcher().withLogger().setup();
    ludyx.loadMain();

    aController = .new(text: '0');
    bController = .new(text: '0');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ValueListenableBuilder<num>(
          valueListenable: number,
          builder: (context, value, child) {
            return Padding(
              padding: const .all(32),
              child: Column(
                mainAxisSize: .min,
                spacing: 16,
                children: [
                  Row(
                    spacing: 16,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: aController,
                          keyboardType: .number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          textAlign: .center,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: bController,
                          keyboardType: .number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          textAlign: .center,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 16,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            number.value = ludyx.callFn('Plus', <double>[
                              .parse(aController.text),
                              .parse(bController.text),
                            ]);
                          },
                          child: Text('+'),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            number.value = ludyx.callFn('Minus', <double>[
                              .parse(aController.text),
                              .parse(bController.text),
                            ]);
                          },
                          child: Text('-'),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            number.value = ludyx.callFn('Multiply', <double>[
                              .parse(aController.text),
                              .parse(bController.text),
                            ]);
                          },
                          child: Text('*'),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            number.value = ludyx.callFn('Divide', <double>[
                              .parse(aController.text),
                              .parse(bController.text),
                            ]);
                          },
                          child: Text('/'),
                        ),
                      ),
                    ],
                  ),
                  ?child,
                  Text(
                    value.toStringAsFixed(2),
                    style: .new(fontSize: 24, fontWeight: .w600),
                  ),
                ],
              ),
            );
          },
          child: Text('here is the result:'),
        ),
      ),
    );
  }
}
