import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:http/http.dart' as http;
import 'package:swar_ai/constants/constants.dart';
import 'package:swar_ai/constants/utils.dart';
import 'package:swar_ai/screens/apirequest.dart';

class MicButtonSpeaker extends StatefulWidget {

  final ValueChanged<String> onDataChanged;
  final ValueChanged<int> onTimeChanged;
  MicButtonSpeaker({required this.onDataChanged, required this.onTimeChanged});

  // const MicButton({Key? key}) : super(key: key);

  @override
  _MicButtonSpeakerState createState() => _MicButtonSpeakerState();
}

class _MicButtonSpeakerState extends State<MicButtonSpeaker> {
  String _recordingFilePath = '';
  bool _isRecording = false;
  late Record _recorder;

  String recordedText = "Click to start";

  @override
  void initState() {
    super.initState();
    _initRecorder();
  }

  void startTimer() {
    int duration = 31; // Duration in seconds
    int elapsedSeconds = 0;
    Timer.periodic(Duration(seconds: 1), (timer) {
      elapsedSeconds++;
      if(!_isRecording) {
        timer.cancel();
        this.widget.onTimeChanged(0);
      } else {
        this.widget.onTimeChanged(elapsedSeconds);
        // Stop the timer
      }
      if (elapsedSeconds >= duration) {
        if(!!_isRecording) {
          timer.cancel();
        }// Stop the timer
        onTimerFinished(); // Call the callback function
      }
    });
  }

  void onTimerFinished() {
    // This function is called when the timer finishes
    print('Timer finished!');

    _stopRecording();

  }


  Future<void> _initRecorder() async {
    _recorder = Record();
    _recorder.isEncoderSupported(AudioEncoder.wav);
    await _recorder.isRecording();
  }

  Future<void> _toggleRecording() async {
    if (!_isRecording) {
      await _startRecording();
      setState(() {
        recordedText = "Click to stop";
      });
    } else {
      await _stopRecording();
      setState(() {
        recordedText = "Click to start";
      });
    }
  }

  Future<void> _startRecording() async {
    startTimer();
    try {
      if (await _recorder.hasPermission()) {
        final Directory appDirectory = await getApplicationDocumentsDirectory();
        final String filePath = '${appDirectory.path}/${DateTime.now().millisecondsSinceEpoch.toString()}.wav';
        // await _recorder.isEncoderSupported(AudioEncoder.wav);
        await _recorder.start(
          path: filePath,
          encoder: AudioEncoder.wav,
        );

        print("objectobjectobjectobject12345");

        setState(() {
          _recordingFilePath = filePath;
          _isRecording = true;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _stopRecording() async {
    try {
      await _recorder.stop();
      setState(() {
        _isRecording = false;
      });

      this.widget.onDataChanged(_recordingFilePath);


    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleRecording,
      child:

      Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xff2096f3),
              border: Border.all(
                color: Color(0xff2096f3),
                width: 2,
              ),

              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Icon(
              _isRecording ? Icons.mic_off : Icons.mic,
              size: 48.0, color: Colors.white,
            ),
          ),
          Text(recordedText, style: TextStyle(color: Colors.black87, fontStyle: FontStyle.italic),),
        ],
      ),

      // Icon(
      //   _isRecording ? Icons.stop : Icons.mic,
      //   size: 48.0,
      // ),
    );
  }
}