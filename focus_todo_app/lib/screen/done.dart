import 'package:flutter/material.dart';
import 'package:libadwaita/libadwaita.dart';

import '../db/json_db.dart';

class DonePage extends StatefulWidget {
  const DonePage({super.key, required this.title});

  final String title;

  @override
  State<DonePage> createState() => _DonePageState();
}

class _DonePageState extends State<DonePage> {
  var _map = {};

  @override
  void initState() {
    _map = DB.getDone();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_map.isNotEmpty) ...[
              Container(
                  margin: const EdgeInsets.only(left: 150, right: 150, top: 50),
                  child: AdwPreferencesGroup(
                    title: "Tasks",
                    description: "all Tasks",
                    children: [
                      for (var item in _map.entries.toList())
                        Container(
                            margin: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  width:
                                      (MediaQuery.of(context).size.width - 840),
                                  child: Text(
                                    "Name:    ${item.key}",
                                    style: const TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  ),
                                ),
                                Container(
                                  width: 156,
                                  child: Text(
                                    "Minutes:    ${item.value}",
                                    style: const TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  ),
                                ),
                              ],
                            )),
                    ],
                  ))
            ]
          ],
        ),
      ),
    );
  }
}
