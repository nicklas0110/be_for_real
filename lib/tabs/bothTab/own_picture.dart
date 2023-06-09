import 'package:be_for_real/UtilityHelpers/location_util.dart';
import 'package:be_for_real/models/user.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:be_for_real/tabs/bothTab/camera_screen.dart';
import 'package:be_for_real/tabs/friendTab/friend_picture.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../Alexs_Firebase_mappe/firebase_daily_picture.dart';

String userPic = 'https://media.discordapp.net/attachments/526767373449953285/1101056394544807976/image.png?width=764&height=760';
String ownPicDateTime = 'time';
String ownPicLocation = 'location';
String addedCaption = 'added caption';
bool haveUploadedPicture = true;
bool haveUploadedCaption = false;

class OwnPicture extends StatelessWidget {
  const OwnPicture({super.key});

  alertPopUp(context) async {
    if (await Geolocator.isLocationServiceEnabled() == false) {
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Turn on Location',
                style: TextStyle(color: Colors.red)),
            content: const SingleChildScrollView(
              child: ListBody(
                children: [
                  Text('Please turn on your location',
                      style: TextStyle(color: Colors.white)),
                  Text(
                      'Press approve to this message when your location is on to continue',
                      style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Approve',
                    style: TextStyle(color: Colors.white)),
                onPressed: () async {
                  if (await Geolocator.isLocationServiceEnabled() != false) {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          );
        },
      );
    }
  }

  captionPopUp(context) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a caption to your picture',
              style: TextStyle(color: Colors.white)),
          content: const SingleChildScrollView(
            child: ListBody(
              children: [
                TextField(
                  maxLines: 4,
                  decoration: InputDecoration(
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                    border: OutlineInputBorder(),
                    hintText: 'Caption',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Send', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                if (await Geolocator.isLocationServiceEnabled() != false) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Route _createRouteCamera() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
      const CameraScreen(
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

  Future<List<String>?> imageUploaded(
      FirebaseDailyPicture firebaseDailyPicture) async {
    try {
      final userpic = (await firebaseDailyPicture.getPicturesOwn(
          FirebaseAuth.instance.currentUser!.email!)).first;
      return [userpic.imageUrlFront, userpic.imageUrlBack];
    } catch (error) {
      final placeholder = [
        '514623267995649/plus_sign_white.png?width=994&height=1192',
        'https://media.discordapp.net/attachments/526767373449953285/1110514623267995649/plus_sign_white.png?width=994&height=1192'
      ];
      return null;
    }
  }

  Future<List<String>?> imageUploadedData(
      FirebaseDailyPicture firebaseDailyPicture) async {
    try {
      final userpicData = (await firebaseDailyPicture.getPicturesOwn(
          FirebaseAuth.instance.currentUser!.email!)).first;
      return [userpicData.location, userpicData.timestamp];
    } catch (error) {
      return null;
    }
  }

  Widget buildCardOwnPic(BuildContext context, int index) {
    final dailyPicture = Provider.of<FirebaseDailyPicture>(context);

    return GestureDetector(
      onTap: () {
        alertPopUp(context);
        Navigator.of(context).push(_createRouteCamera());
      },
      child: Stack(
        children: [
          Container(
            width: 120,
            height: 6969,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black,
              border: Border.all(
                color: Colors.blueGrey,
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                child: FutureBuilder(
                  future: imageUploaded(dailyPicture),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Image.asset('assets/plus_sign_white.png');
                    return Image.network(
                      snapshot.data!.last,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(4, 4, 0, 0), // Adjust the values as needed
            child: Container(
              width: 41, // Adjust the width as needed
              height: 56, // Adjust the height as needed
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: FutureBuilder(
                  future: imageUploaded(dailyPicture),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Container();
                    return Image.network(
                      snapshot.data!.first,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
          ),


          Positioned(
            top: 4,
            right: 4,
            child: InkWell(
              onTap: () {
                // Perform delete operation here
              },
              child: Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }




  getCurrentPlaceName() async {
    final position = await determinePosition();
    List<Placemark> placemarks =
    await placemarkFromCoordinates(position.latitude, position.longitude);
    final place = placemarks.first;
    return "${place.locality}, ${place.country}";
  }

  @override
  Widget build(BuildContext context) {
    String caption = haveUploadedCaption ? addedCaption : 'Add a caption';
    final dailyPicture = Provider.of<FirebaseDailyPicture>(context);

    return Column(
      children: [
        SizedBox(
          height: 180,
          child: LayoutBuilder(builder: (context, constraints) {
            final pad = (constraints.maxWidth - 120) / 2;
            return ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: pad, top: 12, bottom: 12),
              itemCount: 1,
              separatorBuilder: (context, index) {
                return const SizedBox(width: 12);
              },
              itemBuilder: (context, index) {
                return buildCardOwnPic(context, index);
              },
            );
          }),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: SizedBox(
            child: SelectionArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      captionPopUp(context);
                    },
                    child: Text(
                      caption,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  FutureBuilder(
                    future: imageUploadedData(dailyPicture),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return Text("");
                      final friendTimestamp = DateFormat.yMd()
                          .add_Hm()
                          .format(DateTime.parse(snapshot.data!.last));
                      return Text(
                        '${snapshot.data!.first} • ${friendTimestamp}'
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
