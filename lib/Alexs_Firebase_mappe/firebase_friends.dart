import 'dart:io';

import 'package:be_for_real/Alexs_Firebase_mappe/firebase_basic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/tabs/friendTab/friendPicture.dart';
import '../models/groups.dart';

//This is a firebase class for firebase code
class Firebase {

  Future<void> addFriendByEmail(String currentUser, String friendEmail) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('register')
        .where('email', isEqualTo: friendEmail)
        .limit(1)
        .get();

    if (querySnapshot.size > 0) {
      final userDoc = querySnapshot.docs[0];
      final userData = userDoc.data();

      // Retrieve the friend's user ID
      final friendUserId = userDoc.id;

      // Check if a friend request has already been sent to the friend
      final friendRequestsSnapshot = await FirebaseFirestore.instance
          .collection('friendships')
          .doc(friendUserId)
          .collection('friends')
          .where('uid', isEqualTo: currentUser)
          .limit(1)
          .get();

      if (friendRequestsSnapshot.size > 0) {
        // A friend request has already been sent to the friend
        if (kDebugMode) {
          print('A friend request has already been sent to $friendEmail');
        }
        return;
      }

      // Retrieve the current user's name
      final currentUserDoc = await FirebaseFirestore.instance
          .collection('register')
          .doc(currentUser)
          .get();
      final currentUserName = currentUserDoc.get('name');

      // Add logic to send friend request and update the friendships collection
      await FirebaseFirestore.instance
          .collection('friendships')
          .doc(friendUserId)
          .collection('friends')
          .doc(currentUser)
          .set({
        'friendName': currentUserName, // Set the current user's name as the friend's name
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(), // Include the timestamp
        'uid': currentUser, // Include the UID of the current user
      });

      if (kDebugMode) {
        print('Friend request sent to $friendEmail');
      }
    } else {
      if (kDebugMode) {
        print('User with email $friendEmail not found');
      }
    }
  }

  void acceptFriendRequest(String friendUserId) async {
    final currentUser = FirebaseBasic().getCurrentUser();
    if (currentUser != null) {
      final userId = currentUser.uid;

      // Update the status of the friend request to 'accepted'
      final requestDoc = FirebaseFirestore.instance
          .collection('friendships')
          .doc(userId)
          .collection('friends')
          .doc(friendUserId);
      await requestDoc.update({'status': 'accepted'});

      // Store the friend in the user's 'friends' collection
      final currentUserFriendsCollection = FirebaseFirestore.instance
          .collection('friendsRegister')
          .doc(userId)
          .collection('friends');
      final friendDoc = await currentUserFriendsCollection.doc(friendUserId).get();
      if (!friendDoc.exists) {
        final friendData = await FirebaseFirestore.instance
            .collection('register')
            .doc(friendUserId)
            .get();

        final friendDataMap = friendData?.data() ?? {};

        final currentUserName = friendDataMap['name'];

        if (currentUserName != null) {
          friendDataMap['name'] = currentUserName;
        }

        currentUserFriendsCollection.doc(friendUserId).set(friendDataMap);
      }

      // Store the current user in the friend's 'friends' collection
      final friendFriendsCollection = FirebaseFirestore.instance
          .collection('friendsRegister')
          .doc(friendUserId)
          .collection('friends');
      final currentUserDoc = await friendFriendsCollection.doc(userId).get();
      if (!currentUserDoc.exists) {
        final currentUserData = await FirebaseFirestore.instance
            .collection('register')
            .doc(userId)
            .get();

        final currentUserDataMap = currentUserData?.data() ?? {}; // Provide an empty map if currentUserData is null

        friendFriendsCollection.doc(userId).set(currentUserDataMap);
      }

      if (kDebugMode) {
        print('Friend request accepted');
      }
    } else {
      // User is not authenticated, handle the case accordingly
      if (kDebugMode) {
        print('User is not logged in');
      }
      // You can show a dialog, navigate to a login screen, or take any other appropriate action
    }
  }

  // Function to decline a friend request
  void declineFriendRequest(String friendUserId) async {
    final currentUser = FirebaseBasic().getCurrentUser();
    if (currentUser != null) {
      final userId = currentUser.uid;

      // Remove the friend request from the user's 'friends' collection
      final requestDoc = FirebaseFirestore.instance
          .collection('friendships')
          .doc(userId)
          .collection('friends')
          .doc(friendUserId);
      await requestDoc.delete();

      if (kDebugMode) {
        print('Friend request declined');
      }
    } else {
      // User is not authenticated, handle the case accordingly
      if (kDebugMode) {
        print('User is not logged in');
      }
      // You can show a dialog, navigate to a login screen, or take any other appropriate action
    }
  }

  Stream<QuerySnapshot> getFriendRequests() async* {
    final currentUser = FirebaseBasic().getCurrentUser();
    if (currentUser != null) {
      // Retrieve friend requests sent to the current user
      final userId = currentUser.uid;
      yield* FirebaseFirestore.instance
          .collection('friendships')
          .doc(userId)
          .collection('friends')
          .where('status', isEqualTo: 'pending')
          .snapshots();
    } else {
      throw Exception('User is not authenticated');
    }
  }

}







