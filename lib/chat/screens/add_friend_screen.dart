
import 'package:flutter/material.dart';
import 'package:be_for_real/firebase.dart';

class AddFriendScreen extends StatelessWidget {
   AddFriendScreen({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();

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
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Enter Friend Email',
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                child: const Text('Add Friend'),
                onPressed: () {
                  // Add friend logic here
                  final friendEmail = _emailController.text;
                  Firebase().addFriendByEmail(friendEmail);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

