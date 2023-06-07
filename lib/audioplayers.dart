import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class AudioPlayerExample extends StatefulWidget {
  const AudioPlayerExample({super.key});

  @override
  AudioPlayerExampleState createState() => AudioPlayerExampleState();
}

class AudioPlayerExampleState extends State<AudioPlayerExample> {
  late AudioPlayer audioPlayer;
  late String audioPath;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    initialiserVariableAsynchrone();
  }

  Future<void> initialiserVariableAsynchrone() async {
    String path = (await getApplicationDocumentsDirectory()).absolute.path;
    String filePath = "$path/MP3/01_01.mp3";
    File file = File(filePath);
    if (file.existsSync()) {
      setState(() {
        audioPath = filePath;
      });
      audioPlayer.setSourceDeviceFile(audioPath);
    } else {}
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  void playAudio() async {
    await audioPlayer.play(DeviceFileSource(audioPath));
  }

  void pauseAudio() async {
    await audioPlayer.pause();
  }

  void stopAudio() async {
    await audioPlayer.stop();
  }

  void seekAudio() async {
    await audioPlayer.seek(const Duration(seconds: 120));
  }

  void releaseAudio() async {
    await audioPlayer.release();
  }

  void disposeAudio() async {
    await audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                playAudio();
              },
            ),
            IconButton(
              icon: const Icon(Icons.pause_circle),
              tooltip: 'Pause',
              onPressed: () {
                pauseAudio();
              },
            ),
            IconButton(
              icon: const Icon(Icons.stop_circle),
              tooltip: 'Stop',
              onPressed: () {
                stopAudio();
              },
            ),
            IconButton(
              icon: const Icon(Icons.next_plan),
              tooltip: 'Seek',
              onPressed: () {
                seekAudio();
              },
            ),
            IconButton(
              icon: const Icon(Icons.clear_sharp),
              tooltip: 'Release',
              onPressed: () {
                releaseAudio();
              },
            ),
            /* IconButton(
              icon: const Icon(Icons.clear_all),
              tooltip: 'Dispose',
              onPressed: () {
                disposeAudio();
              },
            ),*/
            IconButton(
              icon: const Icon(Icons.add_circle),
              tooltip: '+',
              onPressed: () {},
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

  late AudioPlayer _audioPlayer;
  MyAudioPlayer._internal() {
    _audioPlayer = AudioPlayer();
  }

  void play(Source src) {
    _audioPlayer.play(src);
  }

  void pause() {
    _audioPlayer.pause();
  }

  void stop() {
    _audioPlayer.stop();
  }

  void release(String url) {
    _audioPlayer.release();
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
