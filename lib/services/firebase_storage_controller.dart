import 'package:be_for_real/services/firebase_storage_service.dart';
import 'package:get/get.dart';

class FirebaseServiceController extends GetxController {
  var allUserImages = <String>[];


  @override
  void onReady() {
    getAllImages();
    super.onReady();
  }

  Future<void> getAllImages() async {
    allUserImages = [];
    List<String> imgName = [
      "back&Esbjerg, Danmark&2023:05:10 -14.33",
      "back&Esbjerg, Danmark&2023:05:10 -14.33",
      "back&Esbjerg, Danmark&2023:05:10 -14.33",
      "back&Esbjerg, Danmark&2023:05:10 -14.33",
      "back&Esbjerg, Danmark&2023:05:10 -14.33",
    ];
    try {
      for(var img in imgName) {
        final imgUrl = await Get.find<FirebaseStorageService>().getImage(img);
      allUserImages.add(imgUrl!);
      }
    } catch (e) {
      print(e);
    }
  }
}
