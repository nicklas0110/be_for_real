import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

DateTime now = DateTime.now();
String formattedDate = DateFormat('yyyy/MM/dd - kk.mm').format(now);
String friendPic =
    'https://media.discordapp.net/attachments/526767373449953285/1101056394544807976/image.png?width=764&height=760';
String friendUsername = 'username';
String friendPicDateTime = 'time';
String friendPicLocation = 'location';

class FriendPicture extends StatefulWidget {
  @override
  _FriendPictureState createState() => _FriendPictureState();
}

class _FriendPictureState extends State<FriendPicture> {
  double _xOffset = 5;
  double _yOffset = 5;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 661,
          child: Column(
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: SizedBox(
                  height: 40,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10, left: 10),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              friendPic,
                              fit: BoxFit.cover,
                            )),
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
                          height: 100,
                          width: 500,
                          child: FadeInImage(
                            image: NetworkImage(friendPic),
                            fit: BoxFit.cover,
                            placeholder: AssetImage("assets/Placeholder.png"),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: _yOffset,
                      left: _xOffset,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          setState(() {
                            _xOffset += details.delta.dx;
                            _yOffset += details.delta.dy;
                          });
                        },
                        child: Container(
                          height: 160,
                          width: 120,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.network(
                              friendPic,
                              fit: BoxFit.cover,
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
                  child: Text(
                    'add a comment...',
                    style: TextStyle(
                      color: Colors.grey[400],
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
