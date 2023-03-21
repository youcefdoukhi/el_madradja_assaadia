import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Créer un rep s'in n'existe pas, et retourné le chemin
Future<String> createFolderInAppDocDir(String folderName) async {
  final Directory appDocDir = await getApplicationDocumentsDirectory();
  final Directory appDocDirFolder = Directory('${appDocDir.path}/$folderName');

  if (appDocDirFolder.existsSync()) {
    return appDocDirFolder.path;
  } else {
    final Directory appDocDirNewFolder = await appDocDirFolder.create();
    return appDocDirNewFolder.path;
  }
}

///
Future<bool> checkIfMp3ExistInAppDocDir(String mp3Title) async {
  final Directory appDocDir = await getApplicationDocumentsDirectory();

  final Directory pathWithMp3Title =
      Directory('${appDocDir.path}/MP3/$mp3Title');

  if (await pathWithMp3Title.exists()) {
    return true;
  } else {
    return false;
  }
}

/// Lister Dir
Future<List<FileSystemEntity>> getDir(String mydir) async {
  final directory = await getApplicationDocumentsDirectory();
  final dir = directory.path;
  String pdfDirectory = '$dir/$mydir';
  final myDir = Directory(pdfDirectory);

  return myDir.listSync(recursive: true, followLinks: false);
}

/// Supprimer Entité
Future deleteEntity(FileSystemEntity entity) async {
  await entity.delete();
}
