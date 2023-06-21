import 'package:el_madradja_assaadia/state_data.dart';
import 'package:el_madradja_assaadia/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class HorizontalPage extends ConsumerWidget {
  const HorizontalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int darsNum =
        ref.read(darsNumProvider)[ref.read(kitabNumProvider) - 1];

    final PageController pageController = PageController(initialPage: darsNum);

    ref.read(playerProvider).setSource(ref.read(darsAudioPathProvider));

    ref.listen<List<int>>(
      darsNumProvider,
      (List<int>? previousCount, List<int> newCount) {
        if (ref.read(scrollOrNotProvider) == false) {
          pageController.jumpToPage(newCount[ref.read(kitabNumProvider) - 1]);

          ref.read(scrollOrNotProvider.notifier).state = true;
        }
      },
    );

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
                  ref.read(darsNumProvider.notifier).state = [
                    ...ref.read(darsNumProvider.notifier).state
                  ]..[ref.read(kitabNumProvider) - 1] = page,
                  setKutubLatestDarsNumToSP(ref.read(darsNumProvider)),
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
                  );
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
                child: const Center(
                    child: CircularProgressIndicator(
                        color: Color.fromARGB(255, 212, 180, 124))),
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
