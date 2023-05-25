import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../Alexs_Firebase_mappe/firebase_chat_service.dart';

//This class is for the button of deleting a group
class DeleteGroupButton extends StatelessWidget {
  final String groupId;

  const DeleteGroupButton({super.key, required this.groupId});

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
              title: const Text('Delete Group'),
              content: const Text('Are you sure you want to delete this group?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => _onDeleteGroupPressed(context),
                  child: const Text('Delete'),
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
