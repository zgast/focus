import 'dart:async';
import 'dart:io';

import 'package:adwaita/adwaita.dart';
import 'package:flutter/material.dart';
import 'package:libadwaita/libadwaita.dart';
import 'package:window_manager/window_manager.dart';

var minutes = 0;
var task = "";

void main(List<String> args) async {
  minutes = int.parse(args[0]) * 60 + 10;
  task = args[1];

  WidgetsFlutterBinding.ensureInitialized();
  // Must add this line.
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = WindowOptions(
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );

  windowManager.setAlwaysOnTop(true);
  windowManager.setOpacity(1);
  windowManager.setMinimumSize(Size(500, 50));
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
          print(currentMode);
          return MaterialApp(
              theme: AdwaitaThemeData.dark(),
              darkTheme: AdwaitaThemeData.dark(),
              debugShowCheckedModeBanner: false,
              home: MyHomePage(
                themeNotifier: themeNotifier,
                title: '2',
              ),
              themeMode: currentMode);
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
  double width = 0;
  double height = 0;

  late Timer _timer;
  int _start = 10;

  @override
  void initState() {
    windowManager.addListener(this);
    Process.run("/home/markus/Documents/GitHub/focus_app/getMonitor.sh", [])
        .then((result) {
      String xrandr = result.stdout as String;
      var xrandrOptions = xrandr.split("+");
      var res = xrandrOptions[0].split("x");

      width = (((int.parse(res[0])) / 2) + int.parse(xrandrOptions[1])) -
          MediaQuery.of(context).size.width / 2;
      height = (int.parse(xrandrOptions[2]) +
          (int.parse(res[1]) - (120 + MediaQuery.of(context).size.height)));

      print("$width : $height");
      _start = minutes;
      startTimer();
      super.initState();
    });
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
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
    windowManager.getPosition().then((value) => {
          if (value != new Offset(width, height))
            {windowManager.setPosition(Offset(width, height))}
        });
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
            margin: EdgeInsets.fromLTRB(75, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.all(10),
                    child: Text(
                      task,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white),
                    )),
                Container(
                    margin: EdgeInsets.all(10),
                    child: Text(
                      "${(_start / 60).toInt()}:" +
                          "${_start % 60}".padLeft(2, "0"),
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                          color: Colors.white),
                    )),
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.all(10),
              child: AdwButton(
                  child: Text(
                    "✓",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  onPressed: (() => {exit(0)}))),
        ],
      ),
    );
    /*return AdwScaffold(
      body: Column(
        children: [Text("$width : $height")],
      ),
      actions: AdwActions().bitsdojo,
      flap: (isDrawer) => AdwSidebar(
        currentIndex: _currentIndex,
        isDrawer: isDrawer,
        children: const [
          AdwSidebarItem(
            label: 'Welcome',
          ),
          AdwSidebarItem(
            label: 'Counter',
          ),
          AdwSidebarItem(
            label: 'Lists',
          ),
          AdwSidebarItem(
            label: 'Avatar',
          ),
          AdwSidebarItem(
            label: 'Flap',
          ),
          AdwSidebarItem(
            label: 'View Switcher',
          ),
          AdwSidebarItem(
            label: 'Settings',
          ),
          AdwSidebarItem(
            label: 'Style Classes',
          )
        ],
        onSelected: (index) => setState(() => _currentIndex = index),
      ),
    );*/
  }
}
