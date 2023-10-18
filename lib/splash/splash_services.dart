import 'dart:async';
import 'package:divine/screens/bottomNavigationBar.dart';
import 'package:divine/screens/loginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.pushNamedAndRemoveUntil(
              context, BottomBarDesign.pageName, (route) => false));
    } else {
      Timer(
          const Duration(seconds: 2),
          () => Navigator.pushNamedAndRemoveUntil(
              context, DivineApp.pageName, (route) => false));
    }
  }
}
