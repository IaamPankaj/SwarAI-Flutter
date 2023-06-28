import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class AudioRecorder extends StatefulWidget {
  @override
  _AudioRecorderState createState() => _AudioRecorderState();
}

class _AudioRecorderState extends State<AudioRecorder> {
  bool _isRecording = false;
  late String _audioPath;
  late Timer _timer;
  int _duration = 0;
  Record _record = Record();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(_isRecording ? Icons.stop : Icons.mic),
              onPressed: () {
                if (_isRecording) {
                  _stopRecording();
                } else {
                  _startRecording();
                }
              },
            ),
          ],
        ),
        if (_isRecording)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text('Recording... $_duration seconds'),
          ),
      ],
    );
  }

  Future<void> _startRecording() async {
    try {
      String audioPath = await getApplicationDocumentsDirectory().then((dir) {
        return '${dir.path}/audio.wav';
      });

      await _record.start(path: audioPath);
      setState(() {
        _isRecording = true;
        _audioPath = audioPath;
        _duration = 0;
        _timer = Timer.periodic(Duration(seconds: 1), (timer) {
          setState(() {
            _duration = timer.tick;
          });
        });
      });
    } catch (e) {
      print('Error starting recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      await _record.stop();
      setState(() {
        _isRecording = false;
        _timer.cancel();
      });
      await _uploadAudio();
    } catch (e) {
      print('Error stopping recording: $e');
    }
  }

  Future<void> _uploadAudio() async {
    File audioFile = File(_audioPath);
    var request = http.MultipartRequest('POST', Uri.parse('your_api_url'));
    request.files.add(await http.MultipartFile.fromPath('audio', _audioPath));
    var response = await request.send();
    if (response.statusCode == 200) {
      print('Audio uploaded successfully');
    } else {
      print('Error uploading audio: ${response.reasonPhrase}');
    }
  }
}
