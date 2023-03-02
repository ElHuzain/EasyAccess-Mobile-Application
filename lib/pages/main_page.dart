import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../config/config.dart';
import '../services/Navigation.dart';
import '../services/Preferences.dart';
import '../services/encrypt.dart';
import '../services/http.dart';
import '../widgets/custom_widgets/custom_widget.dart';
import '../widgets/page_widget.dart';
import 'add_link.dart';

class main_page extends StatefulWidget {
  const main_page({Key? key}) : super(key: key);

  @override
  State<main_page> createState() => _main_pageState();
}

class Object {
  String email;
  String key;
  String websiteName;

  Object(this.email, this.key, this.websiteName);
}

class _main_pageState extends State<main_page> {
  Timer? timer;
  String accId = "";
  List<dynamic> accs = [];
  QRViewController? controller;

  Future<void> prev() async {
    dynamic prefs = await Preferences.getPref('accId');
    dynamic prefs2 = await Preferences.getPref('myAccs');

    setState(() {
      accId = prefs;
      if (prefs2 != 'null') accs = jsonDecode(prefs2);
    });
  }

  Future<void> retrieve() async { 
    dynamic pref = await Preferences.getPref('accId');
    dynamic res = await Http.get('/link?id=$pref');
    await Preferences.setPref('myAccs', jsonEncode(res['links']));

    setState(() {
      accs = res['links'];
    });
  }

  @override
  void initState() {
    super.initState();
    timer =
        Timer.periodic(Duration(seconds: 15), (Timer t) => {setState(() {})});
  }

  Widget build(BuildContext context) {
    if (accId == "") {
      prev();
      retrieve();
    }
    return SafeArea(
      child: ScaffoldWidget(
        floating: true,
        Floaty: Floaty(),
        context: context,
        content: Container(
          color: ThemeColor.Background,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 15),
              TextWidget("Your Access ID:", size: 16, isBold: true),
              const SizedBox(height: 5),
              Container(
                decoration: BoxDecoration(
                    color: ThemeColor.Primary,
                    borderRadius: BorderRadius.circular(10),
                    // ignore: prefer_const_literals_to_create_immutables
                    boxShadow: [
                      const BoxShadow(color: Colors.black, blurRadius: 5)
                    ]),
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWidget(accId.length == 0 ? "Loading.." : accId,
                        size: 17, isBold: true),
                    SizedBox(width: 10),
                    Icon(Icons.copy, color: ThemeColor.Text),
                  ],
                ),
              ),
              Divider(
                color: ThemeColor.Text,
                thickness: 2.5,
                height: 25,
              ),
              Expanded(
                child: accs.isEmpty
                    ? Center(
                        child: TextWidget(
                            "Your linked accounts will appear here."))
                    : ListView.separated(
                        itemCount: accs.length,
                        separatorBuilder: (context, index) {
                          return const Text("");
                        },
                        itemBuilder: (context, index) {
                          dynamic Account = accs[index];
                          String accessCode = encrypt(Account['key']);
                          return listItem(
                            title: Account['websiteName'],
                            email: Account['email'],
                            accessCode: accessCode,
                            color: Colors.red,
                          );
                        },
                      ),
              ),
              // Stack(
              //   clipBehavior: Clip.none,
              //   children: [
              //     Container(
              //       height: 30,
              //       color: ThemeColor.Primary,
              //     ),
              //     Positioned(
              //       bottom: 11.0,
              //       right: MediaQuery.of(context).size.width / 2.5,
              //       child: Container(
              //         decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(50),
              //             color: ThemeColor.Primary),
              //         // width: double.infinity,
              //         child: GestureDetector(
              //           onTap: () async {
              //             await retrieve();
              //           },
              //           child: Container(
              //             decoration: BoxDecoration(
              //               // color: ThemeColor.Background,
              //               borderRadius: BorderRadius.circular(50),
              //             ),
              //             child: Icon(
              //               Icons.replay_outlined,
              //               size: 40,
              //               color: ThemeColor.Text,
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class Floaty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigate.To(context, add_link());
      },
      child: TextWidget("+", size: 35),
      backgroundColor: ThemeColor.Primary,
    );
  }
}

class listItem extends StatelessWidget {
  String title;
  String accessCode;
  String email;
  Color color;

  listItem(
      {Key? key,
      required this.accessCode,
      required this.email,
      required this.title,
      required this.color})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: const [BoxShadow(color: Colors.black, blurRadius: 7)],
          color: ThemeColor.Secondary,
          borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      height: 90,
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
            ),
            height: 500,
            width: 50,
            child: Icon(
              Icons.timelapse_outlined,
              size: 25,
              color: ThemeColor.Background,
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget("$title", isBold: true, size: 25),
                ],
              ),
              const Spacer(),
              Row(children: [
                TextWidget("ID: ", size: 15, isBold: true),
                TextWidget("$email", size: 15),
              ]),
              const Spacer(),
              Row(children: [
                TextWidget("Access Code: ", size: 15, isBold: true),
                TextWidget("$accessCode", size: 15),
              ]),
            ],
          ),
          const Spacer(flex: 2),
          const Icon(
            Icons.copy,
            size: 35,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
