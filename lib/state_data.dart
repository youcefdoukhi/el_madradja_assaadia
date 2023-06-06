import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

final savedBookmarkFromSharedPref = FutureProvider<int>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  int? bookmark = prefs.getInt('mushaf01_bookmark');

  if (bookmark != null) {
    return bookmark;
  } else {
    return 0;
  }
});
