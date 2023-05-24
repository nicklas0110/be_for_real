import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FriendListScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId;

  FriendListScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friend List'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _firestore.collection('users').doc(userId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final friends = _firestore
          .collection('friendships')
          .doc(this.userId)
          .collection('friends');


          return ListView.builder(
            itemCount: friends.length,
            itemBuilder: (context, index) {
              final friendName = friends[index] as String;

              return ListTile(
                title: Text(friendName),
              );
            },
          );
        },
      ),
    );
  }
}





