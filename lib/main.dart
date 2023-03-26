import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
//import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'about.dart';
import 'about2.dart';
import 'download_page.dart';

void main() async {
  //WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  //FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const _title = 'برنامج المدرجة السعدية إلى فقه الشريعة';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: <Locale>[
        Locale('ar', ''),
      ],
      locale: Locale('ar'),
      title: _title,
      home: MainWidget(),
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
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const <Widget>[
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
                                    fontFamily: "ScheherazadeNew",
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
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const <Widget>[
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
                                    fontFamily: "ScheherazadeNew",
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
                                    builder: (context) => const About()),
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
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const <Widget>[
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
                                    fontFamily: "ScheherazadeNew",
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
