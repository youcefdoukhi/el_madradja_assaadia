import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String path = "";
  List<FileSystemEntity> lstEntity = [];

  mypath() async {
    var p = await createFolderInAppDocDir("MP3");

    setState(() {
      path = p;
    });
  }

  mydir() async {
    var d = await getDir("MP3");
    setState(() {
      lstEntity.addAll(d);
    });
  }

  bool mp3Exist = false;
  ifMp3Exist(mp3Title) async {
    bool b = await checkIfMp3ExistInAppDocDir(mp3Title);
    setState(() {
      mp3Exist = b;
    });
  }

  @override
  void initState() {
    super.initState();

    mypath();
    mydir();
    ifMp3Exist("03_01.mp3");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: lstEntity.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 50,
            color: Colors.amber,
            child: Center(child: Text(lstEntity[index].path)),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: mp3Exist ? Colors.green : Colors.red,
        child: Icon(mp3Exist ? Icons.play_arrow : Icons.download),
      ),
    );
  }
}
