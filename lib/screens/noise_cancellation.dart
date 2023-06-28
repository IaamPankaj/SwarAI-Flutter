import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:swar_ai/components/AudioPlayerComponent.dart';
import 'package:swar_ai/components/AudioPlayerWidget.dart';
import 'package:swar_ai/components/MicButton.dart';
import 'package:swar_ai/constants/constants.dart';
import 'package:swar_ai/screens/AudioUploaderScreen.dart';
import 'package:swar_ai/screens/apirequest.dart';
import 'package:swar_ai/constants/utils.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class NoiseCan extends StatefulWidget {
  @override
  _NoiseCanState createState() => _NoiseCanState();
}

class _NoiseCanState extends State<NoiseCan> {
  String _selectedOption = 'Option 1';
  double _selectedValue = 50.0;

  int _selectedIndex = 0;

  bool _switchValue1 = false;
  bool _switchValue2 = false;

  String selectedLanguage = "1.0";

  String audio_file = '';
  String? file_url = '';

  AlertDialog alert = AlertDialog(
    content: Row(children: [
      CircularProgressIndicator(
        backgroundColor: Colors.red,
      ),
      Container(margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
    ]),
  );

  apicall(String? _recordingFilePath) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
    try {
      final file = File(_recordingFilePath!);
      // print('------------------------ ${file}');
      print("-------------");
      print(
          "_filePath_filePath_filePath_filePath ${await getStringLocal('access')}");

      ApiService apiService = ApiService();
      final url = apiUrl + noiseReduction;
      final headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer ${await getStringLocal('access')}",
      };
      final body = {"frequency": selectedLanguage.toString()};

      final response = await apiService.uploadFileWithParamsAndHeaders(
          url, _recordingFilePath!, body, headers);

      print(
          "responseresponseresponseresponse ${response.statusCode} ${response.body}");
      if (response.statusCode == 200) {
        Map<String, dynamic> map = json.decode(response.body);
        setState(() {
          audio_file = map['file_url'];
          // output = map['text'];
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

  chooseFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['wav'],
    );

    if (result != null) {
      print('pppppppppppp ${result.files.single.path}');

      setState(() {
        file_url = result.files.single.path;
      });

      apicall(result.files.single.path);

      // File? files = File(result?.files?.single?.path);
    } else {
      // User canceled the picker
    }
  }

//   apicall() {
//     ApiService apiService = ApiService();
//
//     Map<String, String> data = {
//       "File": "string",
//       "translated language": selectedLanguage,
//     };
//
//     final headers = {'Content-Type': 'application/json'};
//
//     // Example file upload
//     File file = File('path/to/file');
//     apiService.uploadFile(file, apiUrl + noiseReduction,  data, headers).then((response) {
//       print(response);
//     });
//
// // Example POST request
// //     Map<String, dynamic> data = {
// //       "File": "string",
// //       "translated language": selectedLanguage,
// //       "destination langauge": "string"
// //     };
// //
// //     apiService.postRequest(apiUrl + stationaryReduction, data).then((response) {
// //       print(response.body);
// //     });
//   }

  volumeincreaseapicall() {
    ApiService apiService = ApiService();

    Map<String, String> data = {
      "File": "string",
      "translated language": selectedLanguage,
    };

    final headers = {'Content-Type': 'application/json'};

    // Example file upload
    File file = File('path/to/file');
    apiService
        .uploadFile(file, apiUrl + volume, data, headers)
        .then((response) {
      print(response);
    });

// Example POST request
//     Map<String, dynamic> data = {
//       "File": "string",
//       "Volume": "1.0"
//     };
//
//     apiService.postRequest(apiUrl + volume, data).then((response) {
//       print(response.body);
//     });
  }

  Future<void> _downloadFile() async {
    String fileName = audio_file.split('/').last;
    var request = await http.get(Uri.parse(audio_file));
    var bytes = request.bodyBytes;
    String dir = (await getExternalStorageDirectory())!.path;
    File file = File('$dir/$fileName');
    await file.writeAsBytes(bytes);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('File downloaded successfully.'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Noise Cancellation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(
              width: 200,
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
                    apicall(file_url);
                  },
                  items: [
                    DropdownMenuItem<String>(
                      value: '1.0',
                      child: Row(
                        children: [
                          // Image.asset(
                          //   'assets/images/russia.png',
                          //   width: 24.0,
                          // ),
                          SizedBox(width: 8.0),
                          Text('1.0'),
                        ],
                      ),
                    ),
                    DropdownMenuItem<String>(
                      value: '1.2',
                      child: Row(
                        children: [
                          // Image.asset(
                          //   'assets/images/russia.png',
                          //   width: 24.0,
                          // ),
                          SizedBox(width: 8.0),
                          Text('1.2'),
                        ],
                      ),
                    ),
                    DropdownMenuItem<String>(
                      value: '1.4',
                      child: Row(
                        children: [
                          // Image.asset(
                          //   'assets/images/russia.png',
                          //   width: 24.0,
                          // ),
                          SizedBox(width: 8.0),
                          Text('1.4'),
                        ],
                      ),
                    ),
                    DropdownMenuItem<String>(
                      value: '1.6',
                      child: Row(
                        children: [
                          // Image.asset(
                          //   'assets/images/russia.png',
                          //   width: 24.0,
                          // ),
                          SizedBox(width: 8.0),
                          Text('1.6'),
                        ],
                      ),
                    ),
                    DropdownMenuItem<String>(
                      value: '1.8',
                      child: Row(
                        children: [
                          // Image.asset(
                          //   'assets/images/russia.png',
                          //   width: 24.0,
                          // ),
                          SizedBox(width: 8.0),
                          Text('1.8'),
                        ],
                      ),
                    ),
                    DropdownMenuItem<String>(
                      value: '2.0',
                      child: Row(
                        children: [
                          // Image.asset(
                          //   'assets/images/russia.png',
                          //   width: 24.0,
                          // ),
                          SizedBox(width: 8.0),
                          Text('2.0'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Card(
            //   child: Column(
            //     children: [
            //       Padding(
            //         padding: EdgeInsets.all(16.0),
            //         child: Text('This is my card'),
            //       ),
            //     ],
            //   ),
            // ),
            // Card(
            //   elevation: 10,
            //   child: GestureDetector(
            //     onTap: () {
            //       print("111111");
            //       chooseFile();
            //       // Handle file upload or drop file here
            //     },
            //     child: Container(
            //       margin: EdgeInsets.all(16.0),
            //       padding: EdgeInsets.all(16.0),
            //       decoration: BoxDecoration(
            //         border: Border.all(color: Colors.grey),
            //       ),
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Icon(Icons.file_upload),
            //           SizedBox(width: 16.0),
            //           Text('Upload or drop file here'),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),

            SizedBox(
              height: 20,
            ),

            // Card(
            //   elevation: 10,
            //   child: Column(
            //     children: [
            //       Row(
            //         children: [
            //
            //           Padding(
            //             padding: const EdgeInsets.fromLTRB(25.0, 0,0,0),
            //             child:  Text("You can vary voulme range here"),
            //           ),
            //           Spacer(),
            //           Switch(
            //             value: _switchValue1,
            //             onChanged: (value) {
            //               setState(() {
            //                 _switchValue1 = value;
            //               });
            //             },
            //           ),
            //         ],
            //       ),
            //       Slider(
            //         value: _selectedValue,
            //         min: 0,
            //         max: 100,
            //         onChanged: (value) {
            //           setState(() {
            //             _selectedValue = value;
            //           });
            //         },
            //       ),
            //     ],
            //   ),
            // ),
            //
            //
            // Card(
            //   elevation: 10,
            //   child: Column(
            //     children: [
            //       Row(
            //         children: [
            //           Padding(
            //             padding: const EdgeInsets.fromLTRB(25.0, 0,0,0),
            //             child: Text("Volume"),
            //           ),
            //           Spacer(),
            //           Switch(
            //             value: _switchValue2,
            //             onChanged: (value) {
            //               setState(() {
            //                 _switchValue2 = value;
            //               });
            //             },
            //           ),
            //         ],
            //       ),
            //       Slider(
            //         value: _selectedValue,
            //         min: 0,
            //         max: 100,
            //         onChanged: (value) {
            //           setState(() {
            //             _selectedValue = value;
            //           });
            //         },
            //       ),
            //     ],
            //   ),
            // ),

            Card(
              elevation: 10,
              child: Column(
                children: [


                  SizedBox(
                    height: 75.0,
                    width: double.infinity,
                    child: Container(

                      child: audio_file != '' ?
                      AudioPlayerWidgetCommon(url: audio_file)

                      // Expanded(
                      //    child: ListView.builder(
                      //      itemCount: 1,
                      //      itemBuilder: (BuildContext context, int index) {
                      //        // return  AudioPlayerWidget(audio_file);
                      //
                      //        // return CustomAudioPlayer(audioPath: audio_file);
                      //
                      //        return AudioPlayerWidgetCommon(url: audio_file);
                      //
                      //      },
                      //    ),
                      //
                      //  )

                          : Container( padding: EdgeInsets.all(20), child: Text("Your output will be here...")),

                      // child: Text('Card Content'),
                    ),
                  ),

              //     audio_file != ''
              //
              //         ?
              // AudioPlayerWidgetCommon(url: audio_file)
              //     // Expanded(
              //     //       child: ListView.builder(
              //     //           itemCount: 1,
              //     //           itemBuilder: (BuildContext context, int index) {
              //     //             // return  AudioPlayerWidget(audio_file);
              //     //
              //     //             return AudioPlayerWidgetCommon(url: audio_file);
              //     //           },
              //     //         ),
              //     //     )
              //         : Text("Your output will be here..."),
              //
              //     // child: Text('Card Content'),

                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.copy, color: Color(0xff2096f3)),
                        onPressed: () {
                          showToast("Content Copied");

                          Clipboard.setData(ClipboardData(text: audio_file));
                        },
                      ),
                      // IconButton(
                      //   icon: Icon(Icons.volume_up_outlined),
                      //   onPressed: () {},
                      // ),
                      IconButton(
                        icon: Icon(Icons.cloud_download_outlined, color: Color(0xff2096f3)),
                        onPressed: () {
                          _downloadFile();
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.refresh_outlined, color: Color(0xff2096f3)),
                        onPressed: () {
                          setState(() {
                            audio_file = '';
                          });
                        },
                      ),
                    ],
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
                  file_url = value;
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
    if (index == 1) {
      chooseFile();
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AudioUploaderScreen()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => NoiseCan()));
    }
  }
}
