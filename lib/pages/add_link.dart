import 'package:authenticator/pages/restore_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../config/config.dart';
import '../services/Authentication.dart';
import '../services/Navigation.dart';
import '../services/Preferences.dart';
import '../services/http.dart';
import '../widgets/custom_widgets/custom_widget.dart';
import 'main_page.dart';

class add_link extends StatefulWidget {
  const add_link({Key? key}) : super(key: key);

  @override
  State<add_link> createState() => _add_linkState();
}

class _add_linkState extends State<add_link> {
  String? result;
  bool scanned = false;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.Primary,
      body: Column(
        children: <Widget>[
          Expanded(flex: 7, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(8),
                    child: ButtonWidget(
                      icon: Icons.arrow_back,
                      title: "Return.",
                      func: () async {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    child: ButtonWidget(
                      icon: Icons.camera,
                      title: "Start Camera",
                      func: () async {
                        await controller?.resumeCamera();
                      },
                    ),
                  )
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
    print(scanned);
    if (mounted) {
      setState(() {
        this.controller = controller;
      });
    }
    controller.scannedDataStream.listen((scanData) async {
      if (scanned == false) {
        scanned = true;
        dynamic accId = await Preferences.getPref('accId');
        String message = "${scanData.code}@@@$accId";
        dynamic msg = scanData.code?.split("@@@");
        print(msg);
        dynamic payLoad = {
          "secret": msg[0],
          "email": msg[1],
          "websiteId": msg[2],
          "accountId": accId
        };
        dynamic response = await Http.post("/link", payLoad);
        try {
          if (response['status'] == 'ok' && mounted) {
            snackBar("Account linked.", context);
            Navigator.pop(context);
          } else if (mounted) {
            snackBar(response['error'], context);
            Navigator.pop(context);
          }
        } catch (err) {
          print(err);
        }
      }
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

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
