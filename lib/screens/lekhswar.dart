import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:swar_ai/components/AudioPlayerComponent.dart';
import 'package:swar_ai/components/AudioPlayerWidget.dart';
import 'package:swar_ai/components/CustomAudioPlayer.dart';
import 'package:swar_ai/constants/constants.dart';
import 'package:swar_ai/constants/utils.dart';
import 'package:swar_ai/screens/AudioUploaderScreen.dart';
import 'package:swar_ai/screens/apirequest.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class LekhSwar extends StatefulWidget {
  @override
  _LekhSwarState createState() => _LekhSwarState();
}

class _LekhSwarState extends State<LekhSwar> {
  int _selectedIndex = 0;

  String selectedFromLanguage = "-";
  String selectedToLanguage = "-";

  String _inputText = '';

  TextEditingController _inputTextController = TextEditingController();


  String audio_file = '';

  AlertDialog alert = AlertDialog(
    content: Row(children: [
      CircularProgressIndicator(
        backgroundColor: Colors.red,
      ),
      Container(margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
    ]),
  );


  Future<void> _downloadFile() async {
    String fileName = audio_file.split('/').last;
    var request = await http.get(Uri.parse(audio_file));
    var bytes = request.bodyBytes;
    String dir = (await getExternalStorageDirectory())!.path;
    File file = File('$dir/$fileName');
    print('$dir/$fileName');
    await file.writeAsBytes(bytes);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('File downloaded successfully.'),
    ));
  }

  chooseFile () async {

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'txt'],
    );

    if (result != null) {

      File file = File(result.files.single.path!);
      String fileText = await file.readAsString();
      print(fileText);

      setState(() {
        _inputText=fileText;
        _inputTextController.text = fileText;
      });

      print('pppppppppppp ${result.files.single.path}  ${fileText}');

      setState(() {
        // file_url=result.files.single.path;
      });

      // apicall(result.files.single.path!);

      // File? files = File(result?.files?.single?.path);
    } else {
      // User canceled the picker
    }

  }

  apicall(String toLang) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
    try {
      // final file = File(_recordingFilePath);
      // print('------------------------ ${file}');
      print("-------------");
      print(
          "_filePath_filePath_filePath_filePath ${await getStringLocal('access')}");

      ApiService apiService = ApiService();
      final url = apiUrl + lekhswar;
      final headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer ${await getStringLocal('access')}",
      };
      final body = {"input_language": selectedFromLanguage.toString(),"output_language": toLang.toString(),"text": _inputTextController.text.toString()};

      final response = await apiService.postRequest(url, body, headers);

      print("responseresponseresponseresponse ${response.statusCode} ${response.body}");

      if (response.statusCode == 200) {
        Map<String, dynamic> map = json.decode(response.body);
        setState(() {
          audio_file = map['file_url'];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Lekhswar'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 200,
                      child: Card(

                        elevation: 10,

                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:  Color(0xff2096f3), width: 2), //<-- SEE HERE
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff2096f3), width: 2), //<-- SEE HERE
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

                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),

                    child: SizedBox(
                      // height: 200,
                      child: TextField(
                        controller: _inputTextController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 50),
                          // border: Border.all(),
                          hintText: 'Enter text here',

                        ),
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        textDirection: TextDirection.ltr,

                        // decoration: InputDecoration(
                        //   hintText: 'Enter your text here',
                        // ),
                        onChanged: (value) {
                          setState(() {
                            _inputText = value;
                            // _inputTextController.text = value;
                          });
                        },
                      ),
                    ),


                    // child: TextField(
                    //   maxLines: null,
                    //   keyboardType: TextInputType.multiline,
                    //   textInputAction: TextInputAction.newline,
                    //   decoration: InputDecoration(
                    //     hintText: 'Enter your text here',
                    //   ),
                    // ),

                    // child: Column(
                    //   children: [
                    //     SizedBox(
                    //       height: 150.0,
                    //       width: double.infinity,
                    //       child: Center(
                    //         child: Text('Card Content'),
                    //       ),
                    //     ),
                    //     Positioned(
                    //       left: 0.0,
                    //       bottom: 0.0,
                    //       child: Row(
                    //         children: [
                    //           IconButton(
                    //             icon: Icon(Icons.copy),
                    //             onPressed: () {},
                    //           ),
                    //           IconButton(
                    //             icon: Icon(Icons.volume_up_outlined),
                    //             onPressed: () {},
                    //           ),
                    //           IconButton(
                    //             icon: Icon(Icons.cloud_download_outlined),
                    //             onPressed: () {},
                    //           ),
                    //           IconButton(
                    //             icon: Icon(Icons.refresh_outlined),
                    //             onPressed: () {},
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ),
                ],
              ),

              SizedBox(
                height: 20,
              ),


              Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
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
                            apicall(newValue.toString());
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

                          ],
                        ),
                      ),
                    ),
                  ),


                  SizedBox(
                    height: 20,
                  ),




                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
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
                                    audio_file='';
                                  });
                                },
                              ),
                            ],
                          ),

                      ],
                    ),
                  ),





                ],
              ),

            ],
          ),
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
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LekhSwar()));
    }
  }
}





class AudioPlayerWidget extends StatefulWidget {
  final String url;

  AudioPlayerWidget(this.url);

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  String currentTime = "0:00";
  String completeTime = "0:00";
  double sliderValue = 0.0;

  @override
  void initState() {
    super.initState();

    // Listen for state changes
    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    // Listen for audio duration changes
    audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        completeTime = duration.toString().split(".")[0];
      });
    });

    // Listen for audio position changes
    audioPlayer.onPositionChanged.listen((Duration duration) {
      setState(() {
        currentTime = duration.toString().split(".")[0];
        sliderValue = duration.inSeconds.toDouble();
      });
    });
  }

  void play() async {
    await audioPlayer.play(UrlSource(widget.url));
  }

  void pause() async {
    await audioPlayer.pause();
  }

  void stop() async {
    await audioPlayer.stop();
  }

  void seekTo(int second) {
    Duration newDuration = Duration(seconds: second);
    audioPlayer.seek(newDuration);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [

          !isPlaying
              ? IconButton(
            icon: Icon(Icons.play_arrow),
            onPressed: isPlaying ? null : play,
          )
              : IconButton(
            icon: Icon(Icons.pause),
            onPressed: isPlaying ? pause : null,
          ),
          Text(currentTime),
          Text("/"),
          Text(completeTime),

          Slider(
            value: sliderValue,
            min: 0,
            max: 30, //audioPlayer.getDuration().inSeconds.toDouble(),
            onChanged: (double value) {
              setState(() {
                seekTo(value.toInt());
                sliderValue = value;
              });
            },
          ),

          !isPlaying
              ? IconButton(
            icon: Icon(Icons.volume_up_outlined),
            onPressed: isPlaying ? null : play,
          )
              : IconButton(
            icon: Icon(Icons.volume_mute_outlined),
            onPressed: isPlaying ? pause : null,
          ),


          // IconButton(
          //   icon: Icon(Icons.more_vert),
          //   onPressed: stop,
          // ),
        ],
      ),
    );
  }
}
