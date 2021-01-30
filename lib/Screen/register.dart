import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

String _name;
String _address;
String _phone;
String _div;
String _passwd;

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  ///
  ///  Setting up http module
  ///

  final url = "https://ehaat.herokuapp.com/pickupmanapi/register";

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
          // backGroundImage(context),
          heading(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width - 30,
                  height: MediaQuery.of(context).size.height / 2 + 110,
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
                          nameField(),
                          SizedBox(
                            height: 30,
                          ),
                          addressField(),
 SizedBox(
                            height: 30,
                          ),
                          phoneField(),
                          SizedBox(
                            height: 30,
                          ),
                          divField(),
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
                            height: 30,
                          ),
                          MaterialButton(
                            onPressed: register,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                40,
                                10,
                                40,
                                10,
                              ),
                              child: Text(
                                'Register',
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
                        ],
                      ),
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

  Future<void> register() async {
    if (_formKey.currentState.validate()) {
      storeDb();
    }
  }

  Future<void> storeDb() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var res =
        await http.post(url, body: {'name': _name,'div': _div,'phone': _phone, 'password': _passwd, 'address': _address});
    if (res.statusCode == 200) {
      var jsRes = convert.jsonDecode(res.body);
        setState(() {
          prefs.setString('UID', jsRes['token']);
          prefs.setString('UNAME', jsRes['data']['name']);
          prefs.setString('UPHONE', _phone);
          if(prefs.get('UID') != null ||
          prefs.get('UPHONE') != null ||
          prefs.get('UNAME') != null          
          ) {
            print(prefs.get('UID'));
            Navigator.of(context).pushReplacementNamed('/home');
          } 
        });
      // } else {
      //   return 
      // }
    }
  }
}

Widget heading() {
  return Padding(
    padding: const EdgeInsets.only(left: 10.0, top: 25),
    child: Text(
      'Register...',
      style: TextStyle(
        color: Colors.black54,
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

Widget addressField() {
  return TextFormField(
    decoration: InputDecoration(
      labelText: 'Enter Your Address',
      labelStyle: TextStyle(
        fontSize: 20,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ),
    onChanged: (val) {
      _address = val;
    },
    onSaved: (val) {
      _address = val;
    },
    // ignore: missing_return
    validator: (val) {
      if (val.isEmpty) return 'Address is Required';
    },
  );
}

  Widget phoneField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Phone Number Here',
        labelStyle: TextStyle(
          fontSize: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      onChanged: (val) {
        _phone = val;
      },
      onSaved: (val) {
        _phone = val;
      },
      // ignore: missing_return
      validator: (val) {
        if (val.isEmpty) return 'Phone Number is Required';
      },
    );
  }

  Widget divField() {
  return TextFormField(
    decoration: InputDecoration(
      labelText: 'Division Here',
      labelStyle: TextStyle(
        fontSize: 20,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ),
    keyboardType: TextInputType.emailAddress,
    onChanged: (val) {
      _div = val;
    },
    onSaved: (val) {
      _div = val;
    },
    // ignore: missing_return
    validator: (val) {
      if (val.isEmpty) return 'Division is Required';
    },
  );
}
