import 'package:avatar_glow/avatar_glow.dart';
import 'package:be_for_real/chat/screens/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'home_page.dart';

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

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<String?> getUserEmail() async {
  final user = _auth.currentUser;
  if (user != null) {
    return user.email;
  }
  return null;
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.title});

  final String title;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  late String _photoUrl = '';
  late String _userName = 'Me';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('register')
          .doc(user.uid)
          .get();
      if (snapshot.exists) {
        setState(() {
          _photoUrl = snapshot.get('photoUrl');
          final userName = snapshot.get(
              'name');
          _userName = userName;
        });
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.transparent,
                    width: 0.5,
                  ),
                ),
                child: AvatarGlow(
                  glowColor: Colors.white,
                  showTwoGlows: true,
                  repeat: true,
                  endRadius: 80.0,
                  child: Material(
                    shape: const CircleBorder(),
                    elevation: 2.0,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.transparent,
                      backgroundImage:
                      _photoUrl.isNotEmpty ? NetworkImage(_photoUrl) : null,
                      child: _photoUrl.isEmpty
                          ? const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 70,
                      )
                          : null,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            _userName.isNotEmpty ? _userName : 'Me',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          FutureBuilder<String?>(
            future: getUserEmail(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasData && snapshot.data != null) {
                return Text(
                  snapshot.data!,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                );
              }
              return const Text(
                'No email found',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              );
            },
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
                style:
                const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
      pageBuilder: (context, animation, secondaryAnimation) =>
      const HomePageScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Route _routeSettingsScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
      const SettingsScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
