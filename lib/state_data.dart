import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:shared_preferences/shared_preferences.dart';

enum TypeParagraph {
  titre,
  sousTitre,
  centerTitre,
  centerSousTitre,
  texte,
  ayah,
  hadith,
  erreur
}

TypeParagraph convertirEnEnum(String valeur) {
  return TypeParagraph.values.firstWhere(
    (element) => element.toString() == 'TypeParagraph.$valeur',
    orElse: () => TypeParagraph.erreur,
  );
}

class Data {
  final int kitab;
  final int page;
  final TypeParagraph type;
  final bool newLine;
  final String paragraph;

  const Data({
    required this.kitab,
    required this.page,
    required this.type,
    required this.newLine,
    required this.paragraph,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      kitab: json['kitab'] as int,
      page: json['page'],
      type: convertirEnEnum(json['type']),
      newLine: json['newLine'],
      paragraph: json['paragraph'],
    );
  }
}

List<Data> loadData(jsonString) {
  final jsonData = json.decode(jsonString);
  final objets = List<Data>.from(jsonData.map((json) => Data.fromJson(json)));
  return objets;
}

final dataProvider = FutureProvider<List<Data>>((ref) async {
  final jsonString = await rootBundle.loadString('data/data.json');
  return compute(loadData, jsonString);
});
/*
final savedBookmarkFromSharedPref = FutureProvider<int>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  int? bookmark = prefs.getInt('mushaf01_bookmark');

  if (bookmark != null) {
    return bookmark;
  } else {
    return 0;
  }
});
*/

final filePathProvider = StateProvider<String>(
  (ref) {
    return "/MP3/01_01.mp3";
  },
);

final playerProvider = ChangeNotifierProvider<AudioPlayerController>(
  (ref) {
    //final filePath = ref.watch(filePathProvider);
    return AudioPlayerController(/*filePath*/);
  },
);

class AudioPlayerController extends ChangeNotifier {
  late AudioPlayer audioPlayer;
  late Duration duration;
  late Duration position;
  PlayerState playerState = PlayerState.stopped;

  double volume = 1.0;
  bool fileRead = false;

  AudioPlayerController() {
    //AudioLogger.logLevel = AudioLogLevel.none;

    audioPlayer = AudioPlayer();
    audioPlayer.setReleaseMode(ReleaseMode.stop);

    position = const Duration(
      hours: 0,
      minutes: 0,
      seconds: 0,
    );
    duration = const Duration(
      hours: 0,
      minutes: 0,
      seconds: 0,
    );
    audioPlayer.onDurationChanged.listen((Duration d) {
      duration = d;
      notifyListeners();
    });

    audioPlayer.onPositionChanged.listen((Duration p) {
      position = p;
      notifyListeners();
    });

    audioPlayer.onPlayerStateChanged.listen((PlayerState s) {
      playerState = s;
      notifyListeners();
    });
  }

  Future<void> setSource(String filePath) async {
    String path = (await getApplicationDocumentsDirectory()).absolute.path;

    File file = File("$path$filePath");
    if (file.existsSync()) {
      audioPlayer.setSourceDeviceFile(file.path);
      fileRead = true;
    } else {
      fileRead = false;
    }
  }

  Future<void> play() async {
    (fileRead) ? await audioPlayer.resume() : null;
  }

  Future<void> pause() async {
    await audioPlayer.pause();
  }

  Future<void> stop() async {
    await audioPlayer.stop();
  }

  Future<void> release() async {
    await audioPlayer.release();
  }

  Future<void> seek(Duration d) async {
    await audioPlayer.seek(
      d,
    );
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
}
