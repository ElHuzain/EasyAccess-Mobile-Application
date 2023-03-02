// ignore_for_file: must_be_immutable, non_constant_identifier_names
import 'package:flutter/material.dart';
import '../config/config.dart';
import '../pages/main_page.dart';
import '../pages/settings_page.dart';
import '../services/QRScanner.dart';
import 'custom_widgets/custom_widget.dart';

class ScaffoldWidget extends StatelessWidget {
  Widget content;
  BuildContext context;
  String title;
  bool toSettings;
  bool settingsButton;
  bool floating;
  Widget? Floaty;
  ScaffoldWidget(
      {required this.context,
      required this.content,
      this.settingsButton = true,
      this.title = "",
      this.Floaty,
      this.floating = false,
      this.toSettings = true});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton: floating ? Floaty : Container(),
        backgroundColor: ThemeColor.Background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Logo(8),
                SizedBox(width: 5),
                TextWidget(
                  "EasyAccess",
                  isBold: true,
                  size: 20,
                ),
              ],
            ),
          ),
          actions: [
            settingsButton
                ? Container(
                    padding: EdgeInsets.all(10),
                    child: GestureDetector(
                      onTap: () {
                        Widget nextPage;
                        toSettings
                            ? nextPage = settings_page()
                            : nextPage = main_page();

                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => nextPage));
                      },
                      child: Icon(
                        toSettings ? Icons.settings : Icons.home,
                        color: ThemeColor.Text,
                        size: 35,
                      ),
                    ),
                  )
                : Container()
          ],
          backgroundColor: ThemeColor.Background,
          elevation: 0,
        ),
        body: content,
      ),
    );
  }
}
