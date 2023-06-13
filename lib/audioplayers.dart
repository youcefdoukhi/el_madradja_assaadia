import 'package:audioplayers/audioplayers.dart';
import 'package:el_madradja_assaadia/state_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class MyAudioPlayer extends ConsumerWidget {
  const MyAudioPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioPlayer = ref.watch(playerProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(0),
          child: Slider(
            activeColor: const Color.fromARGB(255, 212, 180, 124),
            inactiveColor: const Color.fromARGB(220, 54, 56, 89),
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
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  (audioPlayer.playerState != PlayerState.playing
                      ? IconButton(
                          icon: const Icon(Icons.play_circle),
                          color: const Color.fromARGB(255, 212, 180, 124),
                          onPressed: () {
                            audioPlayer.play();
                          },
                        )
                      : IconButton(
                          icon: const Icon(Icons.pause_circle),
                          color: const Color.fromARGB(255, 212, 180, 124),
                          onPressed: () {
                            audioPlayer.pause();
                          },
                        )),
                  IconButton(
                    icon: const Icon(Icons.volume_up),
                    color: const Color.fromARGB(255, 212, 180, 124),
                    onPressed: () {
                      audioPlayer.volumeUp();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.volume_down),
                    color: const Color.fromARGB(255, 212, 180, 124),
                    onPressed: () {
                      audioPlayer.volumeDown();
                    },
                  ),
                ],
              ),
              Expanded(
                child: Container(),
              ),
              Container(
                margin: const EdgeInsets.only(
                  left: 10,
                ),
                child: Text(
                  "${DateFormat('HH:mm:ss').format(DateTime(0).add(audioPlayer.duration))}/${DateFormat('HH:mm:ss').format(DateTime(0).add(audioPlayer.position))}",
                  style: const TextStyle(
                    color: Color.fromARGB(255, 212, 180, 124),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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