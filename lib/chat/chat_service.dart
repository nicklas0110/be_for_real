import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/channel.dart';
import 'models/message.dart';
import 'models/sender.dart';
import 'models/user.dart';

String generateId() {
  return Random().nextInt(2 ^ 53).toString();
}

class CollectionNames {
  static const channels = 'channels';
  static const messages = 'messages';
}

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<Iterable<Channel>> channels(User user) {
    return _firestore
        .collection(CollectionNames.channels)
        .where(ChannelKeys.members, arrayContains: user.uid)
        .orderBy(ChannelKeys.name)
        .withConverter(
      fromFirestore: (snapshot, options) =>
          Channel.fromMap(snapshot.id, snapshot.data()!),
      toFirestore: (value, options) => value.toMap(),
    )
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs.map((doc) => doc.data()));
  }

  Query<Message> messages(Channel channel) {
    return _firestore
        .collection(CollectionNames.channels)
        .doc(channel.id)
        .collection(CollectionNames.messages)
        .orderBy(MessageKeys.timestamp)
        .withConverter(
      fromFirestore: (snapshot, options) =>
          Message.fromMap(snapshot.id, snapshot.data()!),
      toFirestore: (value, options) => value.toMap(),
    );
  }

  Future<void> sendMessage(User user, Channel channel, String message) async {
    final sender = Sender(
        uid: user.uid,
        displayName: user.displayName ?? '',
        email: user.email ?? 'Unknown');
    await _firestore
        .collection(CollectionNames.channels)
        .doc(channel.id)
        .collection(CollectionNames.messages)
        .add({
      MessageKeys.timestamp: FieldValue.serverTimestamp(),
      MessageKeys.from: sender.toMap(),
      MessageKeys.content: message
    });
  }

  Future<void> createChannel(User user, String name) async {
    await _firestore.collection(CollectionNames.channels).add({
      ChannelKeys.members: [user.uid],
      ChannelKeys.name: name,
    });
  }

  Future<void> addMember(Channel channel, String uid) async {
    await _firestore
        .collection(CollectionNames.channels)
        .doc(channel.id)
        .update({
      ChannelKeys.members: FieldValue.arrayUnion([uid])
    });
  }
}

