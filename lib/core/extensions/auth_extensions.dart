
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

extension AuthExtensions on BuildContext {
  bool get isNotLoggedIn {
    final user = FirebaseAuth.instance.currentUser;
    return user == null;
  }
}
