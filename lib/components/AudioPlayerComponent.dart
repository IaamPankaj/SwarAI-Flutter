import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class AudioPlayerComponent extends StatefulWidget {
  final String? url;
  final File? file;

  const AudioPlayerComponent({Key? key, this.url, this.file}) : super(key: key);

  @override
  _AudioPlayerComponentState createState() => _AudioPlayerComponentState();
}

class _AudioPlayerComponentState extends State<AudioPlayerComponent> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _duration = Duration();
  Duration _position = Duration();

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
      });
    });
    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _position = position;
      });
    });
    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _isPlaying = false;
        _position = Duration();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _audioPlayer.dispose();
  }

  Future<void> _play() async {
    // if (widget.url != null) {
      await _playUrl('https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3');
    // } else if (widget.file != null) {
    //   await _playFile(widget.file!);
    // }
  }

  Future<void> _playUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      final bytes = response.bodyBytes;
      Source sr = UrlSource(url);
      await _audioPlayer.play(sr);
      // await _audioPlayer.playBytes(bytes);
      setState(() {
        _isPlaying = true;
      });
    } catch (e) {
      print('Error playing audio from URL: $e');
    }
  }

  Future<void> _playFile(File file) async {
    try {
      Source sr = UrlSource(file.path);
      await _audioPlayer.play(sr);
      setState(() {
        _isPlaying = true;
      });
    } catch (e) {
      print('Error playing audio from file: $e');
    }
  }

  Future<void> _pause() async {
    await _audioPlayer.pause();
    setState(() {
      _isPlaying = false;
    });
  }

  Future<void> _stop() async {
    await _audioPlayer.stop();
    setState(() {
      _isPlaying = false;
      _position = Duration();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
          onPressed: _isPlaying ? _pause : _play,
        ),
        Slider(
          value: _position.inSeconds.toDouble(),
          min: 0.0,
          max: _duration.inSeconds.toDouble(),
          onChanged: (double value) {
            setState(() {
              _audioPlayer.seek(Duration(seconds: value.toInt()));
            });
          },
        ),
      ],
    );
  }
}
