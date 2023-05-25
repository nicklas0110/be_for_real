import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Alexs_Firebase_mappe/firebase_chat_service.dart';
import '../models/groups.dart';
import '../models/message.dart';
import '../utils.dart';
import '../widgets/add_member_button.dart';
import '../widgets/delete_group_button.dart';

class MessagesScreen extends StatefulWidget {
  final double padding = 8.0;
  final Groups groups;
  final TextEditingController textEditingController = TextEditingController();

  MessagesScreen({
    required this.groups,
    Key? key,
    required Groups group,
  }) : super(key: key);

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final ScrollController _scrollController = ScrollController();

  //This is where we set the controller for the scroll sequence of this screen
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    final chat =
        Provider.of<ChatService>(context); //The provider for the chatService
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.blueGrey, // Set the border color
                  width: 0.5, // Set the border width
                ),
              ),
              child: ClipOval(
                child: Image.network(
                  widget.groups.imageUrl ?? '',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(widget.groups.name),
          ],
        ),
        actions: [
          DeleteGroupButton(groupId: widget.groups.id), //Button to delete a group
          AddMemberButton(groups: widget.groups),       //Button for adding a member to the specific group
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FirestoreListView<Message>(    //This is where we have the stack of messages
              query: chat.messages(widget.groups),
              controller: _scrollController,
              reverse: false, // Display the messages in reverse order so the newest message allways is at the buttom
              itemBuilder: (context, doc) {
                final message = doc.data();
                return Column(
                  children: [
                    sender(message),
                    textBubble(message),
                    SizedBox(height: widget.padding * 2),
                  ],
                );
              },
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter, child: messageInput(context)),
        ],
      ),
    );
  }

  //This method is for the bubble that the message is shown in
  Widget textBubble(Message message) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(widget.padding),
          child: Text(message.content),
        ),
      ),
    );
  }

  //This is where we tell where the senders email should be according to the message
  Widget sender(Message message) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(senderName(message.from)),
          if (message.timestamp != null) Text(since(message.timestamp!)),
        ],
      ),
    );
  }

  //This is the messageInput field where you write your message in
  Widget messageInput(BuildContext context) {
    final user = Provider.of<User>(context);
    final chat = Provider.of<ChatService>(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: TextField(
        controller: widget.textEditingController,
        keyboardType: TextInputType.text,
        onSubmitted: (value) {
          if (value.isEmpty) return;
          chat.sendMessage(user, widget.groups, value);
          widget.textEditingController.clear();
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.send),
        ),
      ),
    );
  }
}
