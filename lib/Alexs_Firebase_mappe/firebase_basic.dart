import 'package:firebase_auth/firebase_auth.dart';


class FirebaseBasic{
  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  Future<String?> getUserEmail() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user != null) {
      return user.email;
    }
    return null;
  }
}