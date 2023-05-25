class FriendShipsKeys {
  static const friendName = 'friendName';
  static const status = 'status';
  static const timestamp = 'timestamp';
}

class FriendShips {
  final String uid;
  final String friendName;
  final String status;
  final String? timestamp;

  FriendShips(this.uid, this.friendName, this.status, this.timestamp);

  FriendShips.fromMap(this.uid, Map<String, dynamic> data, {String? imageUrl})
      : friendName = data[FriendShipsKeys.friendName],
        status = data[FriendShipsKeys.status],
        timestamp = data[FriendShipsKeys.timestamp];


  Map<String, dynamic> toMap() {
    return {FriendShipsKeys.friendName: friendName, FriendShipsKeys.status: status, FriendShipsKeys.timestamp: timestamp};
  }
}
