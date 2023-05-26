import 'package:flutter/material.dart';
import 'group_picture.dart';
import 'group_select.dart';
import '../bothTab/own_picture.dart';

class GroupTab extends StatelessWidget {
  const GroupTab({Key? key}) : super(key: key);

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
              return const GroupSelect();
            }
            if (index == 2) {
              return const GroupPicture();
            }
            return null;
          }),
    );
  }
}
