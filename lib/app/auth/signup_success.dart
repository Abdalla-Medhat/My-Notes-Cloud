import 'package:flutter/material.dart';

class SignupSuccess extends StatefulWidget {
  const SignupSuccess({super.key});

  @override
  State<SignupSuccess> createState() => _SignupSuccessState();
}

class _SignupSuccessState extends State<SignupSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "Signup Success",
              style: TextStyle(fontSize: 30, color: Colors.green),
            ),
          ),
          Center(
            child: Text(
              "You can login now...",
              style: TextStyle(fontSize: 30, color: Colors.green),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10.0),
            child: MaterialButton(
              elevation: 5,
              height: 50,
              minWidth: 170,
              color: Colors.pink,
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  "login",
                  (route) => false,
                );
              },
              child: const Text("Login"),
            ),
          ),
        ],
      ),
    );
  }
}
