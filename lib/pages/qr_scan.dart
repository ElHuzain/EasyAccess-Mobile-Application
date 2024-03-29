import 'dart:io';
import 'package:authenticator/config/config.dart';
import 'package:authenticator/pages/restore_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../services/Authentication.dart';
import '../services/Navigation.dart';
import '../services/Preferences.dart';
import '../services/http.dart';
import '../widgets/custom_widgets/custom_widget.dart';

class qr_scan extends StatefulWidget {
  const qr_scan({Key? key}) : super(key: key);

  @override
  State<qr_scan> createState() => _qr_scanState();
}

class _qr_scanState extends State<qr_scan> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.Primary,
      body: Column(
        children: <Widget>[
          Expanded(flex: 6, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ButtonWidget(
                          title: "Return",
                          icon: Icons.arrow_back,
                          func: () async {
                            Navigate.To(context, restore_page());
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ButtonWidget(
                          title: "Sart Camera",
                          icon: Icons.camera,
                          func: () async {
                            await controller?.resumeCamera();
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 40,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    if (mounted) {
      setState(() {
        this.controller = controller;
      });
    }
    controller.scannedDataStream.listen((scanData) async {
      String route = "/findaccount?code=${scanData.code}";
      dynamic response = await Http.get(route);

      if (response['status'] == 'ok') {
        await Preferences.setPref('pendingId', response['acc']['id']);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => restore_page(pin: true, Account: response['acc']),
          ),
        );
      } else if (response['status'] == 'authenticate') {
        await Authentication.Login(document: response['acc'], context: context);
      } else if (mounted)
        setState(() {
          result = scanData;
        });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    // log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }
}
