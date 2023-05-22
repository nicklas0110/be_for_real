
import 'package:flutter/material.dart';
import 'package:be_for_real/firebase.dart';
import '../screens/add_friend_screen.dart';
import '../screens/group_screen.dart';

class FriendRequestButton extends StatelessWidget {
  final firebase = Firebase();

  Route _createRouteAddFriend() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const addFriendScreen(),

      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        const begin = Offset(-1.0, 0.0);

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


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(_createRouteAddFriend());
      },
      child: Text('Add Friend'),
    );
  }



}
