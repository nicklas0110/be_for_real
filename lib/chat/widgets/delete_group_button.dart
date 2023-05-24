import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Alexs_Firebase_mappe/firebase_chat_service.dart';
import '../screens/group_screen.dart';

class DeleteGroupButton extends StatelessWidget {
  final String groupId;

  DeleteGroupButton({required this.groupId});

  void _onDeleteGroupPressed(BuildContext context) {
    ChatService().deleteGroup(groupId);
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Delete Group'),
              content: Text('Are you sure you want to delete this group?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => _onDeleteGroupPressed(context),
                  child: Text('Delete'),
                ),
              ],
            );
          },
        );
      },
      icon: const Icon(Icons.delete),
    );
  }
}
