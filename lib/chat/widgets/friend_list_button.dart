import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/friend_list_screen.dart';

class FriendListButton extends StatelessWidget {
  final String userId;

  const FriendListButton({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FriendListScreen(userId: userId),
          ),
        );
      },
      icon: const Icon(Icons.group),
    );
  }
}