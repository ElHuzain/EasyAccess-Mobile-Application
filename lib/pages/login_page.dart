import 'package:authenticator/pages/main_page.dart';
import 'package:flutter/material.dart';
import '../config/config.dart';
import '../services/Authentication.dart';
import '../services/http.dart';
import '../widgets/custom_widgets/custom_widget.dart';
import '../widgets/page_widget.dart';
import 'restore_page.dart';

class login_page extends StatefulWidget {
  const login_page({Key? key}) : super(key: key);

  @override
  State<login_page> createState() => _login_pageState();
}

class _login_pageState extends State<login_page> {
  TextEditingController pinController = TextEditingController();
  TextStyle T = TextStyle(color: ThemeColor.Text);
  String res = "s";
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      settingsButton: false,
      context: context,
      content: Container(
        padding: EdgeInsets.all(20),
        width: double.infinity,
        color: ThemeColor.Background,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Logo(1.5),
            SizedBox(height: 15),
            TextWidget(
              "Welcome to EasyAccess!",
              isBold: true,
              size: 20,
            ),
            SizedBox(height: 2),
            TextWidget("The quickest way to get rid of password hassle!"),
            SizedBox(height: 10),
            TextWidget("You'll first need to create an account"),
            SizedBox(height: 20),
            GestureDetector(
              child: TextWidget("Or click here to retrieve an account"),
              onTap: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => restore_page()));
              },
            ),
            SizedBox(height: 20),
            // Spacer(),
            LoginContainer(),
            Spacer(flex: 2)
          ],
        ),
      ),
    );
  }

  Widget LoginContainer() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: ThemeColor.Secondary,
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          TextWidget("Enter a pin"),
          TextField(
            style: TextStyle(color: ThemeColor.Text),
            onChanged: (String v) {
              setState(() {
                res = v;
              });
            },
          ),
          SizedBox(height: 30),
          SubmitRegisterButton({"pin": res}, main_page())
        ],
      ),
    );
  }
}


class SubmitRegisterButton extends StatelessWidget {
  dynamic object;
  Widget nextPage;
  SubmitRegisterButton(this.object, this.nextPage, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: ThemeColor.Primary,
        fixedSize: const Size(500, 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: () async {
        print(object);
        dynamic response = await Http.post('/register', object);
        if (response['status'] == 'ok')
          Authentication.Login(
              document: response, context: context, isNewAccount: true);
        else {
          print("Error.");
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_box,
            color: ThemeColor.Text,
          ),
          const SizedBox(width: 10),
          TextWidget(
            "Submit",
            isBold: true,
          ),
        ],
      ),
    );
  }
}