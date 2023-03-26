import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../config/config.dart';
import '../../services/AccessCodeGeneration.dart';
import '../../services/Authentication.dart';
import '../../services/Preferences.dart';
import '../../services/http.dart';
import '../../widgets/custom_widgets/custom_widget.dart';
import '../../widgets/page_widget.dart';

class account_settings extends StatefulWidget {
  @override
  State<account_settings> createState() => _account_settingsState();
}

class _account_settingsState extends State<account_settings> {
  late Timer _timer;
  String accId = "STRING";
  String accQR = "STRING";
  bool isLocked = true;

  Future<void> lock() async {
    dynamic response =
        await Http.post('/lock', {"lock": "true", "accountId": accId});
    isLocked = true;
    // print(response);
  }

  Future<void> unlock() async {
    dynamic response =
        await Http.post('/lock', {"lock": "false", "accountId": accId});
    isLocked = false;
    // print(response);
  }

  Future<void> retrieve() async {
    dynamic aid = await Preferences.getPref('accId');
    dynamic aqr = await Preferences.getPref('accQR');

    setState(() {
      if (aid != 'null' && aqr != 'null') {
        accId = aid;
        accQR = aqr;
        lock();
      }
    });

    _timer = Timer.periodic(new Duration(seconds: 3), (timer) async {
      if (accQR != 'null') {
        dynamic response =
            await Http.post('/validate', {"accountId": accId, "qrcode": accQR});
        if (response['action'] == 'logout') {
          // dispose();
          Authentication.Logout(context);
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (_) => login_page()));
        }
      }
    });
  }

  @override
  void initState() {
    retrieve();
    super.initState();
  }

  Widget build(BuildContext context) {
    return ScaffoldWidget(
      context: context,
      toSettings: false,
      content: Container(
        padding: EdgeInsets.all(20),
        color: ThemeColor.Secondary,
        width: double.infinity,
        height: MediaQuery.of(context).size.height / 1.5,
        child: Column(
          children: [
            TextWidget(
              "Account Details",
              isBold: true,
              size: 30,
            ),
            SizedBox(height: 30),
            Center(
              child: TextWidget("Your EasyAccess ID: ${accId}", isBold: true),
            ),
            Divider(
              color: ThemeColor.Text,
            ),
            TextWidget("QR Code:"),
            accQR == 'null'
                ? Text("No QR Code.")
                : QrImage(
                    foregroundColor: ThemeColor.Text,
                    data: accQR,
                    size: 200,
                  ),
            Container(
              child: Column(
                children: [
                  isLocked
                      ? TextWidget("Your account is currently LOCKED")
                      : TextWidget("Your account is currently UNLOCKED"),
                  LockButton(),
                  LogOutButton()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget LogOutButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: ThemeColor.Primary,
        fixedSize: const Size(150, 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: () async {
        Authentication.Logout(context);
      },
      child: TextWidget("Logout."),
    );
  }

  // Button
  Widget LockButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: ThemeColor.Primary,
        fixedSize: const Size(150, 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: () async {
        isLocked ? await unlock() : await lock();
        setState(() {});
      },
      child: isLocked ? Locked() : Unlocked(),
    );
  }

  Widget Unlocked() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextWidget("Lock", isBold: true),
        SizedBox(width: 3),
        Icon(Icons.lock_outlined),
      ],
    );
  }

  Widget Locked() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextWidget("Unlock", isBold: true),
        SizedBox(width: 3),
        Icon(Icons.lock_open_outlined),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel(); //cancel the timer here
  }
}
