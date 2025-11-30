import 'package:api_php_mysql_training/app/auth/signup.dart';
import 'package:api_php_mysql_training/app/auth/signup_success.dart';
import 'package:api_php_mysql_training/app/home.dart';
import 'package:api_php_mysql_training/app/notes/add.dart';
import 'package:flutter/material.dart';
import 'package:api_php_mysql_training/app/auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? pref;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  pref = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Note Cloud',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          elevation: 33,
          backgroundColor: Colors.pink,
          foregroundColor: Colors.white,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const Login(),
      initialRoute: pref!.getString("id") == null ? "login" : "home",
      routes: {
        "login": (context) => const Login(),
        "signup": (context) => const Signup(),
        "home": (context) => const Home(),
        "s_success": (context) => const SignupSuccess(),
        "add": (context) => const AddNote(),
      },
    );
  }
}
