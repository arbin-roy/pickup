import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}


String name;
String phone;
String id;
String prodName;
String prodQuantity;
String prodPrice;
String farmerPhone;
String div;

class _HomeState extends State<Home> {

  TextEditingController farmerphone = TextEditingController();
  TextEditingController prod_name = TextEditingController();
  TextEditingController prod_quantity = TextEditingController();
  TextEditingController prod_price = TextEditingController();
  TextEditingController div = TextEditingController();
  var url = "https://ehaat.herokuapp.com/pickupmanapi/pickOrder";
  Future fetchDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name =  prefs.get('UNAME');
      id =  prefs.get('UID');
      phone =  prefs.get('UPHONE');
    });

  }
  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      fetchDetails();
    }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(actions: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text('Welcome: $name', style: TextStyle(

            fontSize: 25,
          ),),
        ),
          CircleAvatar(
            child: IconButton(icon: Icon(Icons.supervised_user_circle, size: 38,),
            onPressed: (){
              showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Logout'),
                actions: [
                  TextButton(
                    onPressed: logout,
                    child: Text('Logout'),
                  ),
                ],
              );
            });
            },
            ),
          ),
        ],),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                   controller: farmerphone,
                    decoration: InputDecoration(
                      labelText: 'Enter Farmer Phone Number',
                      border: OutlineInputBorder(),
                    ),
                    ),
                    SizedBox(height: 30,),
                  TextFormField(
                    controller: prod_name,
                    decoration: InputDecoration(
                      labelText: 'Enter Product Name',               
                      border: OutlineInputBorder(),
                    ),
                    ),
                    SizedBox(height: 30,),
                  TextFormField(
                    controller: prod_price,
                    decoration: InputDecoration(
                      
                      labelText: 'Enter Product Price per kg',              
                       border: OutlineInputBorder(),
                    ),
                    ),
                    SizedBox(height: 30,),
                  TextFormField(
                    controller: prod_quantity,
                    decoration: InputDecoration(
                      labelText: 'Enter Product Quantity',             
                        border: OutlineInputBorder(),
                    ),
                    ),
                    SizedBox(height: 30,),
                  TextFormField(
                    controller: div,
                    decoration: InputDecoration(
                      labelText: 'Enter Division',              
                       border: OutlineInputBorder(),
                    ),
                    ),
                    SizedBox(height: 30,),

                    MaterialButton(
                              onPressed: addProd,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  40,
                                  10,
                                  40,
                                  10,
                                ),
                                child: Text(
                                  'Add Product',
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
      );
  }

   Future<void> addProd() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var res =
        await http.post(url, body: {'farmerPhoneNum': phone,'div': div, 'pickmanId': id, 'product_name': prodName, 'product_quantity': prodQuantity ,'product_price': prodPrice},
        headers: {
          'authorization': id,
        }
        );
    if (res.statusCode == 200) {
      var jsRes = convert.jsonDecode(res.body);
        setState(() {
         showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Message'),
                content: Text(
                  jsRes['message']
                    ),
                actions: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                                              farmerphone.clear();
                                              prod_name.clear();
                                              prod_quantity.clear();
                                              prod_price.clear();
                                              div.clear();
                                            });
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            });
        });
    }
  }

  Future logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = null;
       prefs.remove('UID');
      if(prefs.get('UID') == null) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
        });
      }
}