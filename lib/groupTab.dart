import 'package:flutter/material.dart';
import 'tabs/friendTab/friendPicture.dart';
import 'tabs/groupTab/groupSelect.dart';
import 'tabs/friendTab/ownPicture.dart';

class GroupTab extends StatelessWidget {
  GroupTab({Key? key}) : super(key: key);

  final ownPicture = OwnPicture();
  final friendPicture = FriendPicture();
  final groupSelect = GroupSelect();

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
