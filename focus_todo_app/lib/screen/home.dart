import 'package:flutter/material.dart';
import 'package:libadwaita/libadwaita.dart';
import 'package:libadwaita_bitsdojo/libadwaita_bitsdojo.dart';

import '../AdwTextFieldCostum.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _currentIndex;
  var _map = new Map();

  @override
  Widget build(BuildContext context) {
    final controllerName = TextEditingController();
    final controllerMinutes = TextEditingController();

    return AdwScaffold(
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Name:  ${item.key}",
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.white),
                              ),
                              Text(
                                "Minutes:  ${item.value}",
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.white),
                              ),
                              Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: AdwButton(
                                    onPressed: (() => {
                                          setState(() {
                                            _map[controllerName.text] =
                                                controllerMinutes.text;
                                          })
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
      actions: AdwActions().bitsdojo,
      flap: (isDrawer) => AdwSidebar(
        currentIndex: _currentIndex,
        isDrawer: false,
        children: const [
          AdwSidebarItem(
            label: 'Tasks',
          ),
          AdwSidebarItem(
            label: 'Done',
          ),
        ],
        onSelected: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
