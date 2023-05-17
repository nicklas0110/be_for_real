import 'package:be_for_real/chat/models/groups.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'add_member_dialog.dart';

class AddMemberButton extends StatelessWidget {
  final Groups groups;
  const AddMemberButton({
    super.key,
    required this.groups,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AddMemberDialog(groups: groups);
          },
        );
      },
      icon: const Icon(Icons.person_add),
    );
  }
}
