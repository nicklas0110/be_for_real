import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/groups.dart';
import '../models/message.dart';
import '../models/sender.dart';
import '../models/user.dart';

//This is the firebase for everything from the groupScreen and beyond
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
      fromFirestore: (snapshot, options) {
        final data = snapshot.data()!;
        final groupId = snapshot.id;
        final imageUrl = data[ChannelKeys.imageUrl] as String?;
        return Groups.fromMap(groupId, data, imageUrl: imageUrl);
      },
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

  Future<DocumentReference> createChannel(User user, String name, {required String imageUrl}) async {
    return await _firestore.collection('groups').add({
      ChannelKeys.members: [user.email!],
      ChannelKeys.name: name,
      ChannelKeys.imageUrl: imageUrl,
    });
  }
  Future<void> updateImageUrl(String groupId, {required String imageUrl}) async {
    return await _firestore.collection('groups').doc(groupId).update({
      ChannelKeys.imageUrl: imageUrl,
    });
  }
  Future<void> addMember(Groups groups, String email) async {
    await _firestore
        .collection('groups').doc(groups.id).update({
      ChannelKeys.members: FieldValue.arrayUnion([email])
    });
  }

  Future<void> deleteGroup(String groupId) async {
    try {
      final batch = FirebaseFirestore.instance.batch();
      // Delete group document
      final groupDocRef = FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId);
      batch.delete(groupDocRef);

      // Delete subcollections
      final subcollections = ['messages', 'members']; // Replace with the actual subcollection names
      for (final subcollection in subcollections) {
        final subcollectionRef = FirebaseFirestore.instance
            .collection('groups')
            .doc(groupId)
            .collection(subcollection);
        final docs = await subcollectionRef.get();
        for (final doc in docs.docs) {
          batch.delete(doc.reference);
        }
      }

      // Commit the batched writes
      await batch.commit();

      if (kDebugMode) {
        print('Group and associated subcollections deleted successfully!');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error deleting group: $error');
      }
    }
  }
}

