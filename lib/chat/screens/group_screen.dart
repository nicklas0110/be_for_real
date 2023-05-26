import 'package:be_for_real/chat/widgets/friend_request_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Alexs_Firebase_mappe/firebase_chat_service.dart';
import '../models/user.dart';
import '../widgets/create_channel_button.dart';
import '../models/groups.dart';
import '../widgets/friend_list_button.dart';
import 'messages_screen.dart';

class GroupScreen extends StatelessWidget {
   GroupScreen({super.key});

   //This is where the groupScreen is built
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
          FriendListButton(userId: '',),
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

/*This class is for setting up each individual group in a tile, and these tile are listed on the screen -
with a profile-picture, the amount of members in the group and the name of the group
*/

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
            group.imageUrl ??  '',
            width: 50,
            height: 50,
            fit: BoxFit.cover,
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
