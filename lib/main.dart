import 'package:flutter/material.dart';
import 'package:pickup/Screen/home.dart';
import 'package:pickup/Screen/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screen/register.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var id = prefs.getString('UID');
  var name = prefs.getString('UNAME');
  var phone = prefs.getString('UPHONE');
  runApp(
    MyApp(),
  );
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: <String, WidgetBuilder> {
        '/home' : (BuildContext context) => Home(),
        '/signup' : (BuildContext context) => SignUp(),
      },

      home: SignIn(),
    );
  }
}