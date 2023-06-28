import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:http/http.dart' as http;
import 'package:swar_ai/constants/constants.dart';
import 'package:swar_ai/constants/utils.dart';
import 'package:swar_ai/screens/apirequest.dart';

class MicButton extends StatefulWidget {

  final ValueChanged<String> onDataChanged;
  MicButton({required this.onDataChanged});

  // const MicButton({Key? key}) : super(key: key);

  @override
  _MicButtonState createState() => _MicButtonState();
}

class _MicButtonState extends State<MicButton> {
  String _recordingFilePath = '';
  bool _isRecording = false;
  late Record _recorder;

  String recordedText = "Click to start";

  @override
  void initState() {
    super.initState();
    _initRecorder();
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
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],

              shape: BoxShape.circle,
              color: Color(0xff2096f3),
              border: Border.all(
                color: Color(0xff2096f3),
                width: 2,
              ),
            ),
            child: Icon(
              _isRecording ? Icons.mic_off : Icons.mic,
              size: 48.0, color: Colors.white,
            ),
          ),
          Text(recordedText, style: TextStyle(color: Colors.black87, fontStyle: FontStyle.italic),),
        ],
      ),





    );
  }
}