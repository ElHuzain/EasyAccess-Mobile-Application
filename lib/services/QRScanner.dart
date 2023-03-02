// ignore_for_file: non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'Navigation.dart';
import 'Preferences.dart';
import 'http.dart';

class QRScanner {
  static Future<void> Scan() async {
    QRViewController? controller;
    bool isScanned = false;
    controller?.scannedDataStream.listen((scanData) async {
      isScanned = true;
      print(scanData);
    });
  }
}
