import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerWidgetCommon extends StatefulWidget {
  final String url;

  const AudioPlayerWidgetCommon({required this.url});

  @override
  _AudioPlayerWidgetCommonState createState() => _AudioPlayerWidgetCommonState();
}

class _AudioPlayerWidgetCommonState extends State<AudioPlayerWidgetCommon> {
  AudioPlayer _audioPlayer = AudioPlayer();
  // PlayerState _audioPlayerState = AudioPlayerState.STOPPED;
  PlayerState _audioPlayerState = PlayerState.stopped;

  Duration _duration = Duration();
  Duration _position = Duration();
  String _error = '';

  bool isPlayingNow = false;

  @override
  void initState() {
    super.initState();

    _audioPlayer.onPlayerStateChanged.listen((state) {

      if(state == PlayerState.completed) {
        setState(() {
          isPlayingNow = false;

        });
      }
      setState(() {
        _audioPlayerState = state;
      });
    });

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

    // _audioPlayer.onPlayerError.listen((error) {
    //   setState(() {
    //     _error = error;
    //   });
    // });

    // _play();
  }

  Future<void> _play() async {
    _pause();
    // await _audioPlayer.play(widget.url);
    UrlSource source = UrlSource(widget.url);
    // AudioSource source = AudioSource.uri(Uri.parse(widget.url));
    await _audioPlayer.play(source);
    setState(() {
      isPlayingNow = true;
    });
  }

  Future<void> _pause() async {
    await _audioPlayer.pause();
    setState(() {
      isPlayingNow = false;
    });
  }

  Future<void> _stop() async {
    await _audioPlayer.stop();
    setState(() {
      isPlayingNow = false;
    });
  }

  @override
  void dispose() {
    _audioPlayer.release();
    super.dispose();
  }

  String _getDurationString(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    // if(_position.inMilliseconds.toDouble() == _duration.inMilliseconds.toDouble()) {
    //   setState(() {
    //     isPlayingNow = false;
    //   });
    // }

    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              !isPlayingNow ?

              IconButton(
                icon: Icon(Icons.play_arrow),
                onPressed: _audioPlayerState == PlayerState.playing ? null : _play,
              )
              :
              IconButton(
                icon: Icon(Icons.pause),
                onPressed: _audioPlayerState == PlayerState.paused ? null : _pause,
              ),


              IconButton(
                icon: Icon(Icons.stop),
                onPressed: _stop,
              ),
            ],
          ),
          Slider(
            value: _position.inMilliseconds.toDouble(),
            max: _duration.inMilliseconds.toDouble(),
            onChanged: (double value) {
              setState(() {
                _audioPlayer.seek(Duration(milliseconds: value.toInt()));
              });
            },
          ),
          Text(
            _getDurationString(_position),
            // _getDurationString(_position) + "/" + _getDurationString(_duration),
            style: TextStyle(fontSize: 10.0),
          ),
          Text(_error),
        ],
      );
  }
}
