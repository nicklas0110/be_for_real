import 'package:be_for_real/chat/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'cameraPage.dart';
import '../../friendTab.dart';
import '../../groupTab.dart';
import 'channel_screen.dart';



class HomePageScreen extends StatelessWidget {
  const HomePageScreen({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BeForReal',
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.from(
          colorScheme: const ColorScheme.dark(background: Colors.black)),
      themeMode: ThemeMode.dark,
      home: const MyHomePage(
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
  const MyHomePage(
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

  Route _createRouteFriends() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const ChannelsScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Route _createRouteProfile() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const ProfileScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: const Icon(Icons.supervisor_account),
              iconSize: 30,
              color: Colors.white,
              tooltip: 'Friends',
              onPressed: () {
                Navigator.of(context).push(_createRouteFriends()
                );
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
                Navigator.of(context).push(_createRouteProfile());
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
        controller: _tabController,
        children: const [FriendTab(), GroupTab()],
      ),
    );
  }
}
