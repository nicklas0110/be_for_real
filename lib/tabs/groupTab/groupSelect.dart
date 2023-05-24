import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Alexs_Firebase_mappe/firebase_chat_service.dart';
import '../../chat/models/groups.dart';
import '../../chat/models/user.dart';
import '../../Alexs_Firebase_mappe/firebase.dart';

String placeholderImageLink =
    'https://media.discordapp.net/attachments/526767373449953285/1101056394544807976/image.png?width=764&height=760';

class GroupSelect extends StatelessWidget {
  final Groups? groups; // Make groups nullable
  final Firebase? firebase;

  const GroupSelect({Key? key, this.groups, this.firebase}) : super(key: key);

  Widget buildCardGroupPic(Groups groups) {
    final ImageProvider imageProvider = groups.imageUrl != null
        ? NetworkImage(groups.imageUrl!)
        : const AssetImage("assets/Grey.png") as ImageProvider;
    return GestureDetector(
      onTap: () {
        //TODO Change content to be group only content
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 6),
        child: Container(
          width: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.blueGrey,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: SizedBox(
              child: FadeInImage(
                image: imageProvider,
                fit: BoxFit.cover,
                placeholder: const AssetImage("assets/Placeholder.png"),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Align(
          alignment: Alignment.center,
          child: Text(
            'Groups',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 100,
          child: LayoutBuilder(builder: (context, constraints) {
            final user = Provider.of<User>(context);
            final chat = Provider.of<ChatService>(context);
            final pad = (constraints.maxWidth - 80) / 2;
            return StreamBuilder(
              stream: chat.groups(user),
              builder: (context, snapshot) => ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(left: pad, top: 6, bottom: 12),
                children: [
                  if (snapshot.hasData)
                    ...snapshot.data!.map((e) => buildCardGroupPic(e))
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}
