import 'package:be_for_real/models/user_picture.dart';
import 'package:be_for_real/tabs/bothTab/own_picture.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'comments_screen.dart';

DateTime now = DateTime.now();
String formattedDate = now.toIso8601String();
String placeholderImageLink =
    'https://media.discordapp.net/attachments/526767373449953285/1111590482569597019/ProfilePic.png?width=1024&height=1024';
String friendPicProfilePic = placeholderImageLink;

bool haveUploadedCaption = false;
String addedCaption = 'added caption';

class UserCard extends StatefulWidget {
  const UserCard(this.dailyPicture, {Key? key})
      : super(key: key);
  final UserPicture dailyPicture;

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {

  Route _createRouteComments() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => CommentsScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  String captionUploaded() {
    if (haveUploadedCaption) {
      return addedCaption;
    } else {
      return 'Add a caption';
    }
  }

  double _xOffset = 5;
  double _yOffset = 5;

  @override
  Widget build(BuildContext context) {
    final friendTimestamp = DateFormat.yMd()
        .add_Hm()
        .format(DateTime.parse(widget.dailyPicture.timestamp));

    return SizedBox(
      height: 675,
      child: Column(
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: SizedBox(
              height: 35,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10, left: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: SizedBox(
                        child: FadeInImage(
                          image: NetworkImage(friendPicProfilePic),
                          fit: BoxFit.cover,
                          placeholder: const AssetImage("assets/Grey.png"),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.dailyPicture.email),
                      Text(
                        '${widget.dailyPicture.location} • $friendTimestamp',
                        style: TextStyle(
                          color: Colors.grey[400],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 0, right: 0, top: 12),
            child: Stack(
              children: [
                Container(
                  height: 550,
                  width: 450,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      child: FadeInImage(
                        image: NetworkImage(
                            widget.dailyPicture.getImageUrl(false)),
                        fit: BoxFit.cover,
                        placeholder: const AssetImage("assets/Grey.png"),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: _yOffset,
                  left: _xOffset,
                  child: Listener(
                    onPointerMove: (details) {
                      setState(() {
                        _xOffset += details.delta.dx;
                        _yOffset += details.delta.dy;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      child: SizedBox(
                        height: 160,
                        width: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                            child: FadeInImage(
                              image: NetworkImage(
                                  widget.dailyPicture.getImageUrl(true)),
                              fit: BoxFit.cover,
                              placeholder: const AssetImage("assets/Grey.png"),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 2, top: 6, bottom: 36),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(_createRouteComments());
                },
                child: Align(
                  alignment: Alignment.centerLeft, // Align text to the left
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start (left)
                    children: [
                      Visibility(
                        visible: haveUploadedCaption,
                        child: Text(
                          captionUploaded(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        'add a comment...',
                        style: TextStyle(
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
