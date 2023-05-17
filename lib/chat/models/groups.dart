

import 'dart:io';

class ChannelKeys {
  static const name = 'name';
  static const members = 'members';
  static const image = 'image';
}

class Groups {
  final String id;
  final String name;
  final List<String> members;
  final String? image;

  Groups(this.id, this.name, this.members, this.image);

  Groups.fromMap(this.id, Map<String, dynamic> data)
      : name = data[ChannelKeys.name],
        members = [...data[ChannelKeys.members]],
        image = data[ChannelKeys.image];

  Map<String, dynamic> toMap() {
    return {ChannelKeys.name: name, ChannelKeys.members: members, ChannelKeys.image: image};
  }
}
