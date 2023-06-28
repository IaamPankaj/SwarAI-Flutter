import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter_sound/public/util/flutter_sound_helper.dart';
import 'package:swar_ai/components/AudioPlayerComponent.dart';
import 'package:swar_ai/components/AudioPlayerWidget.dart';
import 'package:swar_ai/components/MicButton.dart';
import 'package:swar_ai/components/MicButtonSpeaker.dart';
import 'package:swar_ai/constants/constants.dart';
import 'package:swar_ai/constants/utils.dart';
import 'package:swar_ai/screens/AudioUploaderScreen.dart';
import 'package:swar_ai/screens/apirequest.dart';

class SpeakerRec extends StatefulWidget {
  @override
  _SpeakerRecState createState() => _SpeakerRecState();
}

class _SpeakerRecState extends State<SpeakerRec> {
  int _selectedIndex = 0;

  int _selectedTab = 0;

  String output = 'Your output will be displayed here';

  String audio_file = "";

  int audioCount = 0;

  final _nameController = TextEditingController();

  List<String> audioFiles = [];

  int currentSec = 0;

  AlertDialog alert = AlertDialog(
    content: Row(children: [
      CircularProgressIndicator(
        backgroundColor: Colors.red,
      ),
      Container(margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
    ]),
  );

  apicallupload() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
    try {
      // print('------------------------ ${file}');
      print("-------------");
      print(
          "_filePath_filePath_filePath_filePath ${await getStringLocal('access')}");

      ApiService apiService = ApiService();
      final url = apiUrl + addSpeaker;
      final headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer ${await getStringLocal('access')}",
      };
      final body = {"name": _nameController?.text?.toString()};

      final response =
          await apiService.uploadAudioFiles(url, audioFiles, headers, body);

      if (response == 200) {
        showToast("Files uploaded successfully");
        setState(() {
          audioFiles = [];
          audioCount = 0;
          _nameController.text = "";
          _selectedTab = 0;
        });
      } else {
        showToast("Something went wrong while file uploading...");
      }

      Navigator.pop(context);
    } catch (e) {
      print(e);
      Navigator.pop(context);
    }
  }

  void openFilePicker() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.audio,
      );
      if (result != null) {
        List<String?> files = result.paths;
        audioFiles =
            files.where((file) => file != null).cast<String>().toList();
        setState(() {
          // Update UI with selected files
        });
      }
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  void startTimer() {
    int duration = 30; // Duration in seconds
    int elapsedSeconds = 0;
    Timer.periodic(Duration(seconds: 1), (timer) {
      elapsedSeconds++;
      if (elapsedSeconds >= duration) {
        timer.cancel(); // Stop the timer
        onTimerFinished(); // Call the callback function
      }
    });
  }

  void onTimerFinished() {
    // This function is called when the timer finishes
    print('Timer finished!');
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

  Future<List<String>?> chooseFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['wav'],
      allowMultiple: true,
    );
    if (result != null) {
      List<String?> filePaths = result.paths;
      List<String> validFiles = [];
      for (String? filePath in filePaths) {
        File file = File(filePath!);
        if (await file.exists()) {
          List<int> bytes = await file.readAsBytes();
          int duration = getDurationFromBytes(bytes);
          if (duration <= 30 * 1000) {
            validFiles.add(filePath);
            print(
                'File $filePath is too short (duration: ${duration / 1000} seconds)');
          } else {
            showToast(
                'File $filePath is too big (duration: ${duration / 1000} seconds)');
            print(
                'File $filePath is too big (duration: ${duration / 1000} seconds)');
          }
        } else {
          print('File $filePath does not exist');
        }
      }
      setState(() {
        audioFiles = validFiles;
        audioCount = validFiles.length;
      });
      return validFiles;
    } else {
      // User canceled the picker
      return null;
    }
  }

  int getDurationFromBytes(List<int> bytes) {
    // Check the RIFF header of the WAV file
    if (bytes.length >= 44 &&
        bytes[0] == 0x52 &&
        bytes[1] == 0x49 &&
        bytes[2] == 0x46 &&
        bytes[3] == 0x46) {
      int fileSize = bytes[4] | bytes[5] << 8 | bytes[6] << 16 | bytes[7] << 24;
      int waveHeader =
          bytes[8] | bytes[9] << 8 | bytes[10] << 16 | bytes[11] << 24;
      int fmtHeader =
          bytes[12] | bytes[13] << 8 | bytes[14] << 16 | bytes[15] << 24;
      int dataHeader =
          bytes[36] | bytes[37] << 8 | bytes[38] << 16 | bytes[39] << 24;
      int dataSize =
          bytes[40] | bytes[41] << 8 | bytes[42] << 16 | bytes[43] << 24;
      int sampleRate =
          bytes[24] | bytes[25] << 8 | bytes[26] << 16 | bytes[27] << 24;
      int numChannels = bytes[22] | bytes[23] << 8;
      int bitsPerSample = bytes[34] | bytes[35] << 8;
      if (waveHeader == 0x57415645 &&
          fmtHeader == 0x666d7420 &&
          dataHeader == 0x64617461) {
        int numSamples = dataSize ~/ (bitsPerSample ~/ 8 * numChannels);
        int duration = (numSamples / sampleRate * 1000).toInt();
        return duration;
      }
    }
    return 0;
  }

  //
  // chooseFile () async {
  //
  //   try {
  //     FilePickerResult? result = await FilePicker.platform.pickFiles(
  //       allowMultiple: true,
  //       type: FileType.audio,
  //     );
  //     if (result != null) {
  //       List<String?> files = result.paths;
  //       List<String> validFiles = [];
  //       for (String? file in files) {
  //         if (file != null) {
  //           File audioFile = File(file);
  //           // if (audioFile.lengthSync() <= 30 * 1024 * 1024 &&
  //           //     await FlutterSoundHelper(audioFile.path) <= 30000) {
  //           //   validFiles.add(file);
  //           //   if (validFiles.length == 10) {
  //           //     break;
  //           //   }
  //           // }
  //         }
  //       }
  //       audioFiles = validFiles;
  //       setState(() {
  //         // Update UI with selected files
  //       });
  //     }
  //   } on Exception catch (e) {
  //     print(e.toString());
  //   }
  //
  //
  //   // FilePickerResult? result = await FilePicker.platform.pickFiles();
  //   //
  //   // if (result != null) {
  //   //
  //   //   print('pppppppppppp ${result.files.single.path}');
  //   //
  //   //   // setState(() {
  //   //   //   file_url=result.files.single.path;
  //   //   // });
  //   //
  //   //   // apicall(result.files.single.path);
  //   //   apicallupload();
  //   //
  //   //   // File? files = File(result?.files?.single?.path);
  //   // } else {
  //   //   // User canceled the picker
  //   // }
  //
  // }

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
      final url = apiUrl + recognizeSpeaker;
      final headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer ${await getStringLocal('access')}",
      };
      final body = {"": ""};

      final response = await apiService.uploadFileWithParamsAndHeaders(
          url, _recordingFilePath!, body, headers);

      print(
          "responseresponseresponseresponse ${response.statusCode} ${response.body}");
      if (response.statusCode == 200) {
        Map<String, dynamic> map = json.decode(response.body);
        setState(() {
          output = map['message'];
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

  List<AudioPlayer> _players = [
    AudioPlayer(),
    AudioPlayer(),
    AudioPlayer(),
  ];
  List<String> _urls = [
    'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
    'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
    'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
  ];

  final Map<int, Widget> myTabs = const <int, Widget>{
    0: Text('  Recognize  '),
    1: Text('Train'),
  };

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      if (_selectedTab == 0) {
        chooseFile();
      } else {
        chooseFiles();
      }
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AudioUploaderScreen()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SpeakerRec()));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _players.forEach((player) {
      player.stop();
      player.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Speech Recognition'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[


            cupertino.CupertinoSegmentedControl(
              children: myTabs,
              groupValue: _selectedTab,
              onValueChanged: (int value) {
                setState(() {
                  this._selectedTab = value;
                });

                print(value);
                // Do something when a tab is selected
              },
            ),

            SizedBox(height: 20.0),

            this._selectedTab == 1
                ? Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          filled: true,
                          fillColor: Colors
                              .grey[300], // set the background color to grey
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        // decoration: InputDecoration(
                        //   labelText: 'Email',
                        // ),
                        validator: (value) {
                          if (value == "") {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  )
                : SizedBox(
                    height: 0,
                  ),

            this._selectedTab == 0
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    child:

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
                            child:  Container(
                                padding: EdgeInsets.all(20),
                                child: Text(output, style: TextStyle( color: Colors.black87, fontStyle: FontStyle.italic),)),

                          ),



                          Row(
                            children: [

                              IconButton(
                                icon: Icon(Icons.refresh_outlined, color: Color(0xff2096f3)),
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




              // Card(
                    //   elevation: 10,
                    //   child: Column(
                    //     children: [
                    //       Padding(
                    //         padding: EdgeInsets.all(16.0),
                    //         child: Text(output),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    //



                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: audioFiles.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                            elevation: 5,
                            child: AudioPlayerWidgetCommon(
                                url: audioFiles[index]));
                      },
                    ),
                  ),

            // Spacer(),

            this._selectedTab == 1 && audioCount > 9
                ? OutlinedButton(
                    onPressed: () {
                      apicallupload();
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
                      child: Text('Upload'),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(width: 2.0, color: Colors.red),
                    ),
                  )
                : this._selectedTab == 0
                    ? Spacer()
                    : Text(""),

            _selectedTab == 0
                ? MicButton(
                    onDataChanged: (value) {
                      if (_selectedTab == 0) {
                        apicall(value);
                      } else {
                        if (audioFiles.length == 10) {
                          showToast("You have reached to maximum");
                        } else {
                          audioFiles.add(value);
                        }
                        setState(() {
                          audioCount = audioCount + 1;
                        });
                      }
                      // Update the data in the parent widget when the data changes in the child widget
                      setState(() {
                        audio_file = value;
                      });
                    },
                  )
                :

                audioCount != 10 ?

            MicButtonSpeaker(
                    onDataChanged: (value) {
                      if (_selectedTab == 0) {
                        apicall(value);
                      } else {
                        if (audioFiles.length == 10) {
                          showToast("You have reached to maximum");
                        } else {
                          audioFiles.add(value);
                        }
                        setState(() {
                          audioCount = audioCount + 1;
                        });
                      }
                      // Update the data in the parent widget when the data changes in the child widget
                      setState(() {
                        audio_file = value;
                      });
                    },
                    onTimeChanged: (value) {
                      if (value == 31) {
                        setState(() {
                          currentSec = 0;
                        });
                      } else {
                        setState(() {
                          currentSec = value;
                        });
                      }
                    },
                  )
            :
            SizedBox(height: 0,),


            _selectedTab == 1 ?

            currentSec > 0
                ? Text(currentSec.toString())
                : Text( audioCount == 10 ? '' : 'Please record/upload 10 audio files each 30 seconds.')

                : SizedBox(height: 0,)


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
}

// import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart';
//
// void main() => runApp(SpeakerRec());
//
// class SpeakerRec extends StatelessWidget {
//   final List<String> audioFiles = [
//     "https://example.com/audio1.mp3",
//     "https://example.com/audio2.mp3",
//     "https://example.com/audio3.mp3",
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Speech Recognition',
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Speech Recognition'),
//         ),
//         body: ListView.builder(
//           itemCount: audioFiles.length,
//           itemBuilder: (BuildContext context, int index) {
//             return AudioPlayerWidget(audioFiles[index]);
//           },
//         ),
//       ),
//     );
//   }
// }

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
  String completeTime = "0:30";
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
    return Card(
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
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: stop,
          ),
        ],
      ),
    );
  }
}
