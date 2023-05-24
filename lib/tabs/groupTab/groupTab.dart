import 'package:flutter/material.dart';
import '../friendTab/friendPicture.dart';
import 'groupSelect.dart';
import '../friendTab/ownPicture.dart';

class GroupTab extends StatelessWidget {
  GroupTab({Key? key}) : super(key: key);

  final ownPicture = const OwnPicture();
  final friendPicture = const FriendPicture();
  final groupSelect = const GroupSelect();

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
              return groupSelect;
            }
            if (index == 2) {
              return friendPicture;
            }
          }),
    );
  }
}
