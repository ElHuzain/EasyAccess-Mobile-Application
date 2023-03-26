// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class Navigate {
  static void Push(BuildContext context, Widget newRoute) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => newRoute));
  }

  static void To(BuildContext context, Widget newRoute) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => newRoute));
  }
}
