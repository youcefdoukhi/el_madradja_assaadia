import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class MyAudioPlayer2 extends StatefulWidget {
  const MyAudioPlayer2({super.key, required this.kitab, required this.dars});
  final int kitab;
  final int dars;
  @override
  State<MyAudioPlayer2> createState() => MyAudioPlayer2State();
}

class MyAudioPlayer2State extends State<MyAudioPlayer2> {
  late final AudioPlayer audioPlayer;
  Duration position = const Duration(
    hours: 0,
    minutes: 0,
    seconds: 0,
  );
  Duration duration = const Duration(
    hours: 0,
    minutes: 0,
    seconds: 0,
  );
  PlayerState playerState = PlayerState.stopped;
  double volume = 0.8;

  @override
  void initState() {
    super.initState();

    audioPlayer =
        AudioPlayer(playerId: "PlayerID:${widget.kitab}_${widget.dars}");
    audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        duration = d;
      });
    });

    audioPlayer.onPositionChanged.listen((Duration p) {
      setState(() {
        position = p;
      });
    });

    audioPlayer.onPlayerStateChanged.listen((PlayerState s) {
      playerState = s;
    });
    audioPlayer.setVolume(volume);
    setSource();
  }

  Future<void> setSource() async {
    String path = (await getApplicationDocumentsDirectory()).absolute.path;

    String filePath = "/MP3/";
    if (widget.kitab < 10) {
      filePath = "${filePath}0${widget.kitab}_";
    } else {
      filePath = "$filePath${widget.kitab}_";
    }

    if (widget.dars < 10) {
      filePath = "${filePath}0${widget.dars + 1}.mp3";
    } else {
      filePath = "$filePath${widget.dars + 1}.mp3";
    }

    File file = File("$path$filePath");
    if (file.existsSync()) {
      audioPlayer.setSourceDeviceFile(file.path);
    } else {
      //print("\n FILE NOT FOUND !!!!!!!");
    }
  }

  Future<void> volumeUp() async {
    if (volume < 1.0) {
      volume = volume + 0.1;
      await audioPlayer.setVolume(volume);
    }
  }

  Future<void> volumeDown() async {
    if (volume > 0.0) {
      volume = volume - 0.1;
      await audioPlayer.setVolume(volume);
    }
  }

  @override
  void dispose() {
    audioPlayer.release();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(0),
          child: Slider(
            activeColor: const Color.fromARGB(255, 212, 180, 124),
            inactiveColor: const Color.fromARGB(220, 54, 56, 89),
            value: position.inSeconds.toDouble(),
            min: 0.0,
            max: duration.inSeconds.toDouble(),
            onChanged: (newValue) {
              setState(() {
                position = Duration(seconds: newValue.toInt());
              });
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
                  (playerState != PlayerState.playing
                      ? IconButton(
                          icon: const Icon(Icons.play_circle),
                          color: const Color.fromARGB(255, 212, 180, 124),
                          onPressed: () {
                            audioPlayer.resume();
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
                      volumeUp();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.volume_down),
                    color: const Color.fromARGB(255, 212, 180, 124),
                    onPressed: () {
                      volumeDown();
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
                  "${DateFormat('HH:mm:ss').format(DateTime(0).add(duration))}/${DateFormat('HH:mm:ss').format(DateTime(0).add(position))}",
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