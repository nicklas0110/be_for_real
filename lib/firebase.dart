import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '/tabs/friendTab/friendPicture.dart';

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

  void addFriendByEmail(String friendEmail) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('register')
        .where('email', isEqualTo: friendEmail)
        .limit(1)
        .get();

    if (querySnapshot.size > 0) {
      final userDoc = querySnapshot.docs[0];
      final userData = userDoc.data();

      // Perform actions with the user data
      final friendName = userData['name'];

      print('Friend name: $friendName'); // Debug print statement

      final currentUser = getCurrentUser();
      if (currentUser != null) {
        final recipientUserId = currentUser.uid;

        // Logic to send a friend request to the recipient user

        // Example: Updating a 'friendships' collection with the friend request
        final requestDoc = FirebaseFirestore.instance.collection('friendships').doc(recipientUserId);
        final friendsCollection = requestDoc.collection('friends');

        final requestSnapshot = await friendsCollection.where('name', isEqualTo: friendName).get();
        if (requestSnapshot.size > 0) {
          // Friend request already exists for the given name
          print('Friend request already sent for $friendName');
        } else {
          await friendsCollection.add({
            'name': friendName,
            'userId': recipientUserId,
            'status': 'pending',
            'timestamp': DateTime.now(),
          });
          print('Friend request sent to $friendName');
        }
      } else {
        // User is not authenticated, handle the case accordingly
        print('User is not logged in');
        // You can show a dialog, navigate to a login screen, or take any other appropriate action
      }
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
