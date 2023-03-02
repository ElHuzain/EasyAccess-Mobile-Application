import 'package:authenticator/pages/main_page.dart';
import 'package:authenticator/pages/settings/theme_settings.dart';
import 'package:flutter/material.dart';
import '../config/config.dart';
import '../widgets/custom_widgets/custom_widget.dart';
import '../widgets/page_widget.dart';
import 'settings/account_settings.dart';

class settings_page extends StatefulWidget {
  @override
  State<settings_page> createState() => _settings_pageState();
}

class _settings_pageState extends State<settings_page> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      context: context,
      toSettings: false,
      content: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              settingsWidget(
                  icon: Icons.settings,
                  settingsName: "Theme",
                  nextWidget: theme_settings()),
              const SizedBox(height: 15),
              settingsWidget(
                  icon: Icons.shield,
                  settingsName: "Account",
                  nextWidget: account_settings())
            ],
          ),
        ),
    );
  }
}

class settingsWidget extends StatelessWidget {
  String settingsName;
  Widget nextWidget;
  IconData icon;

  settingsWidget(
      {this.icon = Icons.home,
      this.settingsName = "Null",
      this.nextWidget = const main_page()});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => nextWidget));
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        decoration: BoxDecoration(
          color: ThemeColor.Secondary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            TextWidget(
              "$settingsName Settings",
              isBold: true,
              size: 30,
            ),
            const SizedBox(height: 15),
            Icon(
              icon,
              size: 50,
              color: ThemeColor.Text,
            )
          ],
        ),
      ),
    );
  }
}
