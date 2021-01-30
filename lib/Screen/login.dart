import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

String _name;
String _phone;
String _passwd;

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  ///
  ///  Setting up http module
  ///

  final url = "https://ehaat.herokuapp.com/pickupmanapi/login";

  final _formKey = GlobalKey<FormState>();
  static var counter = 1;
  bool obscure = true;
  bool obscureCount() {
    counter++;
    return counter % 2 != 0 ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          heading(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 30,
                height: MediaQuery.of(context).size.height / 2 + 120,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        emailField(),
                        SizedBox(
                          height: 30,
                        ),
                        /**
                         * Password Field
                         */
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              fontSize: 20,
                            ),
                            suffixIcon: IconButton(
                              icon: counter % 2 == 0
                                  ? Icon(Icons.panorama_fish_eye_outlined)
                                  : Icon(Icons.circle),
                              onPressed: () {
                                setState(() {
                                  obscure = obscureCount();
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          obscureText: obscure,
                          obscuringCharacter: '*',
                          keyboardType: TextInputType.visiblePassword,
                          onChanged: (val) {
                            _passwd = val;
                          },
                          onSaved: (val) {
                            _passwd = val;
                          },
                          // ignore: missing_return
                          validator: (val) {
                            if (val.isEmpty)
                              return 'Password is Required';
                            else if (val.length < 6)
                              return 'Password must be of length 6';
                          },
                        ), //Password Field Ends
                        SizedBox(
                          height: 80,
                        ),
                        MaterialButton(
                          onPressed: login,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                              40,
                              10,
                              40,
                              10,
                            ),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                              ),
                            ),
                          ),
                          color: Colors.greenAccent.withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          splashColor: Colors.yellowAccent.withOpacity(0.3),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Divider(),

                        Text("Don't have an account??"),
                        MaterialButton(
                          onPressed: (){
                            Navigator.of(context).pushReplacementNamed('/signup');
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                              40,
                              10,
                              40,
                              10,
                            ),
                            child: Text(
                              'New Account',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          color: Colors.greenAccent.withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          splashColor: Colors.yellowAccent.withOpacity(0.3),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> login() async {
    if (_formKey.currentState.validate()) {
      storeDb();
    }
  }

  Future<void> storeDb() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var res =
        await http.post(url, body: {'phone': _phone, 'password': _passwd});
        print(res.body);
    if (res.statusCode == 200) {
      var jsRes = convert.jsonDecode(res.body);
        setState(() {
          prefs.setString('UID', jsRes['token']);
          prefs.setString('UPHONE', jsRes['phone']);
          Navigator.of(context).pushReplacementNamed('/home');
        });
    
    }
  }
}

Widget heading() {
  return Padding(
    padding: const EdgeInsets.only(left: 10.0, top: 25),
    child: Text(
      'Sign In...',
      style: TextStyle(
        color: Colors.white,
        fontSize: 66,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget nameField() {
  return TextFormField(
    decoration: InputDecoration(
      labelText: 'Name',
      labelStyle: TextStyle(
        fontSize: 20,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ),
    onChanged: (val) {
      _name = val;
    },
    onSaved: (val) {
      _name = val;
    },
    // ignore: missing_return
    validator: (val) {
      if (val.isEmpty) return 'Name is Required';
    },
  );
}

Widget emailField() {
  return TextFormField(
    decoration: InputDecoration(
      labelText: 'Email Here',
      labelStyle: TextStyle(
        fontSize: 20,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ),
    keyboardType: TextInputType.phone,
    onChanged: (val) {
      _phone = val;
    },
    onSaved: (val) {
      _phone = val;
    },
    // ignore: missing_return
    validator: (val) {
      if (val.isEmpty) return 'Email is Required';
    },
  );
}
