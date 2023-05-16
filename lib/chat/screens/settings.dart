import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'loginReg/pages/login_page.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    if (user == null) return Container();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Center(
          child: Padding(
            padding: EdgeInsets.only(right: 50.0),
            // Adjust the padding value as needed
            child: Text(
              "Settings",
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        // Align the button in the center horizontally
        children: [
          const Text(
            'Feature',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            // Add spacing between the title and the first row
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 100,
                    color: Colors.grey[900],
                    // Content for the first section
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            // Add spacing between the first and second rows
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 100,
                    color: Colors.grey[900],
                    // Content for the second section
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // Align the button in the center horizontally
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  // Add spacing between the second and third rows
                  width: 350,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.logout, color: Colors.red, size: 30),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
