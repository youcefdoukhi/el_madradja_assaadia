import 'package:el_madradja_assaadia/state_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class HorizontalPage extends ConsumerWidget {
  const HorizontalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageIndex = ref.read(darsIndexProvider);

    final PageController pageController =
        PageController(initialPage: pageIndex);

    ref.read(playerProvider).setSource(ref.read(darsAudioPathProvider));

    ref.listen<int>(
      darsIndexProvider,
      (int? previousCount, int newCount) {
        if (ref.read(scrollOrNotProvider) == false) {
          pageController.jumpToPage(newCount);
          ref.read(scrollOrNotProvider.notifier).state = true;
        }
      },
    );

    Future<void> saveCurrentPage() async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt('kitab_${ref.read(kitabNumProvider)}_page',
          ref.read(darsIndexProvider));
    }

    return Consumer(
      builder: (context, ref, child) {
        final kitabData = ref.watch(kitabDataProvider);
        return kitabData.when(
          data: (data) {
            final List<Dars> dourous = data.dorous;
            return ScrollConfiguration(
              behavior: AppBehavior(),
              child: PageView.builder(
                itemCount: dourous.length,
                pageSnapping: true,
                scrollDirection: Axis.horizontal,
                controller: pageController,
                onPageChanged: (int page) => {
                  ref.read(darsIndexProvider.notifier).state = page,
                  saveCurrentPage(),
                  ref
                      .read(playerProvider)
                      .setSource(ref.read(darsAudioPathProvider)),
                },
                itemBuilder: (context, index) {
                  final Dars dars = dourous[index];
                  final List<Safha> safahat = dars.safahat;
                  final ItemScrollController itemScrollController =
                      ItemScrollController();

                  return ScrollablePositionedList.builder(
                    itemCount: safahat.length,
                    key: PageStorageKey("keyString$index"),
                    itemScrollController: itemScrollController,
                    itemBuilder: (BuildContext context, int indexSafha) {
                      final Safha safha = safahat[indexSafha];
                      final List<Nass> nass = safha.nass;
                      return Text(nass[0].paragraph);
                    },
                  ); /*
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          top: 0,
                          left: 10,
                          right: 10,
                          bottom: 10,
                        ),
                        //padding: const EdgeInsets.only(left: 10, right: 10),
                        //height: 44,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(220, 54, 56, 89),
                          border: Border.all(
                            color: const Color.fromARGB(255, 212, 180, 124),
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: MyAudioPlayer2(
                          kitab: ref.read(kitabNumProvider),
                          dars: ref.read(darsIndexProvider),
                        ),
                      ),
                      Expanded(
                        child: ScrollablePositionedList.builder(
                          itemCount: safahat.length,
                          key: PageStorageKey("keyString$index"),
                          itemScrollController: itemScrollController,
                          itemBuilder: (BuildContext context, int indexSafha) {
                            final Safha safha = safahat[indexSafha];
                            final List<Nass> nass = safha.nass;
                            return Text(nass[0].paragraph);
                          },
                        ),
                      ),
                    ],
                  );*/
                },
              ),
            );
          },
          loading: () => Scaffold(
            body: SafeArea(
              child: Container(
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
            ),
          ),
          error: (error, _) => Text('Error: $error'),
        );
      },
    );
  }
}

class AppBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
