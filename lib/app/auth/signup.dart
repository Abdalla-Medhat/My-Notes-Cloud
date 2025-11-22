import 'package:api_php_mysql_training/app/component/crud.dart';
import 'package:flutter/material.dart';
import 'package:api_php_mysql_training/app/component/costomTextform.dart';
import 'package:api_php_mysql_training/constant/api_links.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool isloding = false;
  Crud crud = Crud();
  signupAPI() async {
    setState(() {
      isloding = true;
    });
    Map data = {
      "username": userName.text.trim(),
      "email": email.text.trim(),
      "password": password.text.trim(),
    };
    var response = await crud.postRequest(signupLink, data);
    if (response["status"] == "success") {
      Navigator.pushNamedAndRemoveUntil(context, "s_success", (route) => false);
    } else {
      setState(() {
        isloding = false;
      });
      print("ooooooooooooooooooooooops");
    }
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController userName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  String userNameHint = "username";
  String emailHint = "email";
  String passwordHint = "password";
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter username";
                            } else {
                              return null;
                            }
                          },
                          controller: userName,
                          hint: userNameHint,
                        ),
                        CustomTextForm(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter an email";
                            } else {
                              return null;
                            }
                          },
                          controller: email,
                          hint: emailHint,
                        ),
                        CustomTextForm(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a password";
                            } else {
                              return null;
                            }
                          },
                          controller: password,
                          hint: passwordHint,
                        ),
                        Container(
                          margin: EdgeInsets.all(12),
                          height: 50,
                          width: 150,
                          child: MaterialButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                await signupAPI();
                              }
                            },
                            textColor: Colors.white,
                            color: Colors.blueGrey,
                            child: Text("Signup"),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text("Login"),
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
