import 'package:flutter/material.dart';
import 'groupPicture.dart';
import 'groupSelect.dart';
import '../bothTab/ownPicture.dart';

class GroupTab extends StatelessWidget {
  GroupTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            if (index == 0) {
              return OwnPicture();
            }

            if (index == 1) {
              return GroupSelect();
            }
            if (index == 2) {
              return GroupPicture();
            }
          }),
    );
  }
}
