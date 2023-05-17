import 'package:be_for_real/locationUtil.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../chat/screens/cameraPage.dart';
import 'package:be_for_real/friendTab/friendPicture.dart';

String userPic =
    'https://media.discordapp.net/attachments/526767373449953285/1101056394544807976/image.png?width=764&height=760';
String friendPic =
    'https://media.discordapp.net/attachments/526767373449953285/1101056394544807976/image.png?width=764&height=760';
String ownPicDateTime = 'time';
String ownPicLocation = 'location';

class OwnPicture extends StatelessWidget {
  @override

  AlertPopUp(context) async{
    if (await Geolocator.isLocationServiceEnabled() == false) {
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Turn on Location'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const [
                  Text('Please turn on your location', style: TextStyle(color: Colors.red)),
                  Text('Press approve to this message when your location is on to continue', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Approve', style: TextStyle(color: Colors.black38) ),
                onPressed: () async {
                  if(await Geolocator.isLocationServiceEnabled() != false){
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
          AlertPopUp(context);
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

  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
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
        ),
        Padding(
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
                      if (snapshot.hasError) {
                        return Text("Please enable location service on your device", style: TextStyle(color: Colors.red));
                      }
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
