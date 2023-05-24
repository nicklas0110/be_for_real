
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Alexs_Firebase_mappe/firebase_chat_service.dart';
import '../models/user.dart';

class CreateChannelDialog extends StatefulWidget {
  const CreateChannelDialog({super.key});

  @override
  State<CreateChannelDialog> createState() => _CreateChannelDialogState();
}

class _CreateChannelDialogState extends State<CreateChannelDialog> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  String _imageUrl = ''; // Define imageUrl variable

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final chat = Provider.of<ChatService>(context);
    return AlertDialog(
      title: const Text('Add Channel'),
      content: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) => value!.isEmpty ? 'Name required' : null,
            ),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  _imageUrl = value; // Update imageUrl value
                });
              },
              decoration: const InputDecoration(labelText: 'Image URL'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Add'),
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            chat.createChannel(user, _name.value.text, imageUrl: _imageUrl); // Pass imageUrl to createChannel method
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}