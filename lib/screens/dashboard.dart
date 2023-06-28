import 'package:flutter/material.dart';
import 'package:swar_ai/components/AudioPlayerWidget.dart';
import 'package:swar_ai/constants/utils.dart';
import 'package:swar_ai/screens/anuvad.dart';
import 'package:swar_ai/screens/gender_classification.dart';
import 'package:swar_ai/screens/lekhswar.dart';
import 'package:swar_ai/screens/login.dart';
import 'package:swar_ai/screens/noise_cancellation.dart';
import 'package:swar_ai/screens/shrutlekh.dart';
import 'package:swar_ai/screens/speaker_recognition.dart';

// import 'package:swar_ai/components/AudioPlayerWidget.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Dashboard'),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[

            SizedBox(height: 25.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[

                GestureDetector(
                  onTap: () {
                    // Perform your action here
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ShrutLekh()));
                  },
                  child:buildCard('SHRUTLEKH'),
                ),
                GestureDetector(
                  onTap: () {
                    showToast("Coming Soon");
                    // Perform your action here
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => Anuvad()));
                  },
                  child:buildCard('ANUVAD - Coming Soon'),
                ),



              ],
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[

                GestureDetector(
                  onTap: () {
                    // Perform your action here
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LekhSwar()));
                  },
                  child:buildCard('LEKHSWAR'),
                ),
                GestureDetector(
                  onTap: () {
                    // Perform your action here
                    Navigator.push(context, MaterialPageRoute(builder: (context) => NoiseCan()));
                  },
                  child: buildCard('NOISE CANCELLATION'),
                ),

              ],
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[

                GestureDetector(
                  onTap: () {
                    // Perform your action here
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SpeakerRec()));
                  },
                  child:buildCard('SPEECH RECOGNITION'),
                ),
                GestureDetector(
                  onTap: () {
                    // Perform your action here
                    Navigator.push(context, MaterialPageRoute(builder: (context) => GenderCla()));
                  },
                  child: buildCard('GENDER CLASSIFICATION'),
                ),





              ],
            ),

            SizedBox(height: 50,),

            // AudioPlayerWidget(url: "https://www2.cs.uic.edu/~i101/SoundFiles/gettysburg10.wav");
      //   AudioPlayerWidget(
      //   url: 'https://example.com/audio.mp3',
      // ),

            // AudioPlayerWidgetCommon(url: "https://www2.cs.uic.edu/~i101/SoundFiles/gettysburg10.wav"),



              Align(
                alignment: Alignment.center, // align the widget to the right
                child: SizedBox(
                  width: 125.0,
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

                        removeStringLocal("user_id");
                        removeStringLocal("access");
                        removeStringLocal("refresh");

                        // Navigator.pushAndRemoveUntil(context, newRoute, (route) => false)

                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);


                        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CreateProfile(user_id: 10)));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Logout  ', style: TextStyle(color: Colors.white)),
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

              // Padding(
              //   padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              //   child: Text('LOGOUT'),
              // ),




          ],
        ),
      ),
    );
  }

  Widget buildCard(String title) {
    return Card(
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: SizedBox(
        height: 150.0,
        width: 150.0,
        child: Center(
          child: Text(title, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),),
        ),
      ),
    );
  }
}



