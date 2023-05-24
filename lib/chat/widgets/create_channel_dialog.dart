import 'dart:io';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../Alexs_Firebase_mappe/firebase_chat_service.dart';
import '../models/user.dart';

class CreateChannelDialog extends StatefulWidget {
  const CreateChannelDialog({super.key});

  @override
  State<CreateChannelDialog> createState() => _CreateChannelDialogState();
}

class _CreateChannelDialogState extends State<CreateChannelDialog> {
  final _firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  XFile? photo;
  bool isLoading = false;
  final _userEmailRegister = TextEditingController();
  final _userNameRegister = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  String _imageUrl = ''; // Define imageUrl variable

  String getUid() {
    User? user = auth.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return '';
    }
  }

  Future<void> uploadPfp(String userId) async {
    File uploadFile = File(photo!.path);
    try {
      await FirebaseStorage.instance
          .ref(
              'groupsImages/$userId.jpg') // Use a unique file name for each user
          .putFile(uploadFile);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }


  Future<String> getDownload(String userId) async {
    String downloadUrl = await FirebaseStorage.instance
        .ref("groupsImages/$userId.jpg")
        .getDownloadURL();
    return downloadUrl;
  }

  Future<void> pickImage() async {
    final ImageSource? source = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text('Gallery or Camera!'),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          actions: <Widget>[
            IconButton(
              onPressed: () => Navigator.pop(context, ImageSource.camera),
              icon: const Icon(Icons.camera_alt, color: Colors.white, size: 30),
            ),
            IconButton(
              onPressed: () => Navigator.pop(context, ImageSource.gallery),
              icon: const Icon(Icons.photo_library,
                  color: Colors.white, size: 30),
            ),
          ],
        );
      },
    );

    if (source != null) {
      final pickedFile = await ImagePicker().pickImage(
        source: source,
        imageQuality: 25,
      );

      if (pickedFile != null) {
        setState(() {
          photo = pickedFile;
        });
      }
    }
  }





  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final chat = Provider.of<ChatService>(context);
    return AlertDialog(
      title: const Text('Add Channel'),
      content: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) => value!.isEmpty ? 'Name required' : null,
            ),
            GestureDetector(
              onTap: pickImage,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.transparent,
                    width: 0.5,
                  ),
                ),
                child: AvatarGlow(
                  glowColor: Colors.white,
                  showTwoGlows: true,
                  repeat: true,
                  endRadius: 80.0,
                  child: Material(
                    shape: const CircleBorder(),
                    elevation: 2.0,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.transparent,
                      backgroundImage:
                          photo != null ? FileImage(File(photo!.path)) : null,
                      child: photo == null
                          ? const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 70,
                            )
                          : null,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () async {
            if (photo != null) {
              await uploadPfp(getUid());
            }
            if (_formKey.currentState!.validate()) {
              setState(() {
                isLoading = true;
              });
              try {

                // Set _imageUrl to the download URL
                _imageUrl = await getDownload(getUid());

                // Replace the following code with the createChannel method
                chat.createChannel(user, _userNameRegister.text,
                    imageUrl: _imageUrl); // Pass imageUrl to createChannel method

                // The rest of the code remains the same
                Navigator.of(context).pop();
              } catch (e) {
                if (kDebugMode) {
                  print(e);
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Group creation failed.'),
                  ),
                );
              }
              setState(() {
                isLoading = false;
              });
            }
          },
          child: Material(
            elevation: 3.0,
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.cyan[900],
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
              child: const Text(
                'Create Channel',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 15),
        GestureDetector(
          onTap: () async {
            Navigator.pop(context);
          },
          child: Material(
            elevation: 3.0,
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.cyan[900],
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
              child: const Text(
                'Close',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
