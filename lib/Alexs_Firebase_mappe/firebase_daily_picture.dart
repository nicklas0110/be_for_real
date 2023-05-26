
import 'package:be_for_real/Alexs_Firebase_mappe/firebase_basic.dart';
import 'package:be_for_real/models/user_picture.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseDailyPicture {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser?.uid;

  Future<List<UserPicture>> getPicturesGroups(String email) async {
    final groups = await _firestore
        .collection("groups")
        .where("members", arrayContains: email)
        .get();

    final emails = groups.docs
        .expand((group) => group.data()['members'] as List<dynamic>)
        .toList();

    if (emails.isEmpty) return [];

    final userImages = await _firestore
        .collection("userImages")
        .where(FieldPath.documentId, whereIn: emails)
        .get();

    final pictures = userImages.docs.expand((doc) {
      final list = doc.data()['dailyImages'] as List<dynamic>;
      return list.map((e) => UserPicture.fromMap(doc.id, e));
    }).toList();

    return pictures;
  }

  Future<List<UserPicture>> getPicturesFriends(String email) async {
    final friends = await _firestore
        .collection("friendsRegister")
        .doc(uid)
        .collection('friends')
        .get();

    final emails = friends.docs
        .map((friend)
    {
      final data =friend.data();
      return data['email'] as String;
    })
        .toList();

    final userImages = await _firestore
        .collection("userImages")
        .where(FieldPath.documentId, whereIn: emails)
        .get();

    final pictures = userImages.docs.expand((doc) {
      final list = doc.data()['dailyImages'] as List<dynamic>;
      return list.map((e) => UserPicture.fromMap(doc.id, e));
    }).toList();

    return pictures;
  }

  Future<List<UserPicture>> getPicturesOwn(String email) async {
    final userImages = await _firestore
        .collection("userImages")
        .doc(email) // Use your own document ID instead of relying on currentUser?.uid
        .get();

    final userImagesData = userImages.data();
    if (userImagesData == null || !userImagesData.containsKey('dailyImages')) {
      return []; // Return an empty list if the document doesn't exist or doesn't contain 'dailyImages'
    }

    final dailyImages = userImagesData['dailyImages'] as List<dynamic>;
    final pictures = dailyImages.map((e) => UserPicture.fromMap(email, e)).toList();

    return pictures;
  }


  Future<List<String>> getProfilePictureURLs() async {
    final friends = await _firestore
        .collection("friendsRegister")
        .doc(uid)
        .collection('friends')
        .get();

    final photoUrls = friends.docs.map((friend) {
      final data = friend.data();
      return data['photoUrl'] as String;
    }).toList();

    return photoUrls;
  }

  Future<void> deleteDailyPics(String email) async {
      final batch = FirebaseFirestore.instance.batch();
      // Delete group document
      final imageDocRef = FirebaseFirestore.instance
          .collection('userImages')
          .doc(FirebaseBasic().getUserEmail() as String?);
      batch.delete(imageDocRef);

      // Delete subcollections
      final subcollections = ['back', 'front'];
      for (final subcollection in subcollections) {
        final subcollectionRef = FirebaseFirestore.instance
            .collection('userImages')
            .doc(FirebaseBasic().getUserEmail() as String?)
            .collection(subcollection);
        final docs = await subcollectionRef.get();
        for (final doc in docs.docs) {
          batch.delete(doc.reference);
        }
      }

      // Commit the batched writes
      await batch.commit();

  }
}
