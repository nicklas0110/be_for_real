import 'package:be_for_real/chat/models/groups.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../../Alexs_Firebase_mappe/firebase_chat_service.dart';

//This is the dialog class for adding a member to a group
class AddMemberDialog extends StatefulWidget {
  final Groups groups;
  const AddMemberDialog({super.key, required this.groups});

  @override
  State<AddMemberDialog> createState() => _AddMemberDialog();
}

class _AddMemberDialog extends State<AddMemberDialog> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final chat = Provider.of<ChatService>(context);
    return AlertDialog(
      title: const Text('Add member'),
      content: Form(
          key: _formKey,
          child: TextFormField(
            controller: _email,
            decoration: const InputDecoration(label: Text('Email')),
            validator: (value) => value!.isEmpty ? 'Name required' : null,
          )
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
            onPressed: (){
              Navigator.of(context).pop();
            }
        ),
        TextButton(
          child: const Text('Add'),
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;{
              chat.addMember(widget.groups, _email.value.text);
              Navigator.of(context).pop();
            };
          },
        ),
      ],
    );
  }
}
