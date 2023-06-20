import 'package:el_madradja_assaadia/reader.dart';
import 'package:el_madradja_assaadia/state_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
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
    final platform = Theme.of(context).platform;
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
      home: Scaffold(
        body: SafeArea(
          child: Consumer(
            builder: (ctx, ref, child) {
              final listSurah = ref.watch(myDarssListProvider);
              return listSurah.when(
                data: (objets2) {
                  return const MainWidget();
                },
                loading: () => Container(
                  height: double.infinity,
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 110),
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
                error: (error, _) => Text('Error: $error'),
              );
            },
          ),
        ),
        floatingActionButton: Container(
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Builder(
                builder: (BuildContext context) {
                  return FloatingActionButton(
                    heroTag: 'firstButton',
                    foregroundColor: const Color.fromARGB(255, 212, 180, 124),
                    backgroundColor: const Color.fromARGB(220, 54, 56, 89),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyDownloadPage(
                            platform: platform,
                          ),
                        ),
                      );
                    },
                    child: const Icon(Icons.settings),
                  );
                },
              ),
              Builder(
                builder: (BuildContext context) {
                  return FloatingActionButton(
                    heroTag: 'secondButton',
                    foregroundColor: const Color.fromARGB(255, 212, 180, 124),
                    backgroundColor: const Color.fromARGB(220, 54, 56, 89),
                    onPressed: () {
                      /*  Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ,
                        ),
                      );*/
                    },
                    child: const Icon(Icons.info_outline),
                  );
                },
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}

class MainWidget extends ConsumerWidget {
  const MainWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: double.infinity,
      width: double.infinity,
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
                  height: MediaQuery.of(context).size.width / 3.5,
                  width: MediaQuery.of(context).size.width / 3.5,
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
                            Text(
                              "منهج\nالسالكين",
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => {
                          ref.read(showPageInfoProvider.notifier).state = false,
                          ref.read(kitabNumProvider.notifier).state = 1,
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Consumer(
                                builder: (context, ref, child) {
                                  final indexFromSP =
                                      ref.watch(darsNumFromSPProvider);

                                  return indexFromSP.when(
                                    data: (data) {
                                      return Consumer(
                                        builder: (context, ref, child) {
                                          final darsAudioFromSP = ref.watch(
                                              darsAudioPositionFromSPProvider);

                                          return darsAudioFromSP.when(
                                            data: (data) {
                                              return const ReaderWidget();
                                            },
                                            loading: () =>
                                                const CircularProgressIndicator(),
                                            error: (error, _) =>
                                                Text('Error: $error'),
                                          );
                                        },
                                      );
                                    },
                                    loading: () => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    error: (error, _) => Text('Error: $error'),
                                  );
                                },
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
                  height: MediaQuery.of(context).size.width / 3.5,
                  width: MediaQuery.of(context).size.width / 3.5,
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
                            Text(
                              "منظومة\nالقواعد\nالفقهية",
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => {
                          ref.read(showPageInfoProvider.notifier).state = false,
                          ref.read(kitabNumProvider.notifier).state = 2,
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Consumer(
                                builder: (context, ref, child) {
                                  final indexFromSP =
                                      ref.watch(darsNumFromSPProvider);
                                  return indexFromSP.when(
                                    data: (data) {
                                      return const ReaderWidget();
                                    },
                                    loading: () => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    error: (error, _) => Text('Error: $error'),
                                  );
                                },
                              ),
                            ),
                          ),
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.width / 3.5,
                  width: MediaQuery.of(context).size.width / 3.5,
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
                            Text(
                              "رسالة\nفي أصول\nالفقه",
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => {
                          ref.read(showPageInfoProvider.notifier).state = false,
                          ref.read(kitabNumProvider.notifier).state = 3,
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Consumer(
                                builder: (context, ref, child) {
                                  final indexFromSP =
                                      ref.watch(darsNumFromSPProvider);
                                  return indexFromSP.when(
                                    data: (data) {
                                      return const ReaderWidget();
                                    },
                                    loading: () => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    error: (error, _) => Text('Error: $error'),
                                  );
                                },
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
                  height: MediaQuery.of(context).size.width / 3.5,
                  width: MediaQuery.of(context).size.width / 3.5,
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
                            Text(
                              "الإرشاد\nإلى معرفة\nالأحكام",
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => {
                          ref.read(showPageInfoProvider.notifier).state = false,
                          ref.read(kitabNumProvider.notifier).state = 4,
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Consumer(
                                builder: (context, ref, child) {
                                  final indexFromSP =
                                      ref.watch(darsNumFromSPProvider);
                                  return indexFromSP.when(
                                    data: (data) {
                                      return const ReaderWidget();
                                    },
                                    loading: () => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    error: (error, _) => Text('Error: $error'),
                                  );
                                },
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
                  height: MediaQuery.of(context).size.width / 3.5,
                  width: MediaQuery.of(context).size.width / 3.5,
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
                            Text(
                              "القواعد\nوالأصول\nالجامعة",
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => {
                          ref.read(showPageInfoProvider.notifier).state = false,
                          ref.read(kitabNumProvider.notifier).state = 5,
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Consumer(
                                builder: (context, ref, child) {
                                  final indexFromSP =
                                      ref.watch(darsNumFromSPProvider);
                                  return indexFromSP.when(
                                    data: (data) {
                                      return const ReaderWidget();
                                    },
                                    loading: () => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    error: (error, _) => Text('Error: $error'),
                                  );
                                },
                              ),
                            ),
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
    );
  }
}
