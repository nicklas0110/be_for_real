import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import '../../locationUtil.dart';
import 'home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(
        title: 'Camera',
        friendTab: '',
        groupTab: '',
      ),
    );
  }
}

// https://docs.flutter.dev/cookbook/plugins/picture-using-camera

class CameraPage extends StatefulWidget {
  const CameraPage({super.key, required this.title});

  final String title;

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final path = "gs://be-for-real.appspot.com/Images";
  CameraController? _controllerBack;
  CameraController? _controllerFront;

  bool _initialized = false;

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<String> getCurrentPlaceName() async {
    final position = await determinePosition();
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    final place = placemarks.first;
    return "${place.locality}, ${place.country}";
  }

  String getUid() {
    User? user = auth.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return '';
    }
  }

  @override
  void initState() {
    super.initState();
    getFrontAndBackCamera().then((cameras) async {
      _controllerBack = CameraController(cameras.back, ResolutionPreset.medium);
      await _controllerBack?.initialize();
      _controllerFront =
          CameraController(cameras.front, ResolutionPreset.medium);
      await _controllerFront?.initialize();
      setState(() {
        _initialized = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy:MM:dd -kk.mm').format(now);

    if (!_initialized) return Center(child: CircularProgressIndicator());
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Stack(
          children: <Widget>[
            Align(
                alignment: Alignment.center,
                child: CameraPreview(_controllerBack!)),
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: FloatingActionButton(
                onPressed: () async {
                  String location = await getCurrentPlaceName();

                  final file1 = await _controllerBack!.takePicture();
                  final byte1 = await file1.readAsBytes();

                  final file2 = await _controllerFront!.takePicture();
                  final byte2 = await file2.readAsBytes();

                  final templateUpload =
                      FirebaseStorage.instance.ref('/Images').child(getUid());

                  templateUpload
                      .child('back' + '&' + location + '&' + formattedDate)
                      .putData(byte1);
                  templateUpload
                      .child('front' + '&' + location + '&' + formattedDate)
                      .putData(byte2);

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Column(children: [
                    Text(file1.path),
                    Text(file2.path),
                  ])));
                },
                tooltip: 'Take picture',
                child: const Icon(Icons.camera),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FrontAndBackCamera {
  final CameraDescription front;
  final CameraDescription back;

  FrontAndBackCamera({required this.front, required this.back});
}

Future<FrontAndBackCamera> getFrontAndBackCamera() async {
  final cameras = await availableCameras();
  return FrontAndBackCamera(
    front: cameras
        .firstWhere((cam) => cam.lensDirection == CameraLensDirection.front),
    back: cameras
        .firstWhere((cam) => cam.lensDirection == CameraLensDirection.back),
  );
}
