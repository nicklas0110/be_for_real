import 'dart:typed_data';

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
      required String groupId}) async {
    String location = await getCurrentPlaceName();
    final templateUpload =
        FirebaseStorage.instance.ref('/Images').child(uid).child(formattedDate);

    final back = await templateUpload.child('back').putData(backBytes);

    final front = await templateUpload.child('front').putData(frontBytes);

    final ref = FirebaseFirestore.instance
        .collection("dailyPicture")
        .doc(groupId)
        .collection("dailyPicture")
        .doc(uid)
        .collection("dailyNotification")
        .doc(formattedDate);

        await ref.set({});

    ref.update({
      "images": FieldValue.arrayUnion([
        {
          "front": await front.ref.getDownloadURL(),
          "timestamp": formattedDate,
          "location": location,
          "back": await back.ref.getDownloadURL(),
          "uid": uid,
        }
      ])
    });
  }
}
