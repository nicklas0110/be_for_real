import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
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
  CameraController? _controller;
  bool waiting = false;



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

  getLocationPermitions() async {
// You can request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses = await [
    Permission.location,
    ].request();
    print(statuses[Permission.location]);
  }

  @override
  void initState() {
    availableCameras().then((cameras) async {
      final camera = cameras
          .firstWhere((cam) => cam.lensDirection == CameraLensDirection.back);
      _controller = CameraController(camera, ResolutionPreset.high);
      await _controller?.initialize();
      setState(() {});
    });
    getLocationPermitions();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy:MM:dd -kk.mm').format(now);

    if (_controller == null || waiting) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Stack(
          children: <Widget>[
            Align(
                alignment: Alignment.center,
                child: Transform.scale(
                    scale: 0.95, // Adjust the scale factor as needed
                    child: CameraPreview(_controller!))
            ),
            Transform.translate(
              offset: Offset(0, -50),
              child: Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: FloatingActionButton(
                  onPressed: () async {
                    String location = await getCurrentPlaceName();

                    final file1 = await _controller!.takePicture();
                    setState(() {
                      waiting = true;
                    });

                    final cameras = await availableCameras();
                    final camera = cameras.firstWhere(
                            (cam) => cam.lensDirection == CameraLensDirection.front);
                    _controller = CameraController(camera, ResolutionPreset.high);
                    await _controller?.initialize();
                    setState(() {});

                    final file2 = await _controller!.takePicture();
                    final templateUpload =
                        FirebaseStorage.instance.ref('/Images').child(getUid()).child(location + '_' + formattedDate);

                    final byte1 = await file1.readAsBytes();

                    final byte2 = await file2.readAsBytes();

                    templateUpload
                        .child('back')
                        .putData(byte1);
                    templateUpload
                        .child('front')
                        .putData(byte2);

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Column(children: [
                      Text(file1.path),
                      Text(file2.path),
                    ])));
                    Navigator.of(context).pop();
                  },
                  tooltip: 'Take picture',
                  child: const Icon(Icons.camera),
                ),
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
