import 'package:authenticator/config/config.dart';
import 'package:authenticator/pages/login_page.dart';
import 'package:authenticator/pages/main_page.dart';
import 'package:authenticator/services/Preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'widgets/custom_widgets/custom_widget.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Widget firstPage = const main_page();
  String id = await Preferences.getPref('accId');
  // String id = "null";
  id == "null" ? firstPage = const login_page() : firstPage = mainApp();
  runApp(
    MaterialApp(
        theme: ThemeData(),
        // home: restore_page(),
        home: firstPage
        //This was first page!!!!!!!!!!!!!!!!!!!!!!1
        ),
  );
}

class mainApp extends StatefulWidget {
  @override
  State<mainApp> createState() => _mainAppState();
}

class _mainAppState extends State<mainApp> {
  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  bool? _canCheckBiometrics;
  List<BiometricType>? _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Let OS determine authentication method',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
      message == 'Authorized'
          ? Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => main_page()))
          : "";
    });
  }

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        backgroundColor: ThemeColor.Background,
        body: Container(
            padding: EdgeInsets.all(20),
            child: Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,
                color: ThemeColor.Secondary,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextWidget("Welcome back!"),
                    TextWidget("Tap anywhere to Authenticate")
                  ],
                ))),
      ),
      onTap: () {
        if (_isAuthenticating == false || _authorized != 'Authorized')
          _authenticate();
      },
    );
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}
