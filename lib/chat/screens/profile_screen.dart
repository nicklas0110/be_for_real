import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    if (user == null) return Container();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          actions: const [
            Expanded(
              child: Center(
                child: Text(
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    "Profile"),
              ),
            ),
          ],
        ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Image.network(
          'https://media.discordapp.net/attachments/526767373449953285/1101056394544807976/image.png?width=764&height=760',
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}
