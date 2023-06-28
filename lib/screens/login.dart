import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:swar_ai/components/WaveClipper.dart';
import 'package:swar_ai/constants/constants.dart';
import 'package:swar_ai/constants/utils.dart';
import 'package:swar_ai/screens/apirequest.dart';
import 'package:swar_ai/screens/createprofile.dart';
import 'package:swar_ai/screens/dashboard.dart';
import 'package:swar_ai/screens/sendotp.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();


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
    final url = apiUrl + login;
    final headers = {"Content-Type": "application/json", "Accept": "application/json"};
    final body = {"email": _emailController?.text?.toString(), "password":_passwordController?.text?.toString()};

    final response = await apiService.postRequest(url, body, headers);
    print(await response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      print(map);
      showToast('Login Successful');

      setStringLocal("user_id", map['user_id'].toString());
      setStringLocal("access", map['access_token']);
      setStringLocal("refresh", map['refresh_token']);
      Navigator.pop(context);
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardScreen()));


      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardScreen()));

    } else {
      showToast('Invalid Credential!');
      print('Failed to create user');
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Login'),
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

                Container(child: Text("Login", style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),)),  
                SizedBox(height: 10.0),
                Text("Please sign in to continue", style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black87),),

                SizedBox(height: 60.0),

                // SizedBox(height: 20.0),
                // Center(
                //   child:
                //   Image.asset(
                //     'assets/images/logo.png',
                //
                //   ),
                // ),
                //
                // SizedBox(height: 30.0),

                Card(
                  color: Colors.white,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextFormField(
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
                          fontWeight: FontWeight.w500// set the color// set the font style to italic
                      ),
                      hintStyle: TextStyle(
                        fontSize: 16.0, // set the font size
                        color: Colors.black45,
                        fontWeight: FontWeight.w900// set the color
                      ),
                    ),
                    validator: (value) {
                      if (value == "") {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                ),


                // TextFormField(
                //   controller: _emailController,
                //   decoration: InputDecoration(
                //     labelText: 'Email',
                //     filled: true,
                //     fillColor: Colors.grey[200], // set the background color to grey
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(0.0),
                //       borderSide: BorderSide.none,
                //     ),
                //   ),
                //   // decoration: InputDecoration(
                //   //   labelText: 'Email',
                //   // ),
                //   validator: (value) {
                //     if (value == "") {
                //       return 'Please enter your email';
                //     }
                //     return null;
                //   },
                // ),
                SizedBox(height: 16.0),
                Card(
                  color: Colors.white,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextFormField(
                    controller: _passwordController,
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
                    //   labelText: 'Password',
                    // ),
                    validator: (value) {
                      if (value == "") {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 16.0),

                Align(
                  alignment: Alignment.centerRight, // align the widget to the right
                  child: SizedBox(
                    width: 100.0,
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
                          //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CreateProfile(user_id: 10)));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Login  ', style: TextStyle(color: Colors.white)),
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

                SizedBox(height: 20),

                GestureDetector(
                    onTap: () {
                      // Perform your action here
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SendOTP()));

                    },
                    child: Center(child: Text('Don\'t have an account? Register Now'))),


                // OutlinedButton(
                //   onPressed: () {},
                //   child: Text('Button'),
                //   borde: BorderSide(color: Colors.red),
                // )
                // ElevatedButton(
                //   onPressed: () {
                //
                //     Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
                //     // if (_formKey.currentState!.validate()) {
                //     //   // TODO: Process login
                //     // }
                //   },
                //   child: Text('Login'),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}