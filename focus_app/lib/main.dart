import 'dart:async';
import 'dart:io';

import 'package:adwaita/adwaita.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:libadwaita/libadwaita.dart';
import 'package:window_manager/window_manager.dart';

var minutes = 0;
var task = "";

void main(List<String> args) async {
  if (args.length < 2) {
    exit(1);
  }
  minutes = int.parse(args[0]) * 60;
  task = args[1];

  WidgetsFlutterBinding.ensureInitialized();
  // Must add this line.
  await windowManager.ensureInitialized();

  Process.run("/opt/focus/getMonitor.sh", []).then((result) {
    double positionX = 0;
    double positionY = 0;

    String xrandr = result.stdout as String;
    var xrandrOptions = xrandr.split("+");
    var res = xrandrOptions[0].split("x");

    positionX = (((int.parse(res[0])) / 2) + int.parse(xrandrOptions[1])) - 250;
    positionY =
        (int.parse(xrandrOptions[2])) + (int.parse(res[1]) - (150 + 50));

    windowManager.setAlwaysOnTop(true);
    windowManager.setOpacity(1);
    windowManager.setMinimumSize(const Size(500, 50));

    doWhenWindowReady(() {
      const initialSize = Size(500, 50);
      appWindow.size = initialSize;
      appWindow.minSize = initialSize;
      appWindow.maxSize = initialSize;
      appWindow.position = new Offset(positionX, positionY);
      appWindow.show();
    });

    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
          return MaterialApp(
              theme: AdwaitaThemeData.light(),
              darkTheme: AdwaitaThemeData.dark(),
              debugShowCheckedModeBanner: false,
              home: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: MyHomePage(
                  themeNotifier: themeNotifier,
                  title: '2',
                ),
              ),
              themeMode: ThemeMode.system);
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {super.key,
      required this.title,
      required ValueNotifier<ThemeMode> themeNotifier});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WindowListener {
  late Timer _timer;
  int _start = 0;

  @override
  void initState() {
    windowManager.addListener(this);
    _start = minutes;

    startTimer();
    super.initState();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            print("not_done");
            exit(1);
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  Future<void> dispose() async {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowMove() {
    /*windowManager.getPosition().then((value) => {
          if (value != new Offset(width, height))
            {windowManager.setPosition(Offset(width, height))}
        });*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 350,
            margin: const EdgeInsets.fromLTRB(75, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    margin: const EdgeInsets.only(right: 2),
                    child: Text(
                      task,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    )),
                Container(
                    margin: const EdgeInsets.only(left: 2),
                    child: Text(
                      "${(_start / 60).toInt()}:" +
                          "${_start % 60}".padLeft(2, "0"),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w300),
                    )),
              ],
            ),
          ),
          Container(
              margin: const EdgeInsets.all(10),
              child: AdwButton(
                  onPressed: (() => {print("done"), exit(0)}),
                  child: const Text(
                    "✓",
                    style: TextStyle(fontSize: 16),
                  ))),
        ],
      ),
    );
  }
}
