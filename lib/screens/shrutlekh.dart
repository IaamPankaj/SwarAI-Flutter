import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:swar_ai/components/MicButton.dart';
import 'package:swar_ai/constants/constants.dart';
import 'package:swar_ai/constants/utils.dart';
import 'package:swar_ai/screens/AudioUploaderScreen.dart';
import 'package:swar_ai/screens/apirequest.dart';
import 'package:swar_ai/constants/constants.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class ShrutLekh extends StatefulWidget {
  @override
  _ShrutLekhState createState() => _ShrutLekhState();
}

class _ShrutLekhState extends State<ShrutLekh> {
  int _selectedIndex = 0;
  String dropdownValue = 'English';
  String selectedLanguage = "-";

  String output = 'Your output will be displayed here';

  String audio_file = '';

  // DropdownMenuItem<String>(
  // value: 'af',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/afrikaans.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Afrikaans'),
  // ],
  // ),
  // ),
  // DropdownMenuItem<String>(
  // value: 'ar',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/arabic.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Arabic'),
  // ],
  // ),
  // ),
  // DropdownMenuItem<String>(
  // value: 'bn',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/bengali.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Bengali/Bangla'),
  // ],
  // ),
  // ),
  // DropdownMenuItem<String>(
  // value: 'bg',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/bulgarian.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Bulgarian'),
  // ],
  // ),
  // ),
  // DropdownMenuItem<String>(
  // value: 'ca',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/catalan.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Catalan'),
  // ],
  // ),
  // ),
  // DropdownMenuItem<String>(
  // value: 'zh',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/chinese.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Chinese'),
  // ],
  // ),
  // ),
  // DropdownMenuItem<String>(
  // value: 'hr',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/croatian.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Croatian'),
  // ],
  // ),
  // ),
  // DropdownMenuItem<String>(
  // value: 'cs',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/czech.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Czech'),
  // ],
  // ),
  // ),
  // DropdownMenuItem<String>(
  // value: 'da',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/danish.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Danish'),
  // ],
  // ),
  // ),
  // DropdownMenuItem<String>(
  // value: 'nl',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/dutch.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Dutch'),
  // ],
  // ),
  // ),
  // DropdownMenuItem<String>(
  // value: 'en',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/english.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('English'),
  // ],
  // ),
  // ),
  //
  //
  //
  // DropdownMenuItem<String>(
  // value: 'et',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/estonia.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Estonian'),
  // ],
  // ),
  // ),
  //
  // DropdownMenuItem<String>(
  // value: 'fj',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/fiji.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Fijian'),
  // ],
  // ),
  // ),
  //
  // DropdownMenuItem<String>(
  // value: 'fi',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/finland.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Finnish'),
  // ],
  // ),
  // ),
  //
  // DropdownMenuItem<String>(
  // value: 'fr',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/france.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('French'),
  // ],
  // ),
  // ),
  //
  // DropdownMenuItem<String>(
  // value: 'de',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/germany.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('German'),
  // ],
  // ),
  // ),
  //
  // DropdownMenuItem<String>(
  // value: 'el',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/greece.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Greek'),
  // ],
  // ),
  // ),
  //
  //
  // DropdownMenuItem<String>(
  // value: 'gu',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/india.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Gujarati'),
  // ],
  // ),
  // ),
  // DropdownMenuItem<String>(
  // value: 'hi',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/india.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Hindi'),
  // ],
  // ),
  // ),
  // DropdownMenuItem<String>(
  // value: 'hu',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/hungary.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Hungarian'),
  // ],
  // ),
  // ),
  // DropdownMenuItem<String>(
  // value: 'is',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/iceland.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Icelandic'),
  // ],
  // ),
  // ),
  // DropdownMenuItem<String>(
  // value: 'ga',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/ireland.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Irish'),
  // ],
  // ),
  // ),
  // DropdownMenuItem<String>(
  // value: 'it',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/italy.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Italian'),
  // ],
  // ),
  // ),
  // DropdownMenuItem<String>(
  // value: 'ja',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/japan.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Japanese'),
  // ],
  // ),
  // ),
  // DropdownMenuItem<String>(
  // value: 'kn',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/india.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Kannada'),
  // ],
  // ),
  // ),
  //
  //
  // DropdownMenuItem<String>(
  // value: 'kk',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/kazakhstan.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Kazakh'),
  // ],
  // ),
  // ),
  // DropdownMenuItem<String>(
  // value: 'ko',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/south-korea.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Korean'),
  // ],
  // ),
  // ),
  // DropdownMenuItem<String>(
  // value: 'lv',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/latvia.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Latvian/Lettish'),
  // ],
  // ),
  // ),
  // DropdownMenuItem<String>(
  // value: 'lt',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/lithuania.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Lithuanian'),
  // ],
  // ),
  // ),
  // DropdownMenuItem<String>(
  // value: 'mg',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/madagascar.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Malagasy'),
  // ],
  // ),
  // ),
  //
  //
  // DropdownMenuItem<String>(
  // value: 'ms', // Malay
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/malay.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Malay (ms)'),
  // ],
  // ),
  // ),
  // DropdownMenuItem<String>(
  // value: 'ml', // Malayalam
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/malayalam.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Malayalam (ml)'),
  // ],
  // ),
  // ),
  // DropdownMenuItem<String>(
  // value: 'mt', // Maltese
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/maltese.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Maltese (mt)'),
  // ],
  // ),
  // ),
  // DropdownMenuItem<String>(
  // value: 'mi', // Maori
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/maori.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Maori (mi)'),
  // ],
  // ),
  // ),
  // DropdownMenuItem<String>(
  // value: 'mr', // Marathi
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/marathi.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Marathi (mr)'),
  // ],
  // ),
  // ),
  //
  // DropdownMenuItem<String>(
  // value: 'no',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/norway.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Norwegian'),
  // ],
  // ),
  // ),
  //
  // DropdownMenuItem<String>(
  // value: 'fa',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/iran.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Persian'),
  // ],
  // ),
  // ),
  //
  // DropdownMenuItem<String>(
  // value: 'pl',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/poland.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Polish'),
  // ],
  // ),
  // ),
  //
  // DropdownMenuItem<String>(
  // value: 'pt',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/portugal.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Portuguese'),
  // ],
  // ),
  // ),
  //
  // DropdownMenuItem<String>(
  // value: 'pa',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/india.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Punjabi'),
  // ],
  // ),
  // ),
  //
  //
  // DropdownMenuItem<String>(
  // value: 'ro',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/romania.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Romanian'),
  // ],
  // ),
  // ),
  // DropdownMenuItem<String>(
  // value: 'ru',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/russia.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Russian'),
  // ],
  // ),
  // ),
  // DropdownMenuItem<String>(
  // value: 'sm',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/samoa.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Samoan'),
  // ],
  // ),
  // ),
  // DropdownMenuItem<String>(
  // value: 'sr',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/serbia.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Serbian'),
  // ],
  // ),
  // ),
  // DropdownMenuItem<String>(
  // value: 'sk',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/slovakia.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Slovak'),
  // ],
  // ),
  // ),
  //
  // DropdownMenuItem<String>(
  // value: 'sl',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/slovenia.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Slovenian'),
  // ],
  // ),
  // ),
  // DropdownMenuItem<String>(
  // value: 'es',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/spain.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Spanish'),
  // ],
  // ),
  // ),
  // DropdownMenuItem<String>(
  // value: 'sw',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/tanzania.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Swahili'),
  // ],
  // ),
  // ),
  //
  // DropdownMenuItem<String>(
  // value: 'sv',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/sweden.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Swedish'),
  // ],
  // ),
  // ),
  //
  // DropdownMenuItem<String>(
  // value: 'ta',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/tamil.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Tamil'),
  // ],
  // ),
  // ),
  //
  // DropdownMenuItem<String>(
  // value: 'te',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/telugu.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Telugu'),
  // ],
  // ),
  // ),
  //
  // DropdownMenuItem<String>(
  // value: 'th',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/thai.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Thai'),
  // ],
  // ),
  // ),
  //
  // DropdownMenuItem<String>(
  // value: 'to',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/tonga.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Tonga'),
  // ],
  // ),
  // ),
  //
  // DropdownMenuItem<String>(
  // value: 'tr',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/turkey.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Turkish'),
  // ],
  // ),
  // ),
  //
  // DropdownMenuItem<String>(
  // value: 'uk',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/ukraine.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Ukrainian'),
  // ],
  // ),
  // ),
  //
  // DropdownMenuItem<String>(
  // value: 'ur',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/urdu.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Urdu'),
  // ],
  // ),
  // ),
  //
  // DropdownMenuItem<String>(
  // value: 'vi',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/vietnam.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Vietnamese'),
  // ],
  // ),
  // ),
  //
  // DropdownMenuItem<String>(
  // value: 'cy',
  // child: Row(
  // children: [
  // Image.asset(
  // 'assets/images/wales.png',
  // width: 24.0,
  // ),
  // SizedBox(width: 8.0),
  // Text('Welsh'),
  // ],
  // ),
  // ),

  AlertDialog alert = AlertDialog(
    content: Row(children: [
      CircularProgressIndicator(
        backgroundColor: Colors.red,
      ),
      Container(margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
    ]),
  );

  apicall(String _recordingFilePath) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
    try {
      final file = File(_recordingFilePath);
      // print('------------------------ ${file}');
      print("-------------");
      print(
          "_filePath_filePath_filePath_filePath ${await getStringLocal('access')}");

      ApiService apiService = ApiService();
      final url = apiUrl + shrutlekh;
      final headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer ${await getStringLocal('access')}",
      };
      final body = {"language": selectedLanguage};

      final response = await apiService.uploadFileWithParamsAndHeaders(
          url, _recordingFilePath, body, headers);

      print(
          "responseresponseresponseresponse ${response.statusCode} ${response.body}");
      if (response.statusCode == 200) {
        Map<String, dynamic> map = json.decode(response.body);
        setState(() {
          output = map['text'];
        });
      } else {
        var err = json.decode(response.body);
        Map<String, dynamic> map = json.decode(response.body);
        showToast(map['error']);
        // showToast(err[])
      }
      Navigator.pop(context);
    } catch (e) {
      print(e);
      Navigator.pop(context);
    }
  }

  void copyToClipboard(String text) {
    Fluttertoast.showToast(
        msg: "Text Copied",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blueAccent,
        textColor: Colors.white,
        fontSize: 14.0);

    Clipboard.setData(ClipboardData(text: text));
  }

  Future<void> _requestStoragePermission(BuildContext context) async {
    // Request storage permission from the user
    PermissionStatus status = await Permission.storage.request();

    // If the user grants permission, download the file
    if (status == PermissionStatus.granted) {
      _downloadFile(context);
    } else {
      // If the user denies permission, show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Storage permission denied')),
      );
    }
  }

  Future<void> _downloadFile(BuildContext context) async {
    // Get the device's Documents directory
    final directory = await getApplicationDocumentsDirectory();

    // Create the downloads directory if it doesn't already exist
    final downloadsDirectory = Directory('${directory.path}/downloads');
    if (!downloadsDirectory.existsSync()) {
      downloadsDirectory.createSync();
    }

    // Create the file with the current date and time as the filename
    final now = DateTime.now();
    final filename =
        'shrutlekh_${now.year}-${now.month}-${now.day}_${now.hour}-${now.minute}-${now.second}.txt';
    print('${downloadsDirectory.path}/$filename');
    final file = File('${downloadsDirectory.path}/$filename');

    // Write the text to the file
    await file.writeAsString(output);

    // Show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('File downloaded successfully')),
    );

    // // Get the device's Downloads directory
    // final directory = await getDownloadsDirectory();
    // print(directory);
    //
    // // Create the file with the current date and time as the filename
    // final now = DateTime.now();
    // final filename = 'shrutlekh_${now.year}-${now.month}-${now.day}_${now.hour}-${now.minute}-${now.second}.txt';
    // final file = File('${directory}/$filename');
    //
    // // Write the text to the file
    // await file.writeAsString(output);
    //
    // // Show a success message
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('File downloaded successfully')),
    // );
  }

  // void downloadText(String text) async {
  //
  //   print("1111111111111111 ${await requestStoragePermission(context)}");
  //   if(await requestStoragePermission(context) ) {
  //     print("2222222222222222");
  //     final directory = await getDownloadsDirectory();
  //     // file.writeAsString(text);
  //
  //     final now = DateTime.now();
  //     final filename = 'shrutlekh_${now.year}-${now.month}-${now.day}_${now.hour}-${now.minute}-${now.second}.txt';
  //     final file = File('${directory}/$filename');
  //
  //     // Write the text to the file
  //     await file.writeAsString(text);
  //
  //     Fluttertoast.showToast(
  //         msg: "File Downloaded",
  //         toastLength: Toast.LENGTH_LONG,
  //         gravity: ToastGravity.BOTTOM,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: Colors.blueAccent,
  //         textColor: Colors.white,
  //         fontSize: 14.0);
  //   }
  //   print("333333333333333");
  //
  //
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Shrutlekh'),
        elevation: 0.0,
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 8.0),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 200.0,

                // set the width of the widget to 100 pixels
                child: Card(
                  elevation: 10,
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(0xff2096f3), width: 2), //<-- SEE HERE
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(0xff2096f3), width: 2), //<-- SEE HERE
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    dropdownColor: Colors.white,
                    value: selectedLanguage,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24.0,
                    elevation: 16,
                    style: TextStyle(color: Colors.black, fontSize: 16.0),
                    // underline: Container(
                    //   height: 2,
                    //   color: Colors.blue,
                    // ),
                    onChanged: (newValue) {
                      setState(() {
                        selectedLanguage = newValue.toString();
                      });
                    },
                    items: [
                      DropdownMenuItem<String>(
                        value: '-',
                        child: Row(
                          children: [

                            SizedBox(width: 8.0),
                            Text('Select Language'),
                          ],
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'af',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/afrikaans.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Afrikaans'),
                          ],
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'ar',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/arabic.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Arabic'),
                          ],
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'bn',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/bengali.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Bengali/Bangla'),
                          ],
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'bg',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/bulgarian.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Bulgarian'),
                          ],
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'ca',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/catalan.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Catalan'),
                          ],
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'zh-CN',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/chinese.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Chinese'),
                          ],
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'hr',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/croatian.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Croatian'),
                          ],
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'cs',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/czech.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Czech'),
                          ],
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'da',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/danish.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Danish'),
                          ],
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'nl',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/dutch.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Dutch'),
                          ],
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'en',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/english.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('English'),
                          ],
                        ),
                      ),

                      DropdownMenuItem<String>(
                        value: 'et',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/estonia.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Estonian'),
                          ],
                        ),
                      ),

                      DropdownMenuItem<String>(
                        value: 'fj',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/fiji.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Fijian'),
                          ],
                        ),
                      ),

                      DropdownMenuItem<String>(
                        value: 'fi',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/finland.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Finnish'),
                          ],
                        ),
                      ),

                      DropdownMenuItem<String>(
                        value: 'fr',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/france.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('French'),
                          ],
                        ),
                      ),

                      DropdownMenuItem<String>(
                        value: 'de',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/germany.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('German'),
                          ],
                        ),
                      ),

                      DropdownMenuItem<String>(
                        value: 'el',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/greece.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Greek'),
                          ],
                        ),
                      ),

                      DropdownMenuItem<String>(
                        value: 'gu',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/india.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Gujarati'),
                          ],
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'hi',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/india.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Hindi'),
                          ],
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'hu',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/hungary.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Hungarian'),
                          ],
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'is',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/iceland.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Icelandic'),
                          ],
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'ga',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/ireland.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Irish'),
                          ],
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'it',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/italy.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Italian'),
                          ],
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'ja',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/japan.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Japanese'),
                          ],
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'kn',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/india.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Kannada'),
                          ],
                        ),
                      ),

                      DropdownMenuItem<String>(
                        value: 'kk',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/kazakhstan.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Kazakh'),
                          ],
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'ko',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/south-korea.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Korean'),
                          ],
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'lv',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/latvia.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Latvian/Lettish'),
                          ],
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'lt',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/lithuania.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Lithuanian'),
                          ],
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'mg',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/madagascar.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Malagasy'),
                          ],
                        ),
                      ),

                      DropdownMenuItem<String>(
                        value: 'ms', // Malay
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/malay_lang.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Malay (ms)'),
                          ],
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'ml', // Malayalam
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/india.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Malayalam (ml)'),
                          ],
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'mt', // Maltese
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/malay.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Maltese (mt)'),
                          ],
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'mi', // Maori
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/maori.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Maori (mi)'),
                          ],
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'mr', // Marathi
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/india.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Marathi (mr)'),
                          ],
                        ),
                      ),

                      DropdownMenuItem<String>(
                        value: 'no',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/norway.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Norwegian'),
                          ],
                        ),
                      ),

                      DropdownMenuItem<String>(
                        value: 'fa',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/iran.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Persian'),
                          ],
                        ),
                      ),

                      DropdownMenuItem<String>(
                        value: 'pl',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/poland.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Polish'),
                          ],
                        ),
                      ),

                      DropdownMenuItem<String>(
                        value: 'pt',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/portugal.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Portuguese'),
                          ],
                        ),
                      ),

                      DropdownMenuItem<String>(
                        value: 'pa',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/india.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Punjabi'),
                          ],
                        ),
                      ),

                      DropdownMenuItem<String>(
                        value: 'ro',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/romania.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Romanian'),
                          ],
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'ru',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/russian.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Russian'),
                          ],
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'sm',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/samoa.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Samoan'),
                          ],
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'sr',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/serbia.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Serbian'),
                          ],
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'sk',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/slovakia.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Slovak'),
                          ],
                        ),
                      ),

                      DropdownMenuItem<String>(
                        value: 'sl',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/slovenia.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Slovenian'),
                          ],
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'es',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/spain.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Spanish'),
                          ],
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'sw',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/tanzania.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Swahili'),
                          ],
                        ),
                      ),

                      DropdownMenuItem<String>(
                        value: 'sv',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/sweden.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Swedish'),
                          ],
                        ),
                      ),

                      DropdownMenuItem<String>(
                        value: 'ta',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/india.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Tamil'),
                          ],
                        ),
                      ),

                      DropdownMenuItem<String>(
                        value: 'te',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/india.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Telugu'),
                          ],
                        ),
                      ),

                      DropdownMenuItem<String>(
                        value: 'th',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/thai.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Thai'),
                          ],
                        ),
                      ),

                      DropdownMenuItem<String>(
                        value: 'to',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/tonga.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Tonga'),
                          ],
                        ),
                      ),

                      DropdownMenuItem<String>(
                        value: 'tr',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/turkey.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Turkish'),
                          ],
                        ),
                      ),

                      DropdownMenuItem<String>(
                        value: 'uk',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/ukraine.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Ukrainian'),
                          ],
                        ),
                      ),

                      DropdownMenuItem<String>(
                        value: 'ur',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/urdu.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Urdu'),
                          ],
                        ),
                      ),

                      DropdownMenuItem<String>(
                        value: 'vi',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/vietnam.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Vietnamese'),
                          ],
                        ),
                      ),

                      DropdownMenuItem<String>(
                        value: 'cy',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/wales.png',
                              width: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text('Welsh'),
                          ],
                        ),
                      ),

                      // DropdownMenuItem<String>(
                      //   value: '-',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Select Language'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'af',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Afrikaans'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'ar',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Arabic'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'bn',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Bengali/Bangla'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'bg',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Bulgarian'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'ca',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Catalan'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'zh',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Chinese'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'hr',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Croatian'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'cs',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Czech'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'da',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Danish'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'nl',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Dutch'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'english',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('English'),
                      //     ],
                      //   ),
                      // ),
                      //
                      //
                      //
                      // DropdownMenuItem<String>(
                      //   value: 'et',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Estonian'),
                      //     ],
                      //   ),
                      // ),
                      //
                      // DropdownMenuItem<String>(
                      //   value: 'fj',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Fijian'),
                      //     ],
                      //   ),
                      // ),
                      //
                      // DropdownMenuItem<String>(
                      //   value: 'fi',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Finnish'),
                      //     ],
                      //   ),
                      // ),
                      //
                      // DropdownMenuItem<String>(
                      //   value: 'fr',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('French'),
                      //     ],
                      //   ),
                      // ),
                      //
                      // DropdownMenuItem<String>(
                      //   value: 'de',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('German'),
                      //     ],
                      //   ),
                      // ),
                      //
                      // DropdownMenuItem<String>(
                      //   value: 'el',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Greek'),
                      //     ],
                      //   ),
                      // ),
                      //
                      //
                      // DropdownMenuItem<String>(
                      //   value: 'gu',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Gujarati'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'hi',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Hindi'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'hu',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Hungarian'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'is',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Icelandic'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'ga',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Irish'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'it',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Italian'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'ja',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Japanese'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'kn',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Kannada'),
                      //     ],
                      //   ),
                      // ),
                      //
                      //
                      // DropdownMenuItem<String>(
                      //   value: 'kk',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Kazakh'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'ko',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Korean'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'lv',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Latvian/Lettish'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'lt',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Lithuanian'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'mg',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Malagasy'),
                      //     ],
                      //   ),
                      // ),
                      //
                      //
                      // DropdownMenuItem<String>(
                      //   value: 'ms', // Malay
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Malay (ms)'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'ml', // Malayalam
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Malayalam (ml)'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'mt', // Maltese
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Maltese (mt)'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'mi', // Maori
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Maori (mi)'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'mr', // Marathi
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Marathi (mr)'),
                      //     ],
                      //   ),
                      // ),
                      //
                      // DropdownMenuItem<String>(
                      //   value: 'no',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Norwegian'),
                      //     ],
                      //   ),
                      // ),
                      //
                      // DropdownMenuItem<String>(
                      //   value: 'fa',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Persian'),
                      //     ],
                      //   ),
                      // ),
                      //
                      // DropdownMenuItem<String>(
                      //   value: 'pl',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Polish'),
                      //     ],
                      //   ),
                      // ),
                      //
                      // DropdownMenuItem<String>(
                      //   value: 'pt',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Portuguese'),
                      //     ],
                      //   ),
                      // ),
                      //
                      // DropdownMenuItem<String>(
                      //   value: 'pa',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Punjabi'),
                      //     ],
                      //   ),
                      // ),
                      //
                      //
                      // DropdownMenuItem<String>(
                      //   value: 'ro',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Romanian'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'ru',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Russian'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'sm',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Samoan'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'sr',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Serbian'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'sk',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Slovak'),
                      //     ],
                      //   ),
                      // ),
                      //
                      // DropdownMenuItem<String>(
                      //   value: 'sl',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Slovenian'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'es',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Spanish'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'sw',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Swahili'),
                      //     ],
                      //   ),
                      // ),
                      //
                      // DropdownMenuItem<String>(
                      //   value: 'sv',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Swedish'),
                      //     ],
                      //   ),
                      // ),
                      //
                      // DropdownMenuItem<String>(
                      //   value: 'ta',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Tamil'),
                      //     ],
                      //   ),
                      // ),
                      //
                      // DropdownMenuItem<String>(
                      //   value: 'te',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Telugu'),
                      //     ],
                      //   ),
                      // ),
                      //
                      // DropdownMenuItem<String>(
                      //   value: 'th',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Thai'),
                      //     ],
                      //   ),
                      // ),
                      //
                      // DropdownMenuItem<String>(
                      //   value: 'to',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Tonga'),
                      //     ],
                      //   ),
                      // ),
                      //
                      // DropdownMenuItem<String>(
                      //   value: 'tr',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Turkish'),
                      //     ],
                      //   ),
                      // ),
                      //
                      // DropdownMenuItem<String>(
                      //   value: 'uk',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Ukrainian'),
                      //     ],
                      //   ),
                      // ),
                      //
                      // DropdownMenuItem<String>(
                      //   value: 'ur',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Urdu'),
                      //     ],
                      //   ),
                      // ),
                      //
                      // DropdownMenuItem<String>(
                      //   value: 'vi',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Vietnamese'),
                      //     ],
                      //   ),
                      // ),
                      //
                      // DropdownMenuItem<String>(
                      //   value: 'cy',
                      //   child: Row(
                      //     children: [
                      //
                      //       SizedBox(width: 8.0),
                      //       Text('Welsh'),
                      //     ],
                      //   ),
                      // ),
                      //

                      // DropdownMenuItem<String>(
                      //   value: 'af',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/afrikaans.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Afrikaans'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'ar',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/arabic.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Arabic'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'bn',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/bengali.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Bengali/Bangla'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'bg',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/bulgarian.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Bulgarian'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'ca',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/catalan.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Catalan'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'zh',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/chinese.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Chinese'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'hr',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/croatian.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Croatian'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'cs',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/czech.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Czech'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'da',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/danish.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Danish'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'nl',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/dutch.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Dutch'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'en',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/english.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('English'),
                      //     ],
                      //   ),
                      // ),
                      //
                      //
                      //
                      // DropdownMenuItem<String>(
                      //   value: 'et',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/estonia.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Estonian'),
                      //     ],
                      //   ),
                      // ),
                      //
                      // DropdownMenuItem<String>(
                      //   value: 'fj',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/fiji.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Fijian'),
                      //     ],
                      //   ),
                      // ),
                      //
                      // DropdownMenuItem<String>(
                      //   value: 'fi',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/finland.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Finnish'),
                      //     ],
                      //   ),
                      // ),
                      //
                      // DropdownMenuItem<String>(
                      //   value: 'fr',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/france.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('French'),
                      //     ],
                      //   ),
                      // ),
                      //
                      // DropdownMenuItem<String>(
                      //   value: 'de',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/germany.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('German'),
                      //     ],
                      //   ),
                      // ),
                      //
                      // DropdownMenuItem<String>(
                      //   value: 'el',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/greece.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Greek'),
                      //     ],
                      //   ),
                      // ),
                      //
                      //
                      // DropdownMenuItem<String>(
                      //   value: 'gu',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/india.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Gujarati'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'hi',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/india.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Hindi'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'hu',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/hungary.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Hungarian'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'is',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/iceland.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Icelandic'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'ga',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/ireland.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Irish'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'it',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/italy.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Italian'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'ja',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/japan.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Japanese'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'kn',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/india.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Kannada'),
                      //     ],
                      //   ),
                      // ),
                      //
                      //
                      // DropdownMenuItem<String>(
                      //   value: 'kk',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/kazakhstan.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Kazakh'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'ko',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/south-korea.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Korean'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'lv',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/latvia.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Latvian/Lettish'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'lt',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/lithuania.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Lithuanian'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'mg',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/madagascar.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Malagasy'),
                      //     ],
                      //   ),
                      // ),
                      //
                      //
                      // DropdownMenuItem<String>(
                      //   value: 'ms', // Malay
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/malay.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Malay (ms)'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'ml', // Malayalam
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/malayalam.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Malayalam (ml)'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'mt', // Maltese
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/maltese.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Maltese (mt)'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'mi', // Maori
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/maori.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Maori (mi)'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'mr', // Marathi
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/marathi.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Marathi (mr)'),
                      //     ],
                      //   ),
                      // ),
                      //
                      // DropdownMenuItem<String>(
                      //   value: 'no',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/norway.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Norwegian'),
                      //     ],
                      //   ),
                      // ),
                      //
                      // DropdownMenuItem<String>(
                      //   value: 'fa',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/iran.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Persian'),
                      //     ],
                      //   ),
                      // ),
                      //
                      // DropdownMenuItem<String>(
                      //   value: 'pl',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/poland.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Polish'),
                      //     ],
                      //   ),
                      // ),
                      //
                      // DropdownMenuItem<String>(
                      //   value: 'pt',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/portugal.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Portuguese'),
                      //     ],
                      //   ),
                      // ),
                      //
                      // DropdownMenuItem<String>(
                      //   value: 'pa',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/india.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Punjabi'),
                      //     ],
                      //   ),
                      // ),
                      //
                      //
                      // DropdownMenuItem<String>(
                      //   value: 'ro',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/romania.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Romanian'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'ru',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/russia.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Russian'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'sm',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/samoa.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Samoan'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'sr',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/serbia.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Serbian'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'sk',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/slovakia.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Slovak'),
                      //     ],
                      //   ),
                      // ),
                      //
                      // DropdownMenuItem<String>(
                      //   value: 'sl',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/slovenia.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Slovenian'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'es',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/spain.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Spanish'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'sw',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/tanzania.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Swahili'),
                      //     ],
                      //   ),
                      // ),
                      //
                      // DropdownMenuItem<String>(
                      //   value: 'sv',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/sweden.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Swedish'),
                      //     ],
                      //   ),
                      // ),
                      //
                      // DropdownMenuItem<String>(
                      //   value: 'ta',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/tamil.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Tamil'),
                      //     ],
                      //   ),
                      // ),
                      //
                      // DropdownMenuItem<String>(
                      //   value: 'te',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/telugu.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Telugu'),
                      //     ],
                      //   ),
                      // ),
                      //
                      // DropdownMenuItem<String>(
                      //   value: 'th',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/thai.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Thai'),
                      //     ],
                      //   ),
                      // ),
                      //
                      // DropdownMenuItem<String>(
                      //   value: 'to',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/tonga.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Tonga'),
                      //     ],
                      //   ),
                      // ),
                      //
                      // DropdownMenuItem<String>(
                      //   value: 'tr',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/turkey.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Turkish'),
                      //     ],
                      //   ),
                      // ),
                      //
                      // DropdownMenuItem<String>(
                      //   value: 'uk',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/ukraine.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Ukrainian'),
                      //     ],
                      //   ),
                      // ),
                      //
                      // DropdownMenuItem<String>(
                      //   value: 'ur',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/urdu.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Urdu'),
                      //     ],
                      //   ),
                      // ),
                      //
                      // DropdownMenuItem<String>(
                      //   value: 'vi',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/vietnam.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Vietnamese'),
                      //     ],
                      //   ),
                      // ),
                      //
                      // DropdownMenuItem<String>(
                      //   value: 'cy',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/wales.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Welsh'),
                      //     ],
                      //   ),
                      // ),

                      // DropdownMenuItem<String>(
                      //   value: 'en',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/russia.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('English'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'fr',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/russia.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Français'),
                      //     ],
                      //   ),
                      // ),
                      // DropdownMenuItem<String>(
                      //   value: 'es',
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/russia.png',
                      //         width: 24.0,
                      //       ),
                      //       SizedBox(width: 8.0),
                      //       Text('Español'),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(
              height: 20,
            ),

            // DropdownButton<String>(
            //   value: 'Option 1',
            //   onChanged: (value) {},
            //   items: <String>['Option 1', 'Option 2', 'Option 3', 'Option 4']
            //       .map<DropdownMenuItem<String>>((String value) {
            //     return DropdownMenuItem<String>(
            //       value: value,
            //       child: Text(value),
            //     );
            //   }).toList(),
            // ),
            Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 150.0,
                    width: double.infinity,
                    child: Container(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          output,
                          style: TextStyle(
                              color: Colors.black87,
                              fontStyle: FontStyle.italic),
                        )),
                  ),

                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.copy, color: Color(0xff2096f3)),
                        onPressed: () {
                          copyToClipboard(output);
                        },
                      ),
                      // IconButton(
                      //   icon: Icon(Icons.volume_up_outlined),
                      //   onPressed: () {},
                      // ),
                      IconButton(
                        icon: Icon(Icons.cloud_download_outlined,
                            color: Color(0xff2096f3)),
                        onPressed: () {
                          _requestStoragePermission(context);
                          // downloadText(output);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.refresh_outlined,
                            color: Color(0xff2096f3)),
                        onPressed: () {
                          setState(() {
                            output = 'Your output will be displayed here...';
                          });
                        },
                      ),
                    ],
                  ),

                  // Positioned(
                  //   left: 0.0,
                  //   bottom: 0.0,
                  //   child: Row(
                  //     children: [
                  //       IconButton(
                  //         icon: Icon(Icons.copy),
                  //         onPressed: () {
                  //           copyToClipboard(output);
                  //         },
                  //       ),
                  //       // IconButton(
                  //       //   icon: Icon(Icons.volume_up_outlined),
                  //       //   onPressed: () {},
                  //       // ),
                  //       IconButton(
                  //         icon: Icon(Icons.cloud_download_outlined),
                  //         onPressed: () {
                  //           _requestStoragePermission(context);
                  //           // downloadText(output);
                  //         },
                  //       ),
                  //       IconButton(
                  //         icon: Icon(Icons.refresh_outlined),
                  //         onPressed: () {
                  //           setState(() {
                  //             output = 'Your output will be displayed here...';
                  //           });
                  //         },
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),

            Spacer(),
            MicButton(
              onDataChanged: (value) {
                print("objectobjectobjectobject1");
                apicall(value);
                // Update the data in the parent widget when the data changes in the child widget
                setState(() {
                  audio_file = value;
                });
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Card(
        elevation: 10,
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.cloud_upload_outlined),
              label: 'Upload',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  chooseFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['wav'],
    );

    if (result != null) {
      print('pppppppppppp ${result.files.single.path}');

      setState(() {
        // file_url=result.files.single.path;
      });

      apicall(result.files.single.path!);

      // File? files = File(result?.files?.single?.path);
    } else {
      // User canceled the picker
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      chooseFile();

      // Navigator.pushReplacement(context,
      //     MaterialPageRoute(builder: (context) => AudioUploaderScreen()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ShrutLekh()));
    }
  }
}
