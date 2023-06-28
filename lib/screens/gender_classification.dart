import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:swar_ai/components/MicButton.dart';
import 'package:swar_ai/constants/constants.dart';
import 'package:swar_ai/constants/utils.dart';
import 'package:swar_ai/screens/AudioUploaderScreen.dart';
import 'package:swar_ai/screens/apirequest.dart';

class GenderCla extends StatefulWidget {
  @override
  _GenderClaState createState() => _GenderClaState();
}

class _GenderClaState extends State<GenderCla> {
  String _selectedOption = 'Option 1';
  double _selectedValue = 50.0;

  int _selectedIndex = 0;

  bool _switchValue1 = false;
  bool _switchValue2 = false;

  String selectedLanguage = "fr";

  String audio_file = '';
  String? file_url = '';

  String output = 'Your output will be displayed here';

  String male = "";
  String female = "";

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
      final url = apiUrl + genderClassification;
      final headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer ${await getStringLocal('access')}",
      };
      final body = {"": ""};

      final response = await apiService.uploadFileWithParamsAndHeaders(
          url, _recordingFilePath!, body, headers);

      print("responseresponseresponseresponse ${response.statusCode} ${response.body}");
      if (response.statusCode == 200) {
        Map<String, dynamic> map = json.decode(response.body);
        setState(() {
          output=map['gender'] + "\nMale: ${map['male']}" + "\nFemale: ${map['female']}";
          // male=map['male'];
          // female=map['female'];


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

  chooseFile () async {

    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {

      print('pppppppppppp ${result.files.single.path}');

      setState(() {
        file_url=result.files.single.path;
      });

      apicall(result.files.single.path);

      // File? files = File(result?.files?.single?.path);
    } else {
      // User canceled the picker
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Gender Classification'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [


              // Card(
              //   elevation: 10,
              //   child: DropdownButtonFormField<String>(
              //     decoration: InputDecoration(
              //       enabledBorder: OutlineInputBorder(
              //         borderSide: BorderSide(
              //             color: Color(0xffF89880), width: 2), //<-- SEE HERE
              //       ),
              //       focusedBorder: OutlineInputBorder(
              //         borderSide: BorderSide(
              //             color: Color(0xffF89880), width: 2), //<-- SEE HERE
              //       ),
              //       filled: true,
              //       fillColor: Colors.white,
              //     ),
              //     dropdownColor: Colors.white,
              //     value: selectedLanguage,
              //     icon: Icon(Icons.arrow_drop_down),
              //     iconSize: 24.0,
              //     elevation: 16,
              //     style: TextStyle(color: Colors.black, fontSize: 16.0),
              //     // underline: Container(
              //     //   height: 2,
              //     //   color: Colors.blue,
              //     // ),
              //     onChanged: (newValue) {
              //       // setState(() {
              //       //   selectedLanguage = newValue;
              //       // });
              //     },
              //     items: [
              //       DropdownMenuItem<String>(
              //         value: 'af',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Afrikaans'),
              //           ],
              //         ),
              //       ),
              //       DropdownMenuItem<String>(
              //         value: 'ar',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Arabic'),
              //           ],
              //         ),
              //       ),
              //       DropdownMenuItem<String>(
              //         value: 'bn',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Bengali/Bangla'),
              //           ],
              //         ),
              //       ),
              //       DropdownMenuItem<String>(
              //         value: 'bg',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Bulgarian'),
              //           ],
              //         ),
              //       ),
              //       DropdownMenuItem<String>(
              //         value: 'ca',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Catalan'),
              //           ],
              //         ),
              //       ),
              //       DropdownMenuItem<String>(
              //         value: 'zh',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Chinese'),
              //           ],
              //         ),
              //       ),
              //       DropdownMenuItem<String>(
              //         value: 'hr',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Croatian'),
              //           ],
              //         ),
              //       ),
              //       DropdownMenuItem<String>(
              //         value: 'cs',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Czech'),
              //           ],
              //         ),
              //       ),
              //       DropdownMenuItem<String>(
              //         value: 'da',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Danish'),
              //           ],
              //         ),
              //       ),
              //       DropdownMenuItem<String>(
              //         value: 'nl',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Dutch'),
              //           ],
              //         ),
              //       ),
              //       DropdownMenuItem<String>(
              //         value: 'en',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('English'),
              //           ],
              //         ),
              //       ),
              //
              //
              //
              //       DropdownMenuItem<String>(
              //         value: 'et',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Estonian'),
              //           ],
              //         ),
              //       ),
              //
              //       DropdownMenuItem<String>(
              //         value: 'fj',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Fijian'),
              //           ],
              //         ),
              //       ),
              //
              //       DropdownMenuItem<String>(
              //         value: 'fi',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Finnish'),
              //           ],
              //         ),
              //       ),
              //
              //       DropdownMenuItem<String>(
              //         value: 'fr',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('French'),
              //           ],
              //         ),
              //       ),
              //
              //       DropdownMenuItem<String>(
              //         value: 'de',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('German'),
              //           ],
              //         ),
              //       ),
              //
              //       DropdownMenuItem<String>(
              //         value: 'el',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Greek'),
              //           ],
              //         ),
              //       ),
              //
              //
              //       DropdownMenuItem<String>(
              //         value: 'gu',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Gujarati'),
              //           ],
              //         ),
              //       ),
              //       DropdownMenuItem<String>(
              //         value: 'hi',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Hindi'),
              //           ],
              //         ),
              //       ),
              //       DropdownMenuItem<String>(
              //         value: 'hu',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Hungarian'),
              //           ],
              //         ),
              //       ),
              //       DropdownMenuItem<String>(
              //         value: 'is',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Icelandic'),
              //           ],
              //         ),
              //       ),
              //       DropdownMenuItem<String>(
              //         value: 'ga',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Irish'),
              //           ],
              //         ),
              //       ),
              //       DropdownMenuItem<String>(
              //         value: 'it',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Italian'),
              //           ],
              //         ),
              //       ),
              //       DropdownMenuItem<String>(
              //         value: 'ja',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Japanese'),
              //           ],
              //         ),
              //       ),
              //       DropdownMenuItem<String>(
              //         value: 'kn',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Kannada'),
              //           ],
              //         ),
              //       ),
              //
              //
              //       DropdownMenuItem<String>(
              //         value: 'kk',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Kazakh'),
              //           ],
              //         ),
              //       ),
              //       DropdownMenuItem<String>(
              //         value: 'ko',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Korean'),
              //           ],
              //         ),
              //       ),
              //       DropdownMenuItem<String>(
              //         value: 'lv',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Latvian/Lettish'),
              //           ],
              //         ),
              //       ),
              //       DropdownMenuItem<String>(
              //         value: 'lt',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Lithuanian'),
              //           ],
              //         ),
              //       ),
              //       DropdownMenuItem<String>(
              //         value: 'mg',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Malagasy'),
              //           ],
              //         ),
              //       ),
              //
              //
              //       DropdownMenuItem<String>(
              //         value: 'ms', // Malay
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Malay (ms)'),
              //           ],
              //         ),
              //       ),
              //       DropdownMenuItem<String>(
              //         value: 'ml', // Malayalam
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Malayalam (ml)'),
              //           ],
              //         ),
              //       ),
              //       DropdownMenuItem<String>(
              //         value: 'mt', // Maltese
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Maltese (mt)'),
              //           ],
              //         ),
              //       ),
              //       DropdownMenuItem<String>(
              //         value: 'mi', // Maori
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Maori (mi)'),
              //           ],
              //         ),
              //       ),
              //       DropdownMenuItem<String>(
              //         value: 'mr', // Marathi
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Marathi (mr)'),
              //           ],
              //         ),
              //       ),
              //
              //       DropdownMenuItem<String>(
              //         value: 'no',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Norwegian'),
              //           ],
              //         ),
              //       ),
              //
              //       DropdownMenuItem<String>(
              //         value: 'fa',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Persian'),
              //           ],
              //         ),
              //       ),
              //
              //       DropdownMenuItem<String>(
              //         value: 'pl',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Polish'),
              //           ],
              //         ),
              //       ),
              //
              //       DropdownMenuItem<String>(
              //         value: 'pt',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Portuguese'),
              //           ],
              //         ),
              //       ),
              //
              //       DropdownMenuItem<String>(
              //         value: 'pa',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Punjabi'),
              //           ],
              //         ),
              //       ),
              //
              //
              //       DropdownMenuItem<String>(
              //         value: 'ro',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Romanian'),
              //           ],
              //         ),
              //       ),
              //       DropdownMenuItem<String>(
              //         value: 'ru',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Russian'),
              //           ],
              //         ),
              //       ),
              //       DropdownMenuItem<String>(
              //         value: 'sm',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Samoan'),
              //           ],
              //         ),
              //       ),
              //       DropdownMenuItem<String>(
              //         value: 'sr',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Serbian'),
              //           ],
              //         ),
              //       ),
              //       DropdownMenuItem<String>(
              //         value: 'sk',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Slovak'),
              //           ],
              //         ),
              //       ),
              //
              //       DropdownMenuItem<String>(
              //         value: 'sl',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Slovenian'),
              //           ],
              //         ),
              //       ),
              //       DropdownMenuItem<String>(
              //         value: 'es',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Spanish'),
              //           ],
              //         ),
              //       ),
              //       DropdownMenuItem<String>(
              //         value: 'sw',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Swahili'),
              //           ],
              //         ),
              //       ),
              //
              //       DropdownMenuItem<String>(
              //         value: 'sv',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Swedish'),
              //           ],
              //         ),
              //       ),
              //
              //       DropdownMenuItem<String>(
              //         value: 'ta',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Tamil'),
              //           ],
              //         ),
              //       ),
              //
              //       DropdownMenuItem<String>(
              //         value: 'te',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Telugu'),
              //           ],
              //         ),
              //       ),
              //
              //       DropdownMenuItem<String>(
              //         value: 'th',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Thai'),
              //           ],
              //         ),
              //       ),
              //
              //       DropdownMenuItem<String>(
              //         value: 'to',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Tonga'),
              //           ],
              //         ),
              //       ),
              //
              //       DropdownMenuItem<String>(
              //         value: 'tr',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Turkish'),
              //           ],
              //         ),
              //       ),
              //
              //       DropdownMenuItem<String>(
              //         value: 'uk',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Ukrainian'),
              //           ],
              //         ),
              //       ),
              //
              //       DropdownMenuItem<String>(
              //         value: 'ur',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Urdu'),
              //           ],
              //         ),
              //       ),
              //
              //       DropdownMenuItem<String>(
              //         value: 'vi',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Vietnamese'),
              //           ],
              //         ),
              //       ),
              //
              //       DropdownMenuItem<String>(
              //         value: 'cy',
              //         child: Row(
              //           children: [
              //
              //             SizedBox(width: 8.0),
              //             Text('Welsh'),
              //           ],
              //         ),
              //       ),
              //
              //     ],
              //   ),
              // ),

              // DropdownButton<String>(
              //   value: _selectedOption,
              //   items: ['Option 1', 'Option 2', 'Option 3']
              //       .map((option) => DropdownMenuItem<String>(
              //     value: option,
              //     child: Text(option),
              //   ))
              //       .toList(),
              //   onChanged: (option) {
              //     setState(() {
              //       _selectedOption = option.toString();
              //     });
              //   },
              // ),

              // GestureDetector(
              //   onTap: () {
              //     chooseFile();
              //
              //     // Handle file upload or drop file here
              //   },
              //   child: Container(
              //     margin: EdgeInsets.all(16.0),
              //     padding: EdgeInsets.all(16.0),
              //     decoration: BoxDecoration(
              //       border: Border.all(color: Colors.grey),
              //     ),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Icon(Icons.file_upload),
              //         SizedBox(width: 16.0),
              //         Text('Upload or drop file here'),
              //       ],
              //     ),
              //   ),
              // ),


              //
              // Card(
              //   elevation: 10,
              //   child: Column(
              //     children: [
              //       Row(
              //         children: [
              //           Slider(
              //             value: _selectedValue,
              //             min: 0,
              //             max: 100,
              //             onChanged: (value) {
              //               setState(() {
              //                 _selectedValue = value;
              //               });
              //             },
              //           ),
              //
              //           Text("20%"),
              //         ],
              //       ),
              //
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
              //           Slider(
              //             value: _selectedValue,
              //             min: 0,
              //             max: 100,
              //             onChanged: (value) {
              //               setState(() {
              //                 _selectedValue = value;
              //               });
              //             },
              //           ),
              //
              //           Text("80%"),
              //         ],
              //       ),
              //
              //     ],
              //   ),
              // ),

              Container(
                width: MediaQuery. of(context). size. width,
                child:

                Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 100.0,
                        width: double.infinity,
                        child:
                            Container(
                                padding: EdgeInsets.all(20),
                                child: Text(output, style: TextStyle( color: Colors.black87, fontStyle: FontStyle.italic),)),
                            // Container(
                            //     padding: EdgeInsets.all(20),
                            //     child: Text(male != "Male: ${male.toString()}" ? output :"", style: TextStyle( color: Colors.black87, fontStyle: FontStyle.italic),)),
                            // Container(
                            //     padding: EdgeInsets.all(20),
                            //     child: Text(male != "Female: ${female.toString()}" ? output :"", style: TextStyle( color: Colors.black87, fontStyle: FontStyle.italic),)),


                      ),



                      Row(
                        children: [

                          IconButton(
                            icon: Icon(Icons.refresh_outlined, color: Color(0xff2096f3)),
                            onPressed: () {
                              setState(() {
                                output = 'Your output will be displayed here...';
                                male = "";
                                female = "";
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




                // Card(
                //   child: Column(
                //     children: [
                //       Padding(
                //         padding: EdgeInsets.all(16.0),
                //         child: Text(output),
                //       ),
                //     ],
                //   ),
                // ),



              ),



              // Switch(
              //   value: _switchValue1,
              //   onChanged: (value) {
              //     setState(() {
              //       _switchValue1 = value;
              //     });
              //   },
              // ),
              //
              //
              //
              // Slider(
              //   value: _selectedValue,
              //   min: 0,
              //   max: 100,
              //   onChanged: (value) {
              //     setState(() {
              //       _selectedValue = value;
              //     });
              //   },
              // ),
              //
              // Switch(
              //   value: _switchValue2,
              //   onChanged: (value) {
              //     setState(() {
              //       _switchValue2 = value;
              //     });
              //   },
              // ),
              //
              // Slider(
              //   value: _selectedValue,
              //   min: 0,
              //   max: 100,
              //   onChanged: (value) {
              //     setState(() {
              //       _selectedValue = value;
              //     });
              //   },
              // ),

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
      chooseFile();
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AudioUploaderScreen()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GenderCla()));
    }
  }

}
