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

  const GroupTile(this.group, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.blueGrey, // Set the border color
            width: 1.0, // Set the border width
          ),
        ),
        child: ClipOval(
          child: Image.network(
            group.imageUrl ?? '', // Use the imageUrl property
            width: 50,
            height: 50,
          ),
        ),
      ),
      title: Text(group.name),
      trailing: Text('Members: ${group.members.length}'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MessagesScreen(group: group, groups: group),
          ),
        );
      },
    );
  }
}
