

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
  final File? img;

  Groups(this.id, this.name, this.members, this.img);

  Groups.fromMap(this.id, Map<String, dynamic> data)
      : name = data[ChannelKeys.name],
        members = [...data[ChannelKeys.members]],
        img = data[ChannelKeys.image];

  Map<String, dynamic> toMap() {
    return {ChannelKeys.name: name, ChannelKeys.members: members, ChannelKeys.image: img};
  }
}
