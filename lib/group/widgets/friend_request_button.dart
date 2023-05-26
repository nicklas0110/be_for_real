
import 'package:flutter/material.dart';
import 'package:be_for_real/Alexs_Firebase_mappe/firebase_friends.dart';
import '../add_friend_screen.dart';

//This class is used for the button that sends a friendrequest
class FriendRequestButton extends StatelessWidget {
  final firebase = Firebase();

  FriendRequestButton({super.key});

  Route _createRouteAddFriend() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>  const AddFriendScreen(),

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
    return IconButton(
      onPressed: () {
        Navigator.of(context).push(_createRouteAddFriend());
      },
      icon: const Icon(Icons.person_add),
    );
  }

}
