import 'package:el_madradja_assaadia/state_data.dart';
import 'package:el_madradja_assaadia/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'about2.dart';
import 'download_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const _title = 'برنامج المدرجة السعدية إلى فقه الشريعة';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const <Locale>[
        Locale('ar', ''),
      ],
      locale: const Locale('ar'),
      title: _title,
      home: Consumer(
        builder: (context, ref, child) {
          final dataKitab01 = ref.watch(dataProvider);
          return dataKitab01.when(
            data: (objets4) {
              return const MainWidget();
            },
            loading: () => Scaffold(
              body: SafeArea(
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 100),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 251, 251, 251),
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: Image.asset(
                        'images/fond2.png',
                      ).image,
                    ),
                  ),
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
            ),
            error: (error, _) => Text('Error: $error'),
          );
        },
      ),
    );
  }
}

class MainWidget extends StatelessWidget {
  const MainWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.only(top: 100),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 251, 251, 251),
            image: DecorationImage(
              fit: BoxFit.fill,
              image: Image.asset(
                'images/fond2.png',
              ).image,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.width / 3,
                      width: MediaQuery.of(context).size.width / 3,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: Image.asset(
                            'images/btn.png',
                          ).image,
                        ),
                      ),
                      child: Stack(
                        children: [
                          const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.download,
                                  color: Color(0xFFD4B37C),
                                  //color: Colors.white,
                                ),
                                Text(
                                  "تصفح",
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyDownloadPage(
                                    platform: platform,
                                  ),
                                ),
                              ),
                            },
                          ),
                        ],
                      ),
                    ),
                    const VerticalDivider(
                      thickness: 0.5,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.width / 3,
                      width: MediaQuery.of(context).size.width / 3,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: Image.asset(
                            'images/btn.png',
                          ).image,
                        ),
                      ),
                      child: Stack(
                        children: [
                          const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.info_outline,
                                  //color: Colors.white,
                                  color: Color(0xFFD4B37C),
                                ),
                                Text(
                                  "عن التطبيق",
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    //builder: (context) => const About()),
                                    builder: (context) =>
                                        const AudioPlayerExample()),
                              ),
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const FractionallySizedBox(
                widthFactor: 0.8,
                child: Divider(
                  thickness: 0.5,
                ),
              ),
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.width / 3,
                      width: MediaQuery.of(context).size.width / 3,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: Image.asset(
                            'images/btn.png',
                          ).image,
                        ),
                      ),
                      child: Stack(
                        children: [
                          const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.info_outline,
                                  //color: Colors.white,
                                  color: Color(0xFFD4B37C),
                                ),
                                Text(
                                  "2 عن التطبيق",
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const About2()),
                              ),
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
