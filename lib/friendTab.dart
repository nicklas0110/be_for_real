import 'package:be_for_real/assets/locationUtil.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';

class FriendTab extends StatelessWidget {
  const FriendTab({Key? key}) : super(key: key);

  Widget buildCardOwnPic(int index) => Container(
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey,
        ),
        child: Center(child: Text('$index')),
      );

  Widget buildCardFriendPic(int index) => Container(
    width: 100, height: 600,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.grey,
    ),
    child: Center(child: Text('$index')),
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
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);

    return Scaffold(
        body: ListView   (
          children: [
            Column(children: [
      SizedBox(
              height: 160,
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final pad = (constraints.maxWidth - 100) / 2;
                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding:  EdgeInsets.only(left: pad, top: 12, bottom: 12),
                  itemCount: 3,
                  separatorBuilder: (context, index) {
                    return const SizedBox(width: 12);
                  },
                  itemBuilder: (context, index) {
                    return buildCardOwnPic(index);
                  },
                );
              })),
      Center(
            child: SelectionArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Add a caption'),
                  FutureBuilder(
                      future: getCurrentPlaceName(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData == false) {
                          return Text('Getting location...');
                        }
                        return Text(
                            '${snapshot.data.toString()} • ${formattedDate}🕒');
                      }),
                ],
              ),
            ),
      ),
              SizedBox(
                  height: 569,
                  child: LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        return ListView.separated(
                          scrollDirection: Axis.vertical,
                          padding:  EdgeInsets.only(left: 2, right: 5, top: 12, bottom: 12),
                          itemCount: 9,
                          separatorBuilder: (context, index) {
                            return const SizedBox(width: 12, height: 20,);
                          },
                          itemBuilder: (context, index) {
                            return buildCardFriendPic(index);
                          },
                        );
                      })),
    ]),
          ],
        ));
  }
}
