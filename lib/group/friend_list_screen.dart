import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FriendListScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  FriendListScreen({super.key});

  String getUid() {
    User? user = auth.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friend List'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _firestore
            .collection('friendsRegister')
            .doc(getUid())
            .collection('friends')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final friends = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: friends.length,
            itemBuilder: (context, index) {
              final friend = friends[index].data();
              final friendName = friend['name'] ?? '';
              final friendEmail = friend['email'] ?? '';
              final friendImageUrl = friend['photoUrl'] ?? '';

              return ListTile(
                leading: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.blueGrey,
                      width: 1.0,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      friendImageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Text(friendName),
                subtitle: Text(friendEmail),
                onTap: () {
                  // Add your onTap logic here
                },
              );
            },
          );
        },
      ),
    );
  }
}





