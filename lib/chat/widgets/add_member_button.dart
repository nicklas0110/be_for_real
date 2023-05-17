import 'package:flutter/material.dart';

import '../models/groups.dart';
import 'add_member_dialog.dart';

class AddMemberButton extends StatelessWidget {
  final Groups channel;
  const AddMemberButton({
    super.key,
    required this.channel,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AddMemberDialog(channel: channel);
          },
        );
      },
      icon: const Icon(Icons.person_add),
    );
  }
}
