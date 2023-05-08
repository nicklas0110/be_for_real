import 'package:camera/camera.dart';
import 'package:flutter/material.dart';


// https://docs.flutter.dev/cookbook/plugins/picture-using-camera

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraDescription? camera;

  @override
  void initState() {
    super.initState();
    _getCameras().then((cameras) {
      setState(() {
        // Set the camera variable to the first back camera
        camera = cameras.firstWhere(
              (camera) => camera.lensDirection == CameraLensDirection.back,
          orElse: () => cameras.first,
        );
      });
    });
  }

  Future<List<CameraDescription>> _getCameras() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    return cameras;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: const [
          Expanded(
            child: Center(
              child: Text(
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  "BeForReal"),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (camera == null)
            _buildCameraSelection()
          else
            CameraWidget(
              camera: camera!,
              key: ValueKey('camera-${camera!.name}'),
            )
        ],
      ),
    );
  }


  FutureBuilder<List<CameraDescription>> _buildCameraSelection() {
    return FutureBuilder(
      future: _getCameras(),
      builder: (context, snapshot) {
        return DropdownButton<CameraDescription>(
            value: camera,
            hint: const Text('Select a camera'),
            items: snapshot.data
                    ?.map((e) => DropdownMenuItem(
                          value: e,
                          child: Text('${e.lensDirection.name} ${e.name}'),
                        ))
                    .toList() ??
                [],
            onChanged: (camera) {
              setState(() {
                this.camera = camera;
              });
            });
      },
    );
  }
}

class CameraWidget extends StatefulWidget {
  final CameraDescription camera;
  const CameraWidget({required this.camera, super.key});

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If the Future is complete, display the preview.
          return Column(
            children: [CameraPreview(_controller), _takePictureButton(context)],
          );
        } else {
          // Otherwise, display a loading indicator.
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  FloatingActionButton _takePictureButton(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);
    return FloatingActionButton(
      // Provide an onPressed callback.
      onPressed: () async {
        // Take the Picture in a try / catch block. If anything goes wrong,
        // catch the error.
        try {
          // Ensure that the camera is initialized.
          await _initializeControllerFuture;

          // Attempt to take a picture and then get the location
          // where the image file is saved.
          final image = await _controller.takePicture();
          print(image.path);
          messenger.showSnackBar(SnackBar(content: Text(image.path)));
        } catch (e) {
          // If an error occurs, log the error to the console.
          print(e);
        }
      },
      child: const Icon(Icons.camera_alt),
    );
  }
}
