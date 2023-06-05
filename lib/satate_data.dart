import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Chapters {
  final int index;
  final String name;
  final String type;
  final int verses;
  final int start;

  Chapters({
    required this.index,
    required this.name,
    required this.type,
    required this.verses,
    required this.start,
  });

  factory Chapters.fromJson(Map<String, dynamic> json) {
    return Chapters(
      index: json['index'],
      name: json['name'],
      type: json['type'],
      verses: json['verses'],
      start: json['start'],
    );
  }
}

class RubObjet {
  final int rub;
  final int pagenum;
  final String ayah;

  RubObjet({required this.rub, required this.pagenum, required this.ayah});

  factory RubObjet.fromJson(Map<String, dynamic> json) {
    return RubObjet(
      rub: json['rub'],
      pagenum: json['pagenum'],
      ayah: json['ayah'],
    );
  }
}

final chaptersProvider = FutureProvider<List<Chapters>>((ref) async {
  final jsonString = await rootBundle.loadString('data/surah.json');
  final jsonData = json.decode(jsonString);
  final objets =
      List<Chapters>.from(jsonData.map((json) => Chapters.fromJson(json)));
  return objets;
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
