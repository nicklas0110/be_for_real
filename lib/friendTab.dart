import 'package:be_for_real/locationUtil.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'chat/screens/cameraPage.dart';

DateTime now = DateTime.now();
String formattedDate = DateFormat('yyyy/MM/dd - kk.mm').format(now);
String userPic =
    'https://media.discordapp.net/attachments/526767373449953285/1101056394544807976/image.png?width=764&height=760';
String friendPic =
    'https://media.discordapp.net/attachments/526767373449953285/1101056394544807976/image.png?width=764&height=760';
String friendUsername = 'username';
String friendPicDateTime = 'time';
String friendPicLocation = 'location';
String ownPicDateTime = 'time';
String ownPicLocation = 'location';

class FriendTab extends StatelessWidget {
  const FriendTab({Key? key}) : super(key: key);

  Route _createRouteCamera() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const CameraPage(
        title: 'Camera',
      ),
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

  Widget buildCardOwnPic(BuildContext context, int index) => GestureDetector(
    onTap: () {
      Navigator.of(context).push(_createRouteCamera());
    },
    child: Container(
      width: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blueGrey,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          userPic,
          fit: BoxFit.cover,
        ),
      ),
    ),
  );

  getCurrentPlaceName() async {
    final position = await determinePosition();
    List<Placemark> placemarks =
    await placemarkFromCoordinates(position.latitude, position.longitude);
    final place = placemarks.first;
    return "${place.locality}, ${place.country}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            if (index == 0) {
              return SizedBox(
                height: 180,
                child: LayoutBuilder(builder: (context, constraints) {
                  final pad = (constraints.maxWidth - 120) / 2;
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.only(left: pad, top: 12, bottom: 12),
                    itemCount: 3,
                    separatorBuilder: (context, index) {
                      return const SizedBox(width: 12);
                    },
                    itemBuilder: (context, index) {
                      return buildCardOwnPic(context, index);
                    },
                  );
                }),
              );
            }
            if (index == 1) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SizedBox(
                  child: SelectionArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          'Add a caption',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        FutureBuilder(
                            future: getCurrentPlaceName(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData == false) {
                                return Text(
                                  'Getting location...',
                                  style: TextStyle(color: Colors.grey[400]),
                                );
                              }
                              return Text(
                                '${snapshot.data.toString()} • $formattedDate🕒',
                                style: TextStyle(color: Colors.grey[400]),
                              );
                            }),
                      ],
                    ),
                  ),
                ),
              );
            }

            return SizedBox(
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
                                style: TextStyle(color: Colors.grey[400],),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 0, right: 0, top: 12),
                    child: Container(
                      height: 550,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          friendPic,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 2, top: 6, bottom: 36),
                      child: Text(
                        'add a comment...',
                        style: TextStyle(color: Colors.grey[400],),
                      ),
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}