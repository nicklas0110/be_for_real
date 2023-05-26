class UserPicture {
  final String id;
  final String user;
  final String timestamp;
  final String location;
  final String imageUrlFront;
  final String imageUrlBack;
  final String email;
  final String caption;
  final List<String> comments;

  UserPicture(
      this.id,
      this.user,
      this.timestamp,
      this.location,
      this.imageUrlFront,
      this.imageUrlBack,
      this.email,
      this.caption,
      this.comments);

  UserPicture.fromMap(this.id, Map<String, dynamic> data)
      : user = data[UserPictureKeys.user],
        timestamp = data[UserPictureKeys.timestamp],
        location = data[UserPictureKeys.location],
        imageUrlFront = data[UserPictureKeys.imageUrlFront],
        imageUrlBack = data[UserPictureKeys.imageUrlBack],
        email = data[UserPictureKeys.email],
        caption = data[UserPictureKeys.caption],
        comments = List<String>.from(data[UserPictureKeys.comments]);

  Map<String, dynamic> toMap() {
    return {
      UserPictureKeys.user: user,
      UserPictureKeys.timestamp: timestamp,
      UserPictureKeys.location: location,
      UserPictureKeys.imageUrlFront: imageUrlFront,
      UserPictureKeys.imageUrlBack: imageUrlBack,
      UserPictureKeys.email: email,
      UserPictureKeys.caption: caption,
      UserPictureKeys.comments: comments,
    };
  }

  String getImageUrl(bool useFrontImage) {
    return useFrontImage ? imageUrlFront : imageUrlBack;
  }
}

class UserPictureKeys {
  static const user = 'uid';
  static const timestamp = 'timestamp';
  static const location = 'location';
  static const imageUrlFront = 'front';
  static const imageUrlBack = 'back';
  static const email = 'email';
  static const caption = 'caption';
  static const comments = 'comments';
}
