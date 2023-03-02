import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../config/config.dart';
import '../widgets/custom_widgets/custom_widget.dart';
import '../widgets/page_widget.dart';
import 'main_page.dart';

class qr_page extends StatefulWidget {
  String text = "";
  String qr = "";
  bool comply = false;

  qr_page({this.text = "", this.qr = ""});

  @override
  State<qr_page> createState() => _qr_pageState();
}

class _qr_pageState extends State<qr_page> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      context: context,
      content: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        color: ThemeColor.Background,
        child: Column(
          children: [
            Logo(1.5),
            SizedBox(height: 20),
            TextWidget(
              widget.text,
              isBold: true,
              size: 30,
            ),
            SizedBox(height: 15),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: ThemeColor.Secondary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  TextWidget(
                      "Save this QR code as you will need it to recover the account."),
                  SizedBox(height: 15),
                  QrImage(
                    foregroundColor: ThemeColor.Text,
                    data: widget.qr,
                    size: 200,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: ThemeColor.Primary,
                          ),
                          onPressed: () {
                            setState(() {
                              widget.comply = true;
                            });
                          },
                          child: Text("I Saved QR Code.")),
                      SizedBox(
                        width: 15,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (widget.comply == true) {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (_) => main_page()));
                          } else
                            print("Angry face >:(");
                        },
                        style: ElevatedButton.styleFrom(
                          primary: widget.comply
                              ? ThemeColor.Primary
                              : ThemeColor.Background,
                        ),
                        child: Text("Proceed."),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
