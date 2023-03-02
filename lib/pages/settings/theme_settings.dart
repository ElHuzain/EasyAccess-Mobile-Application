import 'package:flutter/material.dart';
import '../../config/config.dart';
import '../../widgets/custom_widgets/custom_widget.dart';
import '../../widgets/page_widget.dart';

class theme_settings extends StatefulWidget {
  const theme_settings({Key? key}) : super(key: key);

  @override
  State<theme_settings> createState() => _theme_settingsState();
}

class _theme_settingsState extends State<theme_settings> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      context: context,
      toSettings: false,
      content: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            themeWidget(),
            const SizedBox(height: 15),
            themeWidget(),
            const SizedBox(height: 15),
            themeWidget(),
          ],
        ),
      ),
    );
  }
}

class themeWidget extends StatelessWidget {
  String name;
  String color;

  themeWidget({this.name = "Null", this.color = "Null"});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeColor.Secondary,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          TextWidget("$name: $color"),
          Spacer(),
          Icon(
            Icons.check,
            color: ThemeColor.Text,
          ),
        ],
      ),
    );
  }
}
