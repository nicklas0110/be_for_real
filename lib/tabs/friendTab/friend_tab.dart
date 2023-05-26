import 'package:flutter/material.dart';
import 'package:be_for_real/tabs/friendTab/friend_picture.dart';
import 'package:be_for_real/tabs/bothTab/own_picture.dart';

class FriendTab extends StatelessWidget {

  const FriendTab( {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            if (index == 0) {
              return const OwnPicture();
            }
            if (index == 1) {
                return const FriendPicture();
            }
            return null;
          }),
    );
  }
}
