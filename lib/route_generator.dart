import 'package:authenticator/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:authenticator/main.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const login_page());
      case '/register':
        return MaterialPageRoute(builder: (_) => const login_page());
      case '/main':
        return MaterialPageRoute(builder: (_) => const login_page());
      case '/recover':
        return MaterialPageRoute(builder: (_) => const login_page());
      default:
        return MaterialPageRoute(builder: (_) => const errorRoute());
    }
  }
}

class errorRoute extends StatelessWidget {
  const errorRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: const Scaffold(
        body: Text("Unmet Conditinos of rutered switches. Not found."),
      ),
    );
  }
}
