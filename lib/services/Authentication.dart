// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import '../pages/login_page.dart';
import '../pages/main_page.dart';
import '../pages/qr_page.dart';
import 'Navigation.dart';
import 'Preferences.dart';

class Authentication {
  static Future<void> Login({
    required dynamic document,
    required BuildContext context,
    isNewAccount = false,
  }) async {
    // setprefs
    Preferences.setPref('accId', document['id']);
    Preferences.setPref('accQR', document['qrcode']);

    // send to main_page()
    if (isNewAccount)
      Navigate.To(
        context,
        qr_page(
          text: "Account Created!",
          qr: document['qrcode'],
        ),
      );
    else
      Navigate.To(context, main_page());
  }

  // Is an account logged in?
  static Future<bool> IsLoggedIn() async {
    dynamic Account = await Preferences.getPref('accId');
    if (Account == 'null')
      return false;
    else
      return true;
  }

  // Logout of current account
  static Future<void> Logout(BuildContext context) async {
    await Preferences.removePref('accId');
    await Preferences.removePref('myAccs');
    await Preferences.removePref('accQR');

    Navigate.To(context, login_page());
  }
}
