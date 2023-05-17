import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '/tabs/friendTab/friendPicture.dart';

class Firebase {

 Future<void> uploadImage(File imageFile) async {
    final fileName = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();
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

 void sendFriendRequest() {

   final currentUser = getCurrentUser();
   final username = friendUsername;
   if (currentUser != null) {
     final recipientUserId = currentUser.uid;
     // Logic to send a friend request to the recipient user

     // Example: Updating a 'friends' collection with the friend request
     FirebaseFirestore.instance.collection('Groups/groups/members').doc(recipientUserId).collection('friends').add({
       'username': username,
       'userId': recipientUserId,
       'status': 'pending',
       'timestamp': DateTime.now(),
     });
   } else {
     // User is not authenticated, handle the case accordingly
     print('User is not logged in');
     // You can show a dialog, navigate to a login screen, or take any other appropriate action
   }
 }
 }
