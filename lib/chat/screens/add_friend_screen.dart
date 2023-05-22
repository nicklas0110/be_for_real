import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:be_for_real/firebase.dart';

class addFriendScreen extends StatelessWidget {
  const addFriendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Add Friends'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Enter Friend Email',
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                child: const Text('Add Friend'),
                onPressed: () {
                  // Add friend logic here
                  Firebase().sendFriendRequest();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
