import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:be_for_real/firebase.dart';

class AddFriendScreen extends StatefulWidget {
  @override
  _AddFriendScreenState createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  final TextEditingController _emailController = TextEditingController();
  final Firebase _firebase = Firebase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Add Friends'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Enter Friend Email',
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                child: const Text('Add Friend'),
                onPressed: () async {
                  final friendEmail = _emailController.text;
                  final currentUser = await _firebase.getCurrentUser();

                  if (currentUser != null) {
                    // Add friend logic here
                    _firebase.addFriendByEmail(currentUser.uid, friendEmail);
                    Navigator.of(context).pop();
                  } else {
                    // User is not authenticated, handle the case accordingly
                    print('User is not logged in');
                    // You can show a dialog, navigate to a login screen, or take any other appropriate action
                  }
                },
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Friend Requests',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              FutureBuilder<QuerySnapshot>(
                future: _getFriendRequests(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    final friendRequests = snapshot.data!.docs;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: friendRequests.length,
                      itemBuilder: (context, index) {
                        final friendRequest = friendRequests[index];
                        final friendData = friendRequest.data() as Map<
                            String,
                            dynamic>?;
                        final friendName = friendData?['friendName'] as String?;
                        final friendUserId = friendRequest.id;

                        return ListTile(
                          title: Text(friendName!),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton(
                                child: const Text('Accept'),
                                onPressed: () {
                                  _firebase.acceptFriendRequest(friendUserId);
                                  // Perform any additional actions after accepting the friend request
                                },
                              ),
                              const SizedBox(width: 8.0),
                              ElevatedButton(
                                child: const Text('Decline'),
                                onPressed: () {
                                  _firebase.declineFriendRequest(friendUserId);
                                  // Perform any additional actions after declining the friend request
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return const Text('No friend requests found.');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<QuerySnapshot> _getFriendRequests() async {
    final currentUser = await _firebase.getCurrentUser();
    if (currentUser != null) {
      // Retrieve friend requests for the current user
      final userId = currentUser.uid;
      final querySnapshot = await FirebaseFirestore.instance
          .collection('friendships')
          .doc(userId)
          .collection('friends')
          .where('status', isEqualTo: 'pending')
          .get();

      return querySnapshot;
    } else {
      throw Exception('User is not authenticated');
    }
  }
}