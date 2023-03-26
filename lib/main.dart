import 'package:authenticator/pages/login_page.dart';
import 'package:authenticator/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'config/config.dart';
import 'services/Authentication.dart';
import 'services/BiometricAuthentication.dart';
import 'services/Navigation.dart';
import 'widgets/custom_widgets/custom_widget.dart';
import 'widgets/page_widget.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Widget nextPage;

  await Authentication.IsLoggedIn()
      ? nextPage = auth()
      : nextPage = login_page();

  runApp(
    // MaterialApp(theme: ThemeData(), home: nextPage),
    MaterialApp(theme: ThemeData(), home: main_page()),
  );
}

class auth extends StatefulWidget {
  const auth({Key? key}) : super(key: key);

  @override
  State<auth> createState() => _authState();
}

class _authState extends State<auth> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      settingsButton: false,
      context: context,
      content: Container(
        child: GestureDetector(
          onTap: () async {
            await Authentication.IsLoggedIn();
            await Biometrics.AvailableBiometrics();

            bool isDone = await Biometrics.Authenticate();
            print(isDone);
            if (isDone) Navigate.To(context, main_page());
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.fingerprint,
                  color: ThemeColor.Text,
                  size: 200,
                ),
                TextWidget("Click to Authenticate", size: 20)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
