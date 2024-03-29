import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

enum TypeParagraph { h1, h2, h3, h4, h5, h6, pm, pc, ayah, hadith, erreur }

TypeParagraph txt2TypeParag(String valeur) {
  return TypeParagraph.values.firstWhere(
    (element) => element.toString() == 'TypeParagraph.$valeur',
    orElse: () => TypeParagraph.erreur,
  );
}

enum TypeNewLine { n, nn, nc, erreur }

TypeNewLine txt2TypeNewLine(String valeur) {
  return TypeNewLine.values.firstWhere(
    (element) => element.toString() == 'TypeNewLine.$valeur',
    orElse: () => TypeNewLine.erreur,
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
  final TypeNewLine newLine;
  final String paragraph;

  Nass({required this.type, required this.newLine, required this.paragraph});

  factory Nass.fromJson(Map<String, dynamic> json) {
    return Nass(
      type: txt2TypeParag(json['type']),
      newLine: txt2TypeNewLine(json['newLine']),
      paragraph: json['paragraph'],
    );
  }
}

Dourous loadData(jsonString) {
  final jsonData = json.decode(jsonString);
  final objets = Dourous.fromJson(jsonData);
  return objets;
}

//****************************************************************

Future<List<int>> getKutubLatestDarsNumFromSP() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? encodedList = prefs.getString('kutubLatestDarsNumList');
  if (encodedList != null) {
    List<dynamic> decodedList = json.decode(encodedList);
    List<int> integerList = List<int>.from(decodedList);
    return integerList;
  } else {
    return [0, 0, 0, 0, 0];
  }
}

Future<bool> setKutubLatestDarsNumToSP(List<int> latestDarsNumList) async {
  String encodedList = json.encode(latestDarsNumList);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.setString('kutubLatestDarsNumList', encodedList);
}

//****************************************************************

Future<List<List<int>>> getLatestAudioPositionDarsFromSP() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? encodedList = prefs.getString('latestAudioPositionDarsList');
  if (encodedList != null) {
    List<List<int>> myList = json
        .decode(encodedList)
        .map<List<int>>((item) => List<int>.from(item))
        .toList();
    return myList;
  } else {
    return [
      List<int>.filled(58, 0),
      List<int>.filled(12, 0),
      List<int>.filled(12, 0),
      List<int>.filled(9, 0),
      List<int>.filled(1, 0),
    ];
  }
}

Future<bool> setLatestAudioPositionDarsToSP(
    List<List<int>> latestAudioPositionList) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String encodedList = json.encode(latestAudioPositionList);
  return await prefs.setString('latestAudioPositionDarsList', encodedList);
}

//****************************************************************

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
