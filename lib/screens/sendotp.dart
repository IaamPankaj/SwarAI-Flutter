import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:swar_ai/constants/constants.dart';
import 'package:swar_ai/constants/utils.dart';
import 'package:swar_ai/screens/apirequest.dart';
import 'package:swar_ai/screens/dashboard.dart';
import 'package:swar_ai/screens/verifyotp.dart';

class SendOTP extends StatefulWidget {
  @override
  _SendOTPState createState() => _SendOTPState();
}

class _SendOTPState extends State<SendOTP> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();


  AlertDialog alert = AlertDialog(
    content: Row(children: [
      CircularProgressIndicator(
        backgroundColor: Colors.red,
      ),
      Container(margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
    ]),
  );


  apicall() async {

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );

    ApiService apiService = ApiService();
    final url = apiUrl + sendOTP;
    final headers = {"Content-Type": "application/json", "Accept": "application/json"};
    final body = {"phone": _phoneController?.text?.toString()};

    final response = await apiService.postRequest(url, body, headers);
    print(await response.body);
    if (response.statusCode == 200) {
      // var res = json.decode(response.body);
      Map<String, dynamic> map = json.decode(response.body);
      showToast(map['message']);

      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyOTP(phone: _phoneController.text.toString())));

    } else {
      print('Failed to create user');
      Navigator.pop(context);
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Register'),
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[

              // SizedBox(height: 20.0),
              // Center(
              //   child:
              //   Image.asset(
              //     'assets/images/logo.png',
              //   ),
              // ),
              //
              // SizedBox(height: 30.0),

              SizedBox(height: 40.0),

              Text("Register", style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),),


              SizedBox(height: 60.0),

              Card(

                  color: Colors.white,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                child: TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Mobile No',
                    filled: true,

                    fillColor: Colors.white, // set the background color to grey
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    labelStyle: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500//// set the font style to italic
                    ),
                  ),
                  // decoration: InputDecoration(
                  //   labelText: 'Email',
                  // ),
                  validator: (value) {
                    if (value == "") {
                      return 'Please enter your mobile number';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 16.0),

              Align(
                alignment: Alignment.centerRight, // align the widget to the right
                child: SizedBox(
                  width: 150.0,
                  height: 40,// set the width of the widget to 100 pixels
                  child:
                  Container(
                    width: double.infinity, // set the width of the container to the maximum available width
                    decoration: BoxDecoration(
                      color: Color(0xff2096f3), // set the background color of the container
                      borderRadius: BorderRadius.circular(20.0), // set the border radius of the container
                    ),
                    child: OutlinedButton(
                      onPressed: () {
                        apicall();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Send OTP  ', style: TextStyle(color: Colors.white)),
                          Icon(Icons.arrow_forward, color: Colors.white), // add the arrow icon next to the text
                        ],
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide.none, // remove the border from the button style
                      ),
                    ),
                  )
                  ,
                ),
              ),

              Spacer(),

              GestureDetector(
                  onTap: () {
                    // Perform your action here
                    Navigator.pop(context);
                  },
                  child: Center(child: Text('Already have an account? Click here'))),


              // OutlinedButton(
              //   onPressed: () {
              //     apicall();
              //   },
              //   child: Padding(
              //     padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              //     child: Text('Send OTP'),
              //   ),
              //
              //   style: OutlinedButton.styleFrom(
              //     side: BorderSide(width: 2.0, color: Colors.red),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}