import 'package:flutter/material.dart';
import 'package:focus_todo_app/screen/done.dart';
import 'package:focus_todo_app/screen/tasks.dart';
import 'package:libadwaita/libadwaita.dart';
import 'package:libadwaita_bitsdojo/libadwaita_bitsdojo.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../db/json_db.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _currentIndex;

  @override
  void initState() {
    DB.readIn();
  }

  @override
  Widget build(BuildContext context) {
    return AdwScaffold(
      body: AdwViewStack(
        animationDuration: const Duration(milliseconds: 100),
        index: _currentIndex,
        children: const [TaskPage(title: "title"), DonePage(title: "title")],
      ),
      actions: AdwActions().bitsdojo,
      flap: (isDrawer) => AdwSidebar(
        currentIndex: _currentIndex,
        isDrawer: false,
        children: const [
          AdwSidebarItem(
            leading: Icon(LucideIcons.clipboardList),
            label: 'Tasks',
          ),
          AdwSidebarItem(
            leading: Icon(LucideIcons.clipboardCheck),
            label: 'Done',
          ),
        ],
        onSelected: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
