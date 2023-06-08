import 'package:el_madradja_assaadia/state_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AudioPlayerExample extends ConsumerWidget {
  const AudioPlayerExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioPlayer = ref.read(playerProvider);

    audioPlayer.setSource("/MP3/01_01.mp3");

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
                audioPlayer.seek(0, 0, 50);
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
