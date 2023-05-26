import 'package:be_for_real/models/user_picture.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:be_for_real/Alexs_Firebase_mappe/firebase_daily_picture.dart';
import 'package:provider/provider.dart';

import '../bothTab/user_card.dart';

DateTime now = DateTime.now();
String formattedDate = now.toIso8601String();
String placeholderImageLink =
    'https://media.discordapp.net/attachments/526767373449953285/1101056394544807976/image.png?width=764&height=760';
String friendPicProfilePic = placeholderImageLink;
String friendPicFront = placeholderImageLink;
String friendPicBack = placeholderImageLink;

String friendUsername = 'username';
String friendPicDateTime = 'time';
String friendPicLocation = 'location';

class GroupPicture extends StatelessWidget {
  const GroupPicture({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dailyPicture = Provider.of<FirebaseDailyPicture>(context);
    final user = FirebaseAuth.instance.currentUser;

    return FutureBuilder<List<UserPicture>>(
      future: dailyPicture.getPicturesGroups(user!.email!),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
            for (final picture in snapshot.data!) UserCard(picture)
          ],
        );
      },
    );
  }
}
