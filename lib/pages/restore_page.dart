// ignore_for_file: unused_element
import 'package:authenticator/pages/qr_scan.dart';
import 'package:flutter/material.dart';
import '../config/config.dart';
import '../services/AccessCodeGeneration.dart';
import '../services/Authentication.dart';
import '../services/Preferences.dart';
import '../services/http.dart';
import '../widgets/custom_widgets/custom_widget.dart';
import '../widgets/page_widget.dart';

class restore_page extends StatefulWidget {
  bool pin = false;
  dynamic Account;
  restore_page({this.pin = false, this.Account = ""});

  @override
  State<restore_page> createState() => _restore_pageState();
}

class _restore_pageState extends State<restore_page> {
  Widget chosenwidget = recoverywidget();
  String secret = "";

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      context: context,
      content: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Logo(1.5),
            SizedBox(height: 15),
            TextWidget(
              "Account Recovery",
              isBold: true,
              size: 20,
            ),
            SizedBox(height: 15),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: ThemeColor.Secondary,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.all(20),
              child: widget.pin ? pinwidget() : recoverywidget(),
            ),
          ],
        ),
      ),
    );
  }
}

class pinwidget extends StatefulWidget {
  const pinwidget({Key? key}) : super(key: key);

  @override
  State<pinwidget> createState() => _pinwidgetState();
}

class _pinwidgetState extends State<pinwidget> {
  String pin = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextWidget(
          "Account found!",
          isBold: true,
          size: 20,
        ),
        SizedBox(height: 15),
        TextWidget(
            "Your account was found. Please insert PIN number to verify ownership."),
        TextField(
            onChanged: (value) {
              setState(() {
                pin = value;
              });
            },
            style: TextStyle(color: ThemeColor.Text)),
        SizedBox(height: 15),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: ThemeColor.Primary,
              fixedSize: const Size(500, 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              dynamic accId = await Preferences.getPref('pendingId');
              dynamic response =
                  await Http.post('/checkpin', {"pin": pin, "accountId": accId});
              if (response['status'] == 'authenticate') {
                await Authentication.Login(document: response['acc'], context: context);
              } else
                print("Fuck you.");
            },
            child: TextWidget("Submit", isBold: true))
      ],
    );
  }
}

class recoverywidget extends StatelessWidget {
  const recoverywidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextWidget("Scan QR Code to find your account"),
        SizedBox(height: 15),
        TextWidget(
          "Tip: If your have access to your account, do the following:",
          isBold: true,
        ),
        SizedBox(height: 5),
        TextWidget(
            "1- Go to Account Settings\n2- Click \"Unlock\" for faster recivery"),
        SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: ThemeColor.Primary,
            fixedSize: const Size(500, 1),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => qr_scan(),
              ),
            );
          },
          child: Row(
            children: [
              Spacer(),
              TextWidget("Open QR Scanner"),
              SizedBox(width: 5),
              Icon(Icons.qr_code),
              Spacer()
            ],
          ),
        )
      ],
    );
  }
}
