import 'package:cloud_firestore/cloud_firestore.dart';

class DailyPicture {
  final String id;
  final String user;
  final String timestamp;
  final String location;
  final String imageUrlFront;
  final String imageUrlBack;

  DailyPicture(
    this.id,
    this.user,
    this.timestamp,
    this.location,
    this.imageUrlFront,
    this.imageUrlBack,
  );

  DailyPicture.fromMap(this.id, Map<String, dynamic> data)
      : user = data[DailyPictureKeys.user],
        timestamp = data[DailyPictureKeys.timestamp],
        location = data[DailyPictureKeys.location],
        imageUrlFront = data[DailyPictureKeys.imageUrlFront],
        imageUrlBack = data[DailyPictureKeys.imageUrlBack];

  Map<String, dynamic> toMap() {
    return {
      DailyPictureKeys.user: user,
      DailyPictureKeys.timestamp: timestamp,
      DailyPictureKeys.location: location,
      DailyPictureKeys.imageUrlFront: imageUrlFront,
      DailyPictureKeys.imageUrlBack: imageUrlBack,
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
}
