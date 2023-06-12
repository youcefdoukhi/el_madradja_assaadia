import 'package:audioplayers/audioplayers.dart';
import 'package:el_madradja_assaadia/state_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AudioPlayer extends ConsumerWidget {
  const AudioPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioPlayer = ref.watch(playerProvider);

    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(
            //height: 50,
            //color: Colors.red,
            child: Slider(
              value: (audioPlayer.position.inSeconds.toDouble() <=
                      audioPlayer.duration.inSeconds.toDouble()
                  ? audioPlayer.position.inSeconds.toDouble()
                  : audioPlayer.duration.inSeconds.toDouble()),
              min: 0.0,
              max: audioPlayer.duration.inSeconds.toDouble(),
              onChanged: (newValue) {
                ref.read(playerProvider).position = Duration(
                  seconds: newValue.toInt(),
                );
              },
              onChangeEnd: (newValue) {
                audioPlayer.seek(
                  Duration(
                    seconds: newValue.toInt(),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            //height: 50,
            //color: Colors.green,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    right: 10,
                  ),
                  //color: Colors.grey,
                  child: Row(
                    children: [
                      (audioPlayer.playerState != PlayerState.playing
                          ? IconButton(
                              icon: const Icon(Icons.play_circle),
                              tooltip: 'Play',
                              onPressed: () {
                                audioPlayer.play();
                              },
                            )
                          : IconButton(
                              icon: const Icon(Icons.pause_circle),
                              tooltip: 'Pause',
                              onPressed: () {
                                audioPlayer.pause();
                              },
                            )),
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
                Expanded(
                  child: Container(),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    left: 10,
                  ),
                  //color: Colors.yellow,
                  child: Text(
                      "${DateFormat('HH:mm:ss').format(DateTime(0).add(audioPlayer.duration))}/${DateFormat('HH:mm:ss').format(DateTime(0).add(audioPlayer.position))}"),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.square_foot),
            tooltip: '',
            onPressed: () async {
              await ref.read(playerProvider).setSource("/MP3/01_01.mp3");
            },
          ),
          IconButton(
            icon: const Icon(Icons.change_circle),
            tooltip: '',
            onPressed: () async {
              await ref.read(playerProvider).setSource("/MP3/01_02.mp3");
            },
          ),
        ],
      ),
    );
  }
}
/*
class MyAudioPlayer {
  static final MyAudioPlayer _singleton = MyAudioPlayer._internal();

  factory MyAudioPlayer() {
    return _singleton;
  }

  MyAudioPlayer._internal();
}
*/