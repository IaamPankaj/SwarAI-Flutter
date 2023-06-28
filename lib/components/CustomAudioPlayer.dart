import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class CustomAudioPlayer extends StatefulWidget {
  final String audioPath;

  CustomAudioPlayer({required this.audioPath});

  @override
  _CustomAudioPlayerState createState() => _CustomAudioPlayerState();
}

class _CustomAudioPlayerState extends State<CustomAudioPlayer> {
  final player = AudioPlayer();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _loadAudio();
  }

  void _loadAudio() async {
    if (widget.audioPath.startsWith('http')) {
      await player.setUrl(widget.audioPath);
    } else {
      await player.setFilePath(widget.audioPath);
    }
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        player.play();
      } else {
        player.pause();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
          onPressed: _togglePlayPause,
        ),
        StreamBuilder<Duration?>(
          stream: player.durationStream,
          builder: (context, snapshot) {
            final duration = snapshot.data ?? Duration.zero;
            return StreamBuilder<Duration>(
              stream: player.positionStream,
              builder: (context, snapshot) {
                var position = snapshot.data ?? Duration.zero;
                if (position > duration) {
                  position = duration;
                }
                return Slider(
                  value: position.inMilliseconds.toDouble(),
                  onChanged: (value) {
                    player.seek(Duration(milliseconds: value.toInt()));
                  },
                  max: duration.inMilliseconds.toDouble(),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
