import 'package:flutter/material.dart';
//import 'package:path_provider/path_provider.dart';
//import 'package:just_audio/just_audio.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final player = AudioPlayer();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 2,
                    color: Color.fromRGBO(233, 218, 193, 1),
                  ),
                ),
              ),
              padding: const EdgeInsets.all(15),
              child: const Text.rich(
                TextSpan(
                  text: "عن التطبيق ؟",
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: "ScheherazadeNew",
                  ),
                ),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 50, bottom: 15),
                color: Colors.white,
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.topCenter,
                child: FractionallySizedBox(
                  widthFactor: 0.8,
                  //heightFactor: 0.1,
                  child: Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.play_circle),
                        tooltip: 'Play',
                        onPressed: () async {
                          //  String path =
                          //      (await getApplicationDocumentsDirectory())
                          //         .absolute
                          //          .path;
                          //String s = "$path/MP3/01_01.mp3";
                          //  await player.setUrl('file:$s');
                          //   await player.play();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.stop_circle),
                        tooltip: 'Stop',
                        onPressed: () {
                          //    player.pause();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.pause_circle),
                        tooltip: 'Pause',
                        onPressed: () {
                          //    player.pause();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
