import 'package:flutter/material.dart';

import '../../chat/models/groups.dart';
import '../../firebase.dart';

String placeholderImageLink =
    'https://media.discordapp.net/attachments/526767373449953285/1101056394544807976/image.png?width=764&height=760';

class GroupSelect extends StatelessWidget {
  final Groups? groups; // Make groups nullable
  final Firebase? firebase;
  const GroupSelect({Key? key, this.groups, this.firebase}) : super(key: key);

  int length() {
    return (firebase?.getGroupNamesLength() ?? 0) as int; // Cast to int
  }

  Widget buildCardGroupPic(BuildContext context, int index) => GestureDetector(
    onTap: () {
      //TODO Change content to be group only content
    },
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
            image: NetworkImage(placeholderImageLink),
            fit: BoxFit.cover,
            placeholder: const AssetImage("assets/Placeholder.png"),
          ),
        ),
      ),
    ),
  );

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
            final pad = (constraints.maxWidth - 80) / 2;
            return ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: pad, top: 6, bottom: 12),
              itemCount: length(),
              separatorBuilder: (context, index) {
                return const SizedBox(width: 12);
              },
              itemBuilder: (context, index) {
                return buildCardGroupPic(context, index);
              },
            );
          }),
        ),
      ],
    );
  }
}
