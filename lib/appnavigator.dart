import 'package:flutter/material.dart';

class AppNavigator {
  static void goToAndClearStack(BuildContext context, Widget page) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => page),
      (route) => false,
    );
  }
}
