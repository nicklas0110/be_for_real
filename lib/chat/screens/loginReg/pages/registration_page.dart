import 'dart:io';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../themHelper/reg_login_theme_helper.dart';
import 'login_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage>
    with SingleTickerProviderStateMixin {
  bool checkedValue = false;
  bool checkboxValue = false;

  XFile? photo;
  final _userEmailRegister = TextEditingController();
  final _userNameRegister = TextEditingController();
  final _passwordRegister = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late AnimationController controller;

  bool isLoading = false;
  final int delayAmount = 500;

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

  Future<void> uploadPfp(String userId) async {
    File uploadFile = File(photo!.path);
    try {
      await FirebaseStorage.instance
          .ref('profileImages/$userId.jpg') // Use a unique file name for each user
          .putFile(uploadFile);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<String> getDownload(String userId) async {
    String downloadUrl = await FirebaseStorage.instance
        .ref("profileImages/$userId.jpg")
        .getDownloadURL();
    return downloadUrl;
  }

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
    controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.fromLTRB(25, 10, 25, 10),
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          alignment: Alignment.center,
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
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
                              backgroundImage: photo != null
                                  ? FileImage(File(photo!.path))
                                  : null,
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
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      decoration: ThemeHelper().inputBoxDecorationShadow(),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _userNameRegister,
                        validator: (value) =>
                        (value == null || value.isEmpty)
                            ? 'Name required'
                            : null,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          labelStyle: const TextStyle(color: Colors.white),
                          hintText: 'Enter your Name',
                          hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.5)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                            const BorderSide(color: Colors.black87),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                            const BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      decoration: ThemeHelper().inputBoxDecorationShadow(),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _userEmailRegister,
                        validator: (value) =>
                        (value == null || !value.contains("@"))
                            ? 'Email required'
                            : null,
                        decoration: InputDecoration(
                          labelText: 'E-mail',
                          labelStyle: const TextStyle(color: Colors.white),
                          hintText: 'Enter your E-mail',
                          hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.5)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                            const BorderSide(color: Colors.black87),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                            const BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Container(
                      decoration: ThemeHelper().inputBoxDecorationShadow(),
                      child: TextFormField(
                        controller: _passwordRegister,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: const TextStyle(color: Colors.white),
                          hintText: 'Enter your password',
                          hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.5)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                            const BorderSide(color: Colors.black87),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                            const BorderSide(color: Colors.white),
                          ),
                        ),
                        obscureText: true,
                        validator: (value) =>
                        (value == null || value.isEmpty)
                            ? 'Password required'
                            : null,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    FormField<bool>(
                      builder: (state) {
                        return Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Checkbox(
                                  value: checkboxValue,
                                  onChanged: (value) {
                                    setState(() {
                                      checkboxValue = value!;
                                      state.didChange(value);
                                    });
                                  },
                                ),
                                const Text(
                                  "I accept all terms and conditions.",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                state.errorText ?? '',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color:
                                  Theme.of(context).colorScheme.error,
                                  fontSize: 12,
                                ),
                              ),
                            )
                          ],
                        );
                      },
                      validator: (value) {
                        if (!checkboxValue) {
                          return 'You need to accept terms and conditions';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 20.0),
                    GestureDetector(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            final newUser =
                            await _auth.createUserWithEmailAndPassword(
                              email: _userEmailRegister.text.trim(),
                              password: _passwordRegister.text.trim(),
                            );
                            final userId = newUser.user!.uid;
                            if (photo != null) {
                              await uploadPfp(userId);
                            }
                            final downloadUrl = await getDownload(userId);
                            await _firestore
                                .collection('register')
                                .doc(userId)
                                .set({
                              'name': _userNameRegister.text,
                              'email': _userEmailRegister.text.trim(),
                              'photoUrl': downloadUrl,
                              'created_at': FieldValue.serverTimestamp()
                            });
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          } catch (e) {
                            if (kDebugMode) {
                              print(e);
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Registration failed.'),
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
                        color: Colors.cyan [900],
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                          child: const Text(
                            'Register',
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
                    const SizedBox(height: 10.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                        child: const Text(
                          'Back to Login',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    isLoading
                        ? const CircularProgressIndicator()
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
