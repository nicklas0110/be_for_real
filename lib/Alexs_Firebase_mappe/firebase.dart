import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/tabs/friendTab/friendPicture.dart';
import '../chat/models/groups.dart';

class Firebase {
  Future<void> uploadImage(File imageFile) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final Reference reference =
        FirebaseStorage.instance.ref().child('images/$fileName.jpg');
    final UploadTask uploadTask = reference.putFile(imageFile);
    final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    print('Image URL: $downloadUrl');
  }

  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }
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
        print('A friend request has already been sent to $friendEmail');
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

      print('Friend request sent to $friendEmail');
    } else {
      print('User with email $friendEmail not found');
    }
  }

  // Function to accept a friend request
  void acceptFriendRequest(String friendUserId) async {
    final currentUser = getCurrentUser();
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
      final friendsCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('friends');
      final friendDoc = await friendsCollection.doc(friendUserId).get();
      if (!friendDoc.exists) {
        final friendData = await FirebaseFirestore.instance
            .collection('users')
            .doc(friendUserId)
            .get();

        final friendDataMap = friendData?.data() ?? {}; // Provide an empty map if friendData is null

        friendsCollection.doc(friendUserId).set(friendDataMap);
      }

      print('Friend request accepted');
    } else {
      // User is not authenticated, handle the case accordingly
      print('User is not logged in');
      // You can show a dialog, navigate to a login screen, or take any other appropriate action
    }
  }

  // Function to decline a friend request
  void declineFriendRequest(String friendUserId) async {
    final currentUser = getCurrentUser();
    if (currentUser != null) {
      final userId = currentUser.uid;

      // Remove the friend request from the user's 'friends' collection
      final requestDoc = FirebaseFirestore.instance
          .collection('friendships')
          .doc(userId)
          .collection('friends')
          .doc(friendUserId);
      await requestDoc.delete();

      print('Friend request declined');
    } else {
      // User is not authenticated, handle the case accordingly
      print('User is not logged in');
      // You can show a dialog, navigate to a login screen, or take any other appropriate action
    }
  }
}
