import 'package:adwaita/adwaita.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:focus_todo_app/screen/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Must add this line.

  runApp(MyApp());

  doWhenWindowReady(() {
    const initialSize = Size(1000, 500);
    appWindow.size = initialSize;
    appWindow.minSize = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.show();
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
              child: const MyHomePage(
                title: '2',
              )),
          themeMode: ThemeMode.system,
        );
      },
    );
  }
}
