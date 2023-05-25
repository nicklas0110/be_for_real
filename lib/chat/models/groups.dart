class ChannelKeys {
  static const name = 'name';
  static const members = 'members';
  static const imageUrl = 'imageUrl';
}

class Groups {
  final String id;
  final String name;
  final List<String> members;
  final String? imageUrl;

  Groups(this.id, this.name, this.members, this.imageUrl);

  Groups.fromMap(this.id, Map<String, dynamic> data, {String? imageUrl})
      : name = data[ChannelKeys.name],
        members = List<String>.from(data[ChannelKeys.members]),
        imageUrl = data[ChannelKeys.imageUrl];

  Map<String, dynamic> toMap() {
    return {
      ChannelKeys.name: name,
      ChannelKeys.members: members,
      ChannelKeys.imageUrl: imageUrl
    };
  }
}
