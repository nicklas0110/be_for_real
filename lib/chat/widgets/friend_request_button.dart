import 'package:flutter/material.dart';
import 'package:be_for_real/firebase.dart';

class FriendRequestButton extends StatelessWidget {
  final firebase = Firebase();


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        firebase.sendFriendRequest();
      },
      child: Text('Add Friend'),
    );
  }



}
