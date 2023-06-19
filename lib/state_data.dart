import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class Dourous {
  final List<Dars> dorous;

  Dourous({required this.dorous});

  factory Dourous.fromJson(Map<String, dynamic> json) {
    List<dynamic> dorousList = json['dorous'];
    List<Dars> dorous =
        dorousList.map((darss) => Dars.fromJson(darss)).toList();
    return Dourous(dorous: dorous);
  }
}

class Dars {
  final int numdarss;
  final List<Safha> safahat;

  Dars({required this.numdarss, required this.safahat});

  factory Dars.fromJson(Map<String, dynamic> json) {
    var safahat = json['safahat']
        .map<Safha>((safhaJson) => Safha.fromJson(safhaJson))
        .toList();

    return Dars(numdarss: json['numdarss'], safahat: safahat);
  }
}

class Safha {
  int numsafha;
  List<Nass> nass;

  Safha({required this.numsafha, required this.nass});

  factory Safha.fromJson(Map<String, dynamic> json) {
    List<dynamic> texteList = json['texte'];
    List<Nass> nass = texteList.map((t) => Nass.fromJson(t)).toList();
    return Safha(numsafha: json['numsafha'], nass: nass);
  }
}

class Nass {
  final TypeParagraph type;
  final bool newLine;
  final String paragraph;

  Nass({required this.type, required this.newLine, required this.paragraph});

  factory Nass.fromJson(Map<String, dynamic> json) {
    return Nass(
      type: convertirEnEnum(json['type']),
      newLine: json['newLine'],
      paragraph: json['paragraph'],
    );
  }
}

Dourous loadData(jsonString) {
  final jsonData = json.decode(jsonString);
  final objets = Dourous.fromJson(jsonData);
  return objets;
}

final kitabNumProvider = StateProvider<int>(
  (ref) {
    return 1;
  },
);

final kitabDataProvider = FutureProvider<Dourous>((ref) async {
  final kitab = ref.watch(kitabNumProvider);
  final jsonString = await rootBundle.loadString('data/kitab_$kitab.json');
  return compute(loadData, jsonString);
});

final playerProvider = ChangeNotifierProvider<AudioPlayerController>(
  (ref) {
    // final String filePath = ref.watch(darsAudioPathProvider);
    return AudioPlayerController();
  },
);

class AudioPlayerController extends ChangeNotifier {
  AudioPlayer audioPlayer = AudioPlayer();
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  PlayerState playerState = PlayerState.stopped;
  double volume = 1.0;
  bool fileFound = false;

  AudioPlayerController() {
    audioPlayer.setReleaseMode(ReleaseMode.stop);

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
      fileFound = true;
    } else {
      fileFound = false;
      _reset();
    }
  }

  Future<void> play() async {
    (fileFound) ? await audioPlayer.resume() : null;
  }

  Future<void> pause() async {
    (fileFound) ? await audioPlayer.pause() : null;
  }

  Future<void> stop() async {
    (fileFound) ? await audioPlayer.stop() : null;
  }

  Future<void> release() async {
    (fileFound) ? await audioPlayer.release() : null;
  }

  Future<void> seek(Duration d) async {
    (fileFound)
        ? await audioPlayer.seek(
            d,
          )
        : null;
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

  void _reset() {
    audioPlayer.release();
    duration = Duration.zero;
    position = Duration.zero;
    playerState = PlayerState.stopped;
  }
}

final showPageInfoProvider = StateProvider<bool>(
  (ref) {
    return false;
  },
);

final darsIndexFromSharedPref = FutureProvider<int>((ref) async {
  final kitabNum = ref.watch(kitabNumProvider);
  final prefs = await SharedPreferences.getInstance();
  int? currentPage = prefs.getInt('kitab_${kitabNum}_page');
  if (currentPage != null) {
    return currentPage;
  } else {
    return 0;
  }
});

final darsIndexProvider = StateProvider<int>(
  (ref) {
    final futureValue = ref.watch(darsIndexFromSharedPref);
    return futureValue.asData?.value ?? 0;
  },
);

final savedBookmarkFromSharedPref = FutureProvider<int>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  int? bookmark = prefs.getInt('mushaf01_bookmark');

  if (bookmark != null) {
    return bookmark;
  } else {
    return 0;
  }
});

final savedBookmarkProvider = StateProvider<int>(
  (ref) {
    final futureValue = ref.watch(savedBookmarkFromSharedPref);
    return futureValue.asData?.value ?? 0;
  },
);

final scrollOrNotProvider = StateProvider<bool>(
  (ref) {
    return true;
  },
);

class MyDarss {
  final int index;
  final String name;
  final int page;
  final int kitab;

  MyDarss({
    required this.index,
    required this.name,
    required this.page,
    required this.kitab,
  });

  factory MyDarss.fromJson(Map<String, dynamic> json) {
    return MyDarss(
      index: json['index'],
      name: json['name'],
      page: json['page'],
      kitab: json['kitab'],
    );
  }
}

final myDarssListProvider = FutureProvider<List<MyDarss>>((ref) async {
  final jsonString = await rootBundle.loadString('data/darss.json');
  final jsonData = json.decode(jsonString);
  final objets =
      List<MyDarss>.from(jsonData.map((json) => MyDarss.fromJson(json)));
  return objets;
});

final fontSizeProvider = StateProvider<double>(
  (ref) {
    return 15;
  },
);

final marksProvider = StateProvider<List<String>>(
  (ref) {
    return [];
  },
);

final marksInfoProvider = StateProvider<String>(
  (ref) {
    return "------";
  },
);

final fontFamilyProvider = StateProvider<String>(
  (ref) {
    return "";
  },
);

final darsAudioPathProvider = StateProvider<String>(
  (ref) {
    final kitabNum = ref.watch(kitabNumProvider);
    final darsNum = ref.watch(darsIndexProvider);

    String filePath = "/MP3/";
    if (kitabNum < 10) {
      filePath = "${filePath}0${kitabNum}_";
    } else {
      filePath = "$filePath${kitabNum}_";
    }

    if (darsNum < 10) {
      filePath = "${filePath}0${darsNum + 1}.mp3";
    } else {
      filePath = "$filePath${darsNum + 1}.mp3";
    }
    return filePath;
  },
);
