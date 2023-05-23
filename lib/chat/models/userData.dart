export 'package:firebase_auth/firebase_auth.dart';

class UserKeys {
  static const name = 'name';
  static const imageUrl = 'imageUrl';
}

class User {
  final String id;
  final String name;
  final String? imageUrl;

  User(this.id, this.name, this.imageUrl);

  User.fromMap(this.id, Map<String, dynamic> data, {String? imageUrl})
      : name = data[UserKeys.name],
        imageUrl = data[UserKeys.imageUrl];

  Map<String, dynamic> toMap() {
    return {UserKeys.name: name, UserKeys.imageUrl: imageUrl};
  }


}
