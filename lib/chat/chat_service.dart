import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/groups.dart';
import 'models/message.dart';
import 'models/sender.dart';
import 'models/user.dart';

String generateId() {
  return Random().nextInt(2 ^ 53).toString();
}

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Stream<Iterable<Groups>> groups(User user) {
    return _firestore
        .collection('groups')
        .where(ChannelKeys.members, arrayContains: user.email!)
        .orderBy(ChannelKeys.name)
        .withConverter(
      fromFirestore: (snapshot, options) =>
          Groups.fromMap(snapshot.id, snapshot.data()!),
      toFirestore: (value, options) => value.toMap(),
    )
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs.map((doc) => doc.data()));
  }

  Query<Message> messages(Groups group) {
    return _firestore
        .collection('groups')
        .doc(group.id)
        .collection('messages')
        .orderBy(MessageKeys.timestamp)
        .withConverter(
      fromFirestore: (snapshot, options) =>
          Message.fromMap(snapshot.id, snapshot.data()!),
      toFirestore: (value, options) => value.toMap(),
    );
  }

  Future<void> sendMessage(User user, Groups channel, String message) async {
    final sender = Sender(
        uid: user.uid,
        displayName: user.displayName ?? '',
        email: user.email ?? 'Unknown');
    await _firestore
        .collection('groups')
        .doc(channel.id)
        .collection('messages')
        .add({
      MessageKeys.timestamp: FieldValue.serverTimestamp(),
      MessageKeys.from: sender.toMap(),
      MessageKeys.content: message
    });
  }

  Future<void> createChannel(User user, String name) async {
    await _firestore.collection('groups').add({
      ChannelKeys.members: [user.email!],
      ChannelKeys.name: name,
      ChannelKeys.image: "assets/Placeholder.png"
    });
  }

  Future<void> addMember(Groups groups, String email) async {
    await _firestore
        .collection('groups').doc(groups.id).update({
      ChannelKeys.members: FieldValue.arrayUnion([email])
    });
  }
}

