import 'package:be_for_real/chat/widgets/add_member_button.dart';
import 'package:be_for_real/chat/widgets/friend_request_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../chat_service.dart';
import '../models/user.dart';
import '../widgets/create_channel_button.dart';
import '../models/groups.dart';
import 'messages_screen.dart';

class GroupScreen extends StatelessWidget {

  const GroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final chat = Provider.of<ChatService>(context);
    if (user == null) return Container();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Groups'),
        actions: [
          CreateChannelButton(),
          FriendRequestButton(),
        ],
      ),
      body: StreamBuilder(
        stream: chat.groups(user),
        builder: (context, snapshot) => ListView(
          children: [
            if (snapshot.hasData) ...snapshot.data!.map((e) => GroupTile(e))
          ],
        ),
      ),
    );
  }
}

class GroupTile extends StatelessWidget {
  final Groups group;
  const GroupTile(this.group, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(group.name),
      trailing: Text('Members: ${group.members.length}'),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => MessagesScreen(channel: group),
      )),
    );
  }
}
