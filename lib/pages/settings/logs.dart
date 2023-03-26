// ignore_for_file: non_constant_identifier_names, camel_case_types, must_be_immutable

import 'dart:async';
import 'dart:convert';

import 'package:authenticator/services/http.dart';
import 'package:flutter/material.dart';
import '../../config/config.dart';
import '../../services/Preferences.dart';
import '../../widgets/custom_widgets/custom_widget.dart';
import '../../widgets/page_widget.dart';

class logs_page extends StatefulWidget {
  const logs_page({Key? key}) : super(key: key);

  @override
  State<logs_page> createState() => _logs_pageState();
}

class _logs_pageState extends State<logs_page> {
  Timer? _timer;
  List<dynamic> data = [];

  @override
  void initState() {
    super.initState();
    // _timer = Timer.periodic(Duration(seconds: 2), (timer) {
    //   fetchData();
    // });
    fetchData();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<dynamic> fetchData() async {
    dynamic pref = await Preferences.getPref('accId');
    dynamic res = await Http.get('/link?id=$pref&logs=true');
    try {
      if (res != 'Null') {
        setState(() {
          data = res['logs'];
        });
      }
    } catch (err) {
      print(err);
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      floating: true,
      Floaty: FloatingActionButton(
        onPressed: () {
          setState(() {
            fetchData();
          });
        },
        child: Icon(
          Icons.replay_outlined,
          size: 40,
        ),
        backgroundColor: ThemeColor.Primary,
      ),
      context: context,
      toSettings: false,
      content: Container(
          padding: EdgeInsets.all(20),
          child: data.isEmpty
              ? Center(child: TextWidget("You currently have no logs."))
              : ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    print(data);
                    return themeWidget(
                      CurrentTime: data[index]['CurrentTime'],
                      CurrentDate: data[index]['CurrentDate'],
                      IPAddress: data[index]['IPAddress'],
                      Browser: data[index]['Browser'],
                      OperatingSystem: data[index]['OperatingSystem'],
                      Type: data[index]['type'],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 10,
                    );
                  },
                  itemCount: data.length)),
    );
  }
}

class themeWidget extends StatefulWidget {
  dynamic CurrentDate;
  dynamic CurrentTime;
  dynamic Type;
  dynamic IPAddress;
  dynamic OperatingSystem;
  dynamic Browser;
  bool Expanded = false;

  themeWidget(
      {this.CurrentDate = "Null",
      this.CurrentTime = "Null",
      this.Type = "Null",
      this.IPAddress = "Null",
      this.OperatingSystem = "Null",
      this.Browser = "Null"});
  // const themeWidget({Key? key}) : super(key: key);

  @override
  State<themeWidget> createState() => _themeWidgetState();
}

class _themeWidgetState extends State<themeWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: ThemeColor.Secondary,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: GestureDetector(
        onTap: () {
          setState(() {
            widget.Expanded ? widget.Expanded = false : widget.Expanded = true;
          });
        },
        child: Row(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            // Icon(
            //   Icons.warning,
            //   color: ThemeColor.Text,
            // ),
            // Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.warning,
                      color: widget.Type == "Successful"
                          ? Colors.red
                          : Colors.yellow,
                      size: 30,
                    ),
                    SizedBox(width: 15),
                    TextWidget(
                      widget.Type == "Successful"
                          ? "Successful Login Attempt"
                          : "Unsuccessful Login Attempt",
                      size: 18,
                      isBold: true,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                // TextWidget("", size: 15, wrap: false),
                if (widget.Expanded == true)
                  RowWidget(Icons.date_range, "Date: ", widget.CurrentDate),
                if (widget.Expanded == true)
                  RowWidget(Icons.punch_clock, "Time: ", widget.CurrentTime),
                if (widget.Expanded == true)
                  RowWidget(Icons.gps_fixed, "IP Address: ", widget.IPAddress),
                if (widget.Expanded == true)
                  RowWidget(Icons.window, "OS: ", widget.OperatingSystem),
                if (widget.Expanded == true)
                  RowWidget(Icons.laptop, "Browser: ", widget.Browser),
              ],
            ),
            Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}

class RowWidget extends StatelessWidget {
  String Key;
  String Value;
  IconData icon;
  RowWidget(this.icon, this.Key, this.Value);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          this.icon,
          color: ThemeColor.Text,
        ),
        SizedBox(
          width: 10,
        ),
        TextWidget(
          this.Key,
          isBold: true,
        ),
        TextWidget(this.Value),
      ],
    );
  }
}
