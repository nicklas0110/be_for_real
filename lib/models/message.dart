import 'package:cloud_firestore/cloud_firestore.dart';

import 'sender.dart';

class MessageKeys {
  static const timestamp = 'timestamp';
  static const from = 'from';
  static const content = 'content';
}

// this class is telling what a message is containing when made
class Message {
  final String id;
  final DateTime? timestamp;
  final Sender from;
  final String content;

  Message(
      {required this.id,
        required this.timestamp,
        required this.from,
        required this.content});

  Message.fromMap(this.id, Map<String, dynamic> data)
      : timestamp = (data[MessageKeys.timestamp] as Timestamp?)?.toDate(),
        from = Sender.fromMap(data[MessageKeys.from]),
        content = data[MessageKeys.content];

  Map<String, dynamic> toMap() {
    return {
      MessageKeys.timestamp: timestamp,
      MessageKeys.from: from,
      MessageKeys.content: content
    };
  }
}