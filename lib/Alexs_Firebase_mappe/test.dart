import 'dart:io';

import 'package:be_for_real/chat/models/dailyPicture.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/tabs/friendTab/friendPicture.dart';
import '../chat/models/groups.dart';
import '../Alexs_Firebase_mappe/firebase_daily_picture.dart';

class FirebaseDailyPicture {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<DailyPicture>> getPicturesGroups(String email) async {
    final groups = (await _firestore
        .collection("groups")
        .where("members", arrayContains: email)
        .withConverter(fromFirestore: (snapshot, options) => Groups.fromMap(snapshot.id, snapshot.data()!) , toFirestore: (value, options) => value.toMap(),)
        .get());

    final emails = [];
    for (final group in groups.docs) {
      for(final email in group.data().members) {
        emails.add(email);
      }
    }
    final userImages = (await _firestore
        .collection("userImages")
        .where(FieldPath.documentId, whereIn: emails)
        .get()).docs;

    return[];
  }

/*getPicturesFriends(String uid) async {
    final users = await _firestore
        .collection("friendRegister")
        .doc(uid).get(friendlist);
    final userIds = users.docs.map((e) => e.id).toList();
    final userImages = _firestore
        .collection("userImages")
        .where(FieldPath.documentId, whereIn: userIds)
        .withConverter(
      fromFirestore: (snapshot, options) =>
          DailyPicture.fromMap(snapshot.id, snapshot.data()!),
      toFirestore: (value, options) => value.toMap(),
    )
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());
  }*/
}
