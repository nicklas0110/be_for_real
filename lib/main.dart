import 'package:be_for_real/friendTab.dart';
import 'package:flutter/material.dart';

import 'groupTab.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BeForReal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: blackMaterialColor,
      ),
      home: MyHomePage(
        title: 'BeForReal',
        friendTab: 'Friends',
        groupTab: 'Groups',
      ),
    );
  }
}

MaterialColor blackMaterialColor = MaterialColor(0xFF000000, {
  50: Colors.black,
  for (int i = 100; i <= 900; i += 100) i: Colors.black,
});

class MyHomePage extends StatefulWidget {
  MyHomePage(
      {super.key,
      required this.title,
      required this.friendTab,
      required this.groupTab});

  final String title;
  final String friendTab;
  final String groupTab;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: const Icon(Icons.supervisor_account),
              iconSize: 30,
              color: Colors.white,
              tooltip: 'Friends',
              onPressed: () {
                // do something when the button is pressed
              },
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  widget.title),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: IconButton(
              icon: const Icon(Icons.account_circle),
              iconSize: 30,
              color: Colors.white,
              tooltip: 'Profile',
              onPressed: () {
                // do something when the button is pressed
              },
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(child: Text(widget.friendTab)),
            Tab(child: Text(widget.groupTab)),
          ],
        ),
      ),
      body: TabBarView(
        children: [FriendTab(), GroupTab()],
        controller: _tabController,
      ),
    );
  }
}
