import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:swar_ai/constants/constants.dart';
import 'package:swar_ai/constants/utils.dart';
import 'package:swar_ai/screens/apirequest.dart';
import 'package:swar_ai/screens/dashboard.dart';
import 'package:swar_ai/screens/verifyotp.dart';

class CreateProfile extends StatefulWidget {

  final int user_id;
  const CreateProfile({Key? key, required this.user_id}) : super(key: key);

  @override
  _CreateProfileState createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _cpassController = TextEditingController();


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
    final url = apiUrl + completeProfile;
    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json"
    };
    final body = {
      "email": _emailController?.text?.toString(),
      "password": _passController?.text?.toString(),
      "confirm_password": _cpassController?.text?.toString(),
      "user_id": this.widget.user_id
    };

    if(_passController?.text?.toString() != _cpassController?.text?.toString()) {
      showToast("Password do not match");
    }

    final response = await apiService.postRequest(url, body, headers);
    print(await response.body);
    if (response.statusCode == 200) {
      // var res = json.decode(response.body);
      Map<String, dynamic> map = json.decode(response.body);
      showToast("Profile Created");

      setStringLocal("access", map['access_token']);
      setStringLocal("refresh", map['refresh_token']);

      // Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardScreen()));

      Navigator.pop(context);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => DashboardScreen()), (route) => false);

    } else {
      Navigator.pop(context);
      print('Failed to create user');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Create Profile'),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[

                SizedBox(height: 40.0),

                Text("Complete Profile", style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),),

                SizedBox(height: 60.0),

            Card(
              color: Colors.white,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child:
              TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
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
                      showToast('Please enter your email id');
                      return 'Please enter your email id';
                    }
                    return null;
                  },
                ),
            ),
                SizedBox(height: 16.0),

            Card(
              color: Colors.white,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child:
                TextFormField(
                  controller: _passController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
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
                      showToast('Please enter your password');
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),),
                SizedBox(height: 16.0),

            Card(
              color: Colors.white,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child:
                TextFormField(
                  controller: _cpassController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    filled: true,
                    fillColor:
                    Colors.white, // set the background color to grey
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
                      showToast('Please enter your confirmed password');
                      return 'Please enter your confirmed password';
                    }
                    return null;
                  },
                ),),

                SizedBox(height: 16.0),

                Align(
                  alignment: Alignment.centerRight, // align the widget to the right
                  child: SizedBox(
                    width: 200.0,
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
                            Text('Complete Profile', style: TextStyle(color: Colors.white)),
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



              ],
            ),
          ),
        ),
      ),
    );
  }
}
