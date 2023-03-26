// ignore_for_file: use_build_context_synchronously, must_be_immutable, camel_case_types
import 'package:authenticator/config/config.dart';
import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  String T;
  double size;
  bool isBold;
  bool wrap;
  TextWidget(this.T,
      {Key? key, this.size = 15, this.isBold = false, this.wrap = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      T,
      softWrap: wrap,
      style: TextStyle(
        fontSize: size,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        color: ThemeColor.Text,
      ),
    );
  }
}

class ButtonWidget extends StatelessWidget {
  dynamic func;
  String title;
  IconData icon;
  bool fullSize;
  ButtonWidget(
      {required this.func,
      required this.title,
      required this.icon,
      this.fullSize = false});
  // const ButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: ThemeColor.Secondary,
        // fixedSize: const Size(500, 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: this.func,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            this.icon,
            color: ThemeColor.Text,
          ),
          const SizedBox(width: 10),
          TextWidget(
            this.title,
            isBold: true,
          ),
        ],
      ),
    );
  }
}

snackBar(String? message, BuildContext context) {
  return ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(
        content: Text(message!),
        duration: const Duration(seconds: 2),
      ))
      .closed
      .then((value) => ScaffoldMessenger.of(context).clearSnackBars());
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
