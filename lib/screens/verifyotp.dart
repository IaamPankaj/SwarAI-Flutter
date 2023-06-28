import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:swar_ai/constants/constants.dart';
import 'package:swar_ai/constants/utils.dart';
import 'package:swar_ai/screens/apirequest.dart';
import 'package:swar_ai/screens/createprofile.dart';
import 'package:swar_ai/screens/dashboard.dart';

class VerifyOTP extends StatefulWidget {
  final String phone;
  const VerifyOTP({Key? key, required this.phone}) : super(key: key);

  @override
  _VerifyOTPState createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {

  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

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
    final url = apiUrl + phoneVerify;
    final headers = {"Content-Type": "application/json", "Accept": "application/json"};
    final body = {"phone": this.widget.phone, "otp":_otpController?.text?.toString()};

    final response = await apiService.postRequest(url, body, headers);
    print(await response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      print(map);
      showToast('OTP Verified');

      Navigator.pop(context);

      if(map['message'] != null) {
        setStringLocal("user_id", map['user_id'].toString());
        Navigator.push(context, MaterialPageRoute(builder: (context) => CreateProfile(user_id: map['user_id'])));
      } else {
        setStringLocal("access", map['access_token']);
        setStringLocal("refresh", map['refresh_token']);
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => DashboardScreen()), (route) => false);
        // Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
      }


      // Navigator.push(context, MaterialPageRoute(builder: (context) => CreateProfile(user_id: map['user_id'])));

    } else {
      Navigator.pop(context);
      showToast('Invalid OTP');
      print('Failed to create user');
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Verify OTP'),
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[


              SizedBox(height: 40.0),

              Text("Verify OTP", style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),),

              SizedBox(height: 60.0),

              Card(
                color: Colors.white,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextFormField(
                  controller: _otpController,
                  decoration: InputDecoration(
                    labelText: 'OTP',
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
                      return 'Please enter your OTP';
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
                          Text('Verify OTP  ', style: TextStyle(color: Colors.white)),
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

              // OutlinedButton(
              //   onPressed: () {
              //     apicall();
              //   },
              //   child: Padding(
              //     padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              //     child: Text('Verify OTP'),
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