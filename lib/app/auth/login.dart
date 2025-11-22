import 'package:api_php_mysql_training/app/component/crud.dart';
import 'package:api_php_mysql_training/constant/api_links.dart';
import 'package:api_php_mysql_training/main.dart';
import 'package:flutter/material.dart';
import 'package:api_php_mysql_training/app/component/costomTextform.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  String userNameHint = "email";
  String emailHint = "email";
  String passwordHint = "password";
  bool isloding = false;
  Future login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isloding = true;
      });
      Crud crud = Crud();
      Map data = {"email": email.text.trim(), "password": password.text.trim()};
      var response = await crud.postRequest(loginLink, data);
      if (!mounted) return;
      if (response["status"] == "success") {
        pref!.setString("id", response["data"]["id"].toString());
        pref!.setString("username", response["data"]["username"]);
        pref!.setString("email", response["data"]["email"]);
        pref!.setString("password", response["data"]["password"]);

        Navigator.pushNamedAndRemoveUntil(context, "home", (route) => false);
      } else {
        print("Error=============================>$response");
        setState(() {
          isloding = false;
        });
        email.clear();
        password.clear();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("something went wrong")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isloding
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Center(
                          child: Image.network(
                            "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fstatic.vecteezy.com%2Fsystem%2Fresources%2Fpreviews%2F013%2F869%2F686%2Foriginal%2Fblank-sticky-note-reminder-paper-png.png&f=1&nofb=1&ipt=58a377e6a355c281471915bd7d76a44a1a99046793f703e86905f651c22e7c08",
                            height: 150,
                            width: 150,
                          ),
                        ),
                        SizedBox(height: 50),
                        CustomTextForm(
                          controller: email,
                          hint: emailHint,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter an email";
                            } else {
                              return null;
                            }
                          },
                        ),
                        CustomTextForm(
                          controller: password,
                          hint: passwordHint,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a password";
                            } else {
                              return null;
                            }
                          },
                        ),
                        Container(
                          margin: EdgeInsets.all(12),
                          height: 50,
                          width: 150,
                          child: MaterialButton(
                            onPressed: () async {
                              await login();
                            },
                            textColor: Colors.white,
                            color: Colors.blueGrey,
                            child: Text("Login"),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, "signup");
                          },
                          child: Text(
                            "Signup",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
