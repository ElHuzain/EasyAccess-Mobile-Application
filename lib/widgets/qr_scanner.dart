import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../pages/main_page.dart';
import '../services/Navigation.dart';
import '../services/Preferences.dart';
import '../services/http.dart';
import 'custom_widgets/custom_widget.dart';
import 'page_widget.dart';

class scanner extends StatefulWidget {
  Widget nextPage;

  scanner({required this.nextPage, required BuildContext context});

  @override
  State<scanner> createState() => _scannerState();
}

class _scannerState extends State<scanner> {
  String? result;
  bool scanned = false;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    Text(result!)
                  else
                    TextWidget('Scan a code'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                          child: const Text('Return',
                              style: TextStyle(fontSize: 20)),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.resumeCamera();
                          },
                          child: const Text('resume',
                              style: TextStyle(fontSize: 20)),
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
    if (scanned == false && mounted) {
      print("Req");
      scanned = true;
      if (mounted) {
        setState(() {
          this.controller = controller;
        });
      }
      controller.scannedDataStream.listen((scanData) async {
        if (scanned == true && mounted) {
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
              return Navigate.To(context, widget.nextPage);
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
