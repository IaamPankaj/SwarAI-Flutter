import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:swar_ai/constants/constants.dart';
import 'package:swar_ai/screens/AudioUploaderScreen.dart';
import 'package:swar_ai/screens/apirequest.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:swar_ai/components/MicButton.dart';
import 'package:swar_ai/constants/constants.dart';
import 'package:swar_ai/constants/utils.dart';
import 'package:swar_ai/screens/AudioUploaderScreen.dart';
import 'package:swar_ai/screens/apirequest.dart';
import 'package:swar_ai/constants/constants.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class Anuvad extends StatefulWidget {
  @override
  _AnuvadState createState() => _AnuvadState();
}

class _AnuvadState extends State<Anuvad> {
  int _selectedIndex = 0;

  // String dropdownValue = 'English';

  String selectedFromLanguage = "en";
  String selectedToLanguage = "fr";

  String output = 'Your output will be displayed here';
  String audio_file = '';

  apicall(String _recordingFilePath) async {
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
      final body = {"language": selectedFromLanguage.toString()};

      final response = await apiService.uploadFileWithParamsAndHeaders(
          url, _recordingFilePath, body, headers);

      print("responseresponseresponseresponse ${response.statusCode} ${response.body}");
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
    } catch (e) {
      print(e);
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
    final filename = 'shrutlekh_${now.year}-${now.month}-${now.day}_${now.hour}-${now.minute}-${now.second}.txt';
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
      appBar: AppBar(
        title: Text('Anuvad'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Row(
                children: [
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

                  SizedBox(
                    width: 150,
                    child: Card(

                      elevation: 10,
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xffF89880), width: 2), //<-- SEE HERE
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xffF89880), width: 2), //<-- SEE HERE
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        dropdownColor: Colors.white,
                        value: selectedFromLanguage,
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
                            selectedFromLanguage = newValue.toString();
                          });
                        },
                        items: [
                          DropdownMenuItem<String>(
                            value: 'en',
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/russia.png',
                                  width: 24.0,
                                ),
                                SizedBox(width: 8.0),
                                Text('English'),
                              ],
                            ),
                          ),
                          DropdownMenuItem<String>(
                            value: 'fr',
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/russia.png',
                                  width: 24.0,
                                ),
                                SizedBox(width: 8.0),
                                Text('Français'),
                              ],
                            ),
                          ),
                          DropdownMenuItem<String>(
                            value: 'es',
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/russia.png',
                                  width: 24.0,
                                ),
                                SizedBox(width: 8.0),
                                Text('Español'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ElevatedButton(
                  //   onPressed: () {
                  //
                  //   },
                  //   child: Text('<=>'),
                  // ),

                  IconButton(
                    icon: Icon(Icons.swap_horiz_outlined),
                    onPressed: () {

                      String temp = selectedFromLanguage;

                      setState(() {
                        selectedFromLanguage = selectedToLanguage;
                        selectedToLanguage = temp;
                      });

                    },
                  ),

                  SizedBox(
                    width: 150,
                    child: Card(
                      elevation: 10,
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xffF89880), width: 2), //<-- SEE HERE
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xffF89880), width: 2), //<-- SEE HERE
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        dropdownColor: Colors.white,
                        value: selectedToLanguage,
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
                            selectedToLanguage = newValue.toString();
                          });
                        },
                        items: [
                          DropdownMenuItem<String>(
                            value: 'en',
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/russia.png',
                                  width: 24.0,
                                ),
                                SizedBox(width: 8.0),
                                Text('English'),
                              ],
                            ),
                          ),
                          DropdownMenuItem<String>(
                            value: 'fr',
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/russia.png',
                                  width: 24.0,
                                ),
                                SizedBox(width: 8.0),
                                Text('Français'),
                              ],
                            ),
                          ),
                          DropdownMenuItem<String>(
                            value: 'es',
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/russia.png',
                                  width: 24.0,
                                ),
                                SizedBox(width: 8.0),
                                Text('Español'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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
                ],
              ),
              Card(

                child: Column(
                  children: [
                    SizedBox(
                      height: 300.0,
                      width: double.infinity,
                      child: Center(
                        child: Text(output),
                      ),
                    ),
                    Positioned(
                      left: 0.0,
                      bottom: 0.0,
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.copy),
                            onPressed: () {
                              copyToClipboard(output);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.volume_up_outlined),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(Icons.cloud_download_outlined),
                            onPressed: () {
                              _requestStoragePermission(context);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.refresh_outlined),
                            onPressed: () {
                              setState(() {
                                output = 'Your output will be displayed here...';
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.star_border_outlined),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Spacer(),
              MicButton(
                onDataChanged: (value) {
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if(index == 1) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AudioUploaderScreen()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Anuvad()));
    }
  }
}