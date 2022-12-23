import 'dart:io';

import 'package:flutter/material.dart';
import 'package:libadwaita/libadwaita.dart';

import '../db/json_db.dart';
import '../widgets/AdwTextFieldCostum.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key, required this.title});

  final String title;

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  var _map = new Map();
  @override
  void initState() {
    _map = DB.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    final controllerName = TextEditingController();
    final controllerMinutes = TextEditingController();

    var locked = false;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                              Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: AdwButton(
                                    onPressed: (() => {
                                          if (!locked)
                                            {
                                              locked = true,
                                              Process.run(
                                                  "/opt/focus/bar/focus_app", [
                                                "${item.value}",
                                                "${item.key}"
                                              ]).then((result) {
                                                if (result.exitCode == 0) {
                                                  var doneElement;
                                                  for (var element
                                                      in _map.entries) {
                                                    if (element.key ==
                                                        item.key) {
                                                      doneElement = element;
                                                    }
                                                  }

                                                  DB.addDone(doneElement);

                                                  setState(() {
                                                    _map = DB.getTasks();
                                                  });
                                                }
                                                locked = false;
                                              })
                                            },
                                        }),
                                    child: const Text(
                                      "do",
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.white),
                                    ),
                                  )),
                            ],
                          )),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10),
                            child: const Text(
                              "Name:",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                            width: (MediaQuery.of(context).size.width - 903),
                            child: AdwTextFieldCostum(
                              initialValue: "",
                              controller: controllerName,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(10),
                            child: const Text(
                              "Minutes:",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                            width: 80,
                            child: AdwTextFieldCostum(
                              initialValue: "",
                              controller: controllerMinutes,
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(left: 20),
                              child: AdwButton(
                                onPressed: (() => {
                                      setState(() {
                                        _map[controllerName.text] =
                                            controllerMinutes.text;
                                        DB.addTask(_map);
                                      })
                                    }),
                                child: const Text(
                                  "add",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white),
                                ),
                              )),
                        ],
                      ),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
