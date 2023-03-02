// ignore_for_file: use_build_context_synchronously, must_be_immutable, camel_case_types
import 'package:authenticator/config/config.dart';
import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  String T;
  double size;
  bool isBold;
  TextWidget(this.T, {Key? key, this.size = 15, this.isBold = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(T,
        style: TextStyle(
            fontSize: size,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: ThemeColor.Text));
  }
}

class Logo extends StatelessWidget {
  double size = 1;

  Logo(this.size);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.png',
      scale: size,
    );
  }
}
