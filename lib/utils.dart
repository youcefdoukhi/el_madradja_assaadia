import 'dart:convert';

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

class AudioPositionInfo {
  String key;
  double position;
  AudioPositionInfo({required this.key, required this.position});
}

String getStringKeyFromKitabDars(int kitabNum, int darsNum) {
  return "K:${kitabNum}_D:${darsNum}_AudioPosition";
}

Future<bool> setDarsAudioPosition(AudioPositionInfo audioPosInfo) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.setDouble(audioPosInfo.key, audioPosInfo.position);
}

Future<double> getDarsAudioPositionFromSP(String key) async {
  final prefs = await SharedPreferences.getInstance();

  double? position = prefs.getDouble(key);
  if (position != null) {
    return position;
  }
  return 0.0;
}

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
