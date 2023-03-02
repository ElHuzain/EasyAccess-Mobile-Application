import 'package:authenticator/config/config.dart';
import 'package:authenticator/pages/login_page.dart';
import 'package:authenticator/pages/main_page.dart';
import 'package:authenticator/services/Preferences.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'services/Authentication.dart';
import 'services/BiometricAuthentication.dart';
import 'services/Navigation.dart';
import 'services/QRScanner.dart';
import 'widgets/custom_widgets/custom_widget.dart';
import 'widgets/page_widget.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Widget nextPage;

  await Authentication.IsLoggedIn()
      ? nextPage = main_page()
      : nextPage = login_page();

  runApp(
    MaterialApp(theme: ThemeData(), home: nextPage),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  QRViewController? qrController;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return ScaffoldWidget(
      floating: true,
      context: context,
      content: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                print(await Authentication.IsLoggedIn());
                print(await Biometrics.AvailableBiometrics());

                // bool isDone = await Biometrics.Authenticate();
                // print(isDone);
                // if (isDone) Navigate.To(context, NextPage());
              },
              child: TextWidget("SMACK MEE"),
            ),
            // QRView(
            //   overlay: QrScannerOverlayShape(
            //     cutOutHeight: 10,
            //   ),
            //   key: qrKey,
            //   onQRViewCreated: QRScanner.Scan,
            // ),
            ElevatedButton(
              onPressed: () async {
                await Preferences.setPref('accId', '!');
              },
              child: TextWidget("Login"),
            ),
          ],
        ),
      ),
    );
  }
}

class NextPage extends StatefulWidget {
  const NextPage({Key? key}) : super(key: key);

  @override
  State<NextPage> createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  @override
  Widget build(BuildContext context) {
    return TextWidget("Next Widget!");
  }
}
