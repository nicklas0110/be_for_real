import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';


Reference get firebaseStorage => FirebaseStorage.instance.ref();

class FirebaseStorageService extends GetxService {
  Future<String?> getImage(String? imgName) async {
    if (imgName == null) {
      return null;
    }
    try {
      var urlRef = firebaseStorage.child('images')
          .child('0bSXnSOeUghn5pb3wJnXCwRcfLy2')
          .child('${imgName.toLowerCase()}.png');
      var imgURL = await urlRef.getDownloadURL();
      return imgURL;
    } catch (e) {
      return null;
    }
  }
}