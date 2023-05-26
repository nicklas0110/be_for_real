
import 'package:be_for_real/chat/models/dailyPicture.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseDailyPicture {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<DailyPicture>> getPicturesGroups(String email) async {
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
      return list.map((e) => DailyPicture.fromMap(doc.id, e));
    }).toList();

    return pictures;
  }

  Future<List<DailyPicture>> getPicturesFriends(String email) async {
    final friends = await _firestore
        .collection("friendsRegister").doc(FirebaseAuth.instance.currentUser?.uid).collection('friends')
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
      return list.map((e) => DailyPicture.fromMap(doc.id, e));
    }).toList();

    return pictures;
  }

}
