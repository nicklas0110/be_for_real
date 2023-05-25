import 'dart:typed_data';

import 'package:be_for_real/chat/models/user.dart';
import 'package:be_for_real/chat/screens/profile_screen.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geocoding/geocoding.dart';

import '../../../Alexs_Firebase_mappe/firebase.dart';
import '../../../locationUtil.dart';
import '../../../tabs/friendTab/friendPicture.dart';

class CameraService {
  Future<String> getCurrentPlaceName() async {
    final position = await determinePosition();
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    final place = placemarks.first;
    return "${place.locality}, ${place.country}";
  }

  Future<void> uploadPhotos(
      {required String uid,
      required Uint8List backBytes,
      required Uint8List frontBytes,
      required String email}) async {
    String location = await getCurrentPlaceName();
    final templateUpload =
        FirebaseStorage.instance.ref('/Images').child(uid).child(formattedDate);

    final back = await templateUpload.child('back').putData(backBytes);

    final front = await templateUpload.child('front').putData(frontBytes);

   final dailyImage = {
      "front": await front.ref.getDownloadURL(),
    "timestamp": formattedDate,
    "location": location,
    "back": await back.ref.getDownloadURL(),
    "uid": getUserEmail().toString(),
    };

    final userRef = await FirebaseFirestore.instance
        .collection("userImages").doc(email)
        .set({
      "dailyImages": FieldValue.arrayUnion([dailyImage])
    });


  }
}
