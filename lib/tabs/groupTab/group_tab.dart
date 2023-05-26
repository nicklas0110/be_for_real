import 'package:flutter/material.dart';
import 'group_picture.dart';
import 'group_select.dart';
import '../bothTab/own_picture.dart';

class GroupTab extends StatelessWidget {
  const GroupTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        OwnPicture(), GroupSelect(), GroupPicture()
      ],)
    );
  }
}
