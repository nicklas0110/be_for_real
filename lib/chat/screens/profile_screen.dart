import 'package:be_for_real/chat/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'settings.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.from(
        colorScheme: const ColorScheme.dark(background: Colors.black),
      ),
      themeMode: ThemeMode.dark,
      home: const ProfilePage(
        title: 'Profile',
      ),
    );
  }
}


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key,required this.title,});
  final String title;
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: ClipOval(
              child: Image.network(
                'https://media.discordapp.net/attachments/526767373449953285/1101056394544807976/image.png?width=764&height=760',
                width: 150,
                height: 150,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Me',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'me@example.com',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 20),
        ],
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              iconSize: 30,
              color: Colors.white,
              onPressed: () {
                Navigator.of(context).push(_routeHomePageScreen());
              },
            ),
          ),

          Expanded(
            child: Center(
              child: Text(
                widget.title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: const Icon(Icons.more_horiz),
              iconSize: 30,
              color: Colors.white,
              onPressed: () {
                Navigator.of(context).push(_routeSettingsScreen());
              },
            ),
          ),
        ],
      ),

    );
  }

  Route _routeHomePageScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const HomePageScreen(),
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
  Route _routeSettingsScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const SettingsScreen(),
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
}
