import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:be_for_real/tabs/friendTab/comments.dart';

DateTime now = DateTime.now();
String formattedDate = DateFormat('yyyy/MM/dd - kk.mm').format(now);
String placeholderImageLink =
    'https://media.discordapp.net/attachments/526767373449953285/1101056394544807976/image.png?width=764&height=760';
String friendPicProfilePic = placeholderImageLink;
String friendPicFront = placeholderImageLink;
String friendPicBack = placeholderImageLink;

String friendUsername = 'username';
String friendPicDateTime = 'time';
String friendPicLocation = 'location';

class FriendPicture extends StatefulWidget {
  const FriendPicture({Key? key}) : super(key: key);

  @override
  _FriendPictureState createState() => _FriendPictureState();
}

class _FriendPictureState extends State<FriendPicture> {
  double _xOffset = 5;
  double _yOffset = 5;

  Route _createRouteComments() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Comments(),
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 663,
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
                          Text(friendUsername),
                          Text(
                            '$friendPicLocation • $friendPicDateTime',
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
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          child: FadeInImage(
                            image: NetworkImage(friendPicBack),
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
                                  image: NetworkImage(friendPicFront),
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
                  padding: const EdgeInsets.only(
                      left: 10, right: 2, top: 6, bottom: 36),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(_createRouteComments());
                    },
                    child: Text(
                      'add a comment...',
                      style: TextStyle(
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
