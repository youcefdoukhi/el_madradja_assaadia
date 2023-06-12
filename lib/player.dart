import 'package:el_madradja_assaadia/state_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AudioPlayerExemple2 extends ConsumerStatefulWidget {
  const AudioPlayerExemple2({super.key});

  @override
  AudioPlayerState createState() => AudioPlayerState();
}

class AudioPlayerState extends ConsumerState<AudioPlayerExemple2> {
  late AudioPlayerController audioPlayer;
  @override
  void initState() {
    super.initState();
    audioPlayer = ref.read(playerProvider);
  }

  @override
  void dispose() {
    audioPlayer.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //audioPlayer.setSource("/MP3/01_02.mp3");

    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Player'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.play_circle),
              tooltip: 'Play',
              onPressed: () {
                audioPlayer.play();
              },
            ),
            IconButton(
              icon: const Icon(Icons.pause_circle),
              tooltip: 'Pause',
              onPressed: () {
                audioPlayer.pause();
              },
            ),
            IconButton(
              icon: const Icon(Icons.next_plan),
              tooltip: 'Seek',
              onPressed: () {
                audioPlayer.seek(const Duration(
                  milliseconds: 50000,
                ));
              },
            ),
            IconButton(
              icon: const Icon(Icons.volume_up),
              tooltip: '+',
              onPressed: () {
                audioPlayer.volumeUp();
              },
            ),
            IconButton(
              icon: const Icon(Icons.volume_down),
              tooltip: '-',
              onPressed: () {
                audioPlayer.volumeDown();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MyAudioPlayer {
  static final MyAudioPlayer _singleton = MyAudioPlayer._internal();

  factory MyAudioPlayer() {
    return _singleton;
  }

  MyAudioPlayer._internal();
}
