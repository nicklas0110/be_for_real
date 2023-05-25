import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../friend_list_screen.dart';

//This class is for the button that shows all the users that you are friends with
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
            builder: (context) => FriendListScreen(),
          ),
        );
      },
      icon: const Icon(Icons.group),
    );
  }
}