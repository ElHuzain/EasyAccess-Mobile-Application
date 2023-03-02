import 'package:flutter/material.dart';

class Navigate {
  static void To(BuildContext context, Widget newRoute) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => newRoute));
  }
}
