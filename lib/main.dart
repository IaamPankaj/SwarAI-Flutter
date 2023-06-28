import 'dart:async';

import 'package:flutter/material.dart';
import 'package:swar_ai/constants/utils.dart';
import 'package:swar_ai/screens/dashboard.dart';
import 'package:swar_ai/screens/login.dart';
import 'package:swar_ai/screens/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;



  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  // ignore: must_call_super
  initState()  {
    // ignore: avoid_print

    print("initState Called");
  }

  @override
  Widget build(BuildContext context) {

    Future.delayed(Duration(seconds: 5), () async {
      // Navigate to the new screen using the Navigator.push method
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardScreen()));

      if(await getStringLocal("access") != null ) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      }

      // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
    });




    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[


            Image.asset(
              'assets/images/logo.png',

            ),

            // Image.network(
            //   'https://picsum.photos/250?image=9',
            // )
          ],
        ),
      ),
       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
