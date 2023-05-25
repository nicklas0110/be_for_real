import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/tabs/friendTab/friendPicture.dart';
import '../models/groups.dart';

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