import 'package:flutter/material.dart';
import 'package:be_for_real/tabs/friendTab/friendPicture.dart';
import 'package:be_for_real/tabs/friendTab/ownPicture.dart';

class FriendTab extends StatelessWidget {
  FriendTab({Key? key}) : super(key: key);

  final ownPicture = const OwnPicture();
  final friendPicture = const FriendPicture();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            if (index == 0) {
              return ownPicture;
            }
            if (index == 1) {
              return friendPicture;
            }
          }),
    );
  }
}
