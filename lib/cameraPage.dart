import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'chat/screens/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Camera', friendTab: '', groupTab: '',),
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
  CameraController? _controllerBack;
  CameraController? _controllerFront;

  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    getFrontAndBackCamera().then((cameras) async {
      _controllerBack = CameraController(cameras.back, ResolutionPreset.medium);
      _controllerFront =
          CameraController(cameras.front, ResolutionPreset.medium);
      await _controllerBack?.initialize();
      await _controllerFront?.initialize();
      setState(() {
        _initialized = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) return Center(child: CircularProgressIndicator());
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[CameraPreview(_controllerBack!)],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final file1 = await _controllerBack!.takePicture();
          final file2 = await _controllerFront!.takePicture();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Column(children: [
                Text(file1.path),
                Text(file2.path),
              ])));
        },
        tooltip: 'Take picture',
        child: const Icon(Icons.camera),
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