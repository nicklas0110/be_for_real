
class DailyPicture {
  final String id;
  final String user;
  final String timestamp;
  final String location;
  final String imageUrlFront;
  final String imageUrlBack;
  final String email;

  DailyPicture(
    this.id,
    this.user,
    this.timestamp,
    this.location,
    this.imageUrlFront,
    this.imageUrlBack,
    this.email,
  );

  DailyPicture.fromMap(this.id, Map<String, dynamic> data)
      : user = data[DailyPictureKeys.user],
        timestamp = data[DailyPictureKeys.timestamp],
        location = data[DailyPictureKeys.location],
        imageUrlFront = data[DailyPictureKeys.imageUrlFront],
        imageUrlBack = data[DailyPictureKeys.imageUrlBack],
        email = data[DailyPictureKeys.email];

  Map<String, dynamic> toMap() {
    return {
      DailyPictureKeys.user: user,
      DailyPictureKeys.timestamp: timestamp,
      DailyPictureKeys.location: location,
      DailyPictureKeys.imageUrlFront: imageUrlFront,
      DailyPictureKeys.imageUrlBack: imageUrlBack,
      DailyPictureKeys.email: email,
    };
  }

  String getImageUrl(bool useFrontImage) {
    return useFrontImage ? imageUrlFront : imageUrlBack;
  }
}

class DailyPictureKeys {
  static const user = 'uid';
  static const timestamp = 'timestamp';
  static const location = 'location';
  static const imageUrlFront = 'front';
  static const imageUrlBack = 'back';
  static const email = 'email';
}
