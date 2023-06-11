
import 'package:be_for_real/Alexs_Firebase_mappe/cameraService.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
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

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key, required this.title});

  final String title;

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final path = "gs://be-for-real.appspot.com/Images";
  CameraController? _controller;
  bool waiting = false;

  FirebaseAuth auth = FirebaseAuth.instance;

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
    availableCameras().then((cameras) async {
      final camera = cameras
          .firstWhere((cam) => cam.lensDirection == CameraLensDirection.back);
      _controller = CameraController(camera, ResolutionPreset.high);
      await _controller?.initialize();
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    if (_controller == null || waiting) {
      return const Center(child: CircularProgressIndicator());
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
                    child: CameraPreview(_controller!))),
            Transform.translate(
              offset: const Offset(0, -50),
              child: Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: FloatingActionButton(
                  onPressed: () async {

                    final back = await _controller!.takePicture();
                    setState(() {
                      waiting = true;
                    });

                    final cameras = await availableCameras();
                    final camera = cameras.firstWhere((cam) =>
                    cam.lensDirection == CameraLensDirection.front);
                    _controller =
                        CameraController(camera, ResolutionPreset.high);
                    await _controller?.initialize();
                    setState(() {});

                    final front = await _controller!.takePicture();

                    final byte1 = await back.readAsBytes();

                    final byte2 = await front.readAsBytes();

                    await CameraService().uploadPhotos(
                        uid: getUid(),
                        backBytes: byte1,
                        frontBytes: byte2,
                        email: user!.email!);

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Column(children: [
                          Text(back.path),
                          Text(front.path),
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
