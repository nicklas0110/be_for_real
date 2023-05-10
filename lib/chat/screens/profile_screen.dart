import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import 'login_screen.dart';
final Map<DateTime, List<dynamic>> _events = {
  DateTime(2022, 5, 10): ['Event 1', 'Event 2'],
  DateTime(2022, 5, 15): ['Event 3'],
  DateTime(2022, 5, 20): ['Event 4', 'Event 5', 'Event 6'],
};
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    if (user == null) return Container();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Center(
          child: const Text(
            'Profile',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),

      actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                child: Container(
                  width: 350, // Change this value to adjust the width
                  height: 55, // Change this value to adjust the height
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: IconButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                            (route) => false,
                      );
                    },
                    icon: const Icon(Icons.logout, color: Colors.red, size: 30),
                  ),
                ),
              ),
            ],
            onSelected: (value) {
              // TODO: Handle menu item selection
            },
          )
        ],
      ),
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

    );
  }
}
