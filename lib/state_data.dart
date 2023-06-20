import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:el_madradja_assaadia/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

//***************************************************

final kitabDataProvider = FutureProvider<Dourous>((ref) async {
  final kitab = ref.watch(kitabNumProvider);
  final jsonString = await rootBundle.loadString('data/kitab_$kitab.json');
  return compute(loadData, jsonString);
});

//***************************************************

final kitabNumProvider = StateProvider<int>(
  (ref) {
    return 1;
  },
);

//***************************************************

final darsNumFromSPProvider = FutureProvider<int>((ref) async {
  final kitabNum = ref.watch(kitabNumProvider);
  final prefs = await SharedPreferences.getInstance();
  int? currentPage = prefs.getInt('kitab_${kitabNum}_page');
  if (currentPage != null) {
    return currentPage;
  } else {
    return 0;
  }
});

final darsNumProvider = StateProvider<int>(
  (ref) {
    final futureValue = ref.watch(darsNumFromSPProvider);
    return futureValue.asData?.value ?? 0;
  },
);

//***************************************************

final darsAudioPositionFromSPProvider = FutureProvider<double>(
  (ref) async {
    final kitabNum = ref.watch(kitabNumProvider);
    final darsNum = ref.watch(darsNumProvider);
    final double position = await getDarsAudioPositionFromSP(
        getStringKeyFromKitabDars(kitabNum, darsNum));
    return position;
  },
);

final darsAudioPositionProvider = StateProvider<double>(
  (ref) {
    final futureValue = ref.watch(darsAudioPositionFromSPProvider);
    return futureValue.asData?.value ?? 0.0;
  },
);

//***************************************************

final darsAudioPathProvider = StateProvider<String>(
  (ref) {
    final kitabNum = ref.watch(kitabNumProvider);
    final darsNum = ref.watch(darsNumProvider);

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

//**************************************************

final playerProvider = ChangeNotifierProvider<AudioPlayerController>(
  (ref) {
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

//****************************************************

final showPageInfoProvider = StateProvider<bool>(
  (ref) {
    return false;
  },
);

//****************************************************

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

//************************************************

final scrollOrNotProvider = StateProvider<bool>(
  (ref) {
    return true;
  },
);

//************************************************

final myDarssListProvider = FutureProvider<List<MyDarss>>((ref) async {
  final jsonString = await rootBundle.loadString('data/darss.json');
  final jsonData = json.decode(jsonString);
  final objets =
      List<MyDarss>.from(jsonData.map((json) => MyDarss.fromJson(json)));
  return objets;
});

//*************************************************

final fontSizeProvider = StateProvider<double>(
  (ref) {
    return 15;
  },
);

final fontFamilyProvider = StateProvider<String>(
  (ref) {
    return "";
  },
);

//**************************************************

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

//************************************************

