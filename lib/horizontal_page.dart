import 'package:el_madradja_assaadia/safha.dart';
import 'package:el_madradja_assaadia/state_data.dart';
import 'package:el_madradja_assaadia/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class HorizontalPage extends ConsumerStatefulWidget {
  const HorizontalPage({super.key});

  @override
  HorizontalPageState createState() => HorizontalPageState();
}

class HorizontalPageState extends ConsumerState<HorizontalPage> {
  late PageController pageController;

  @override
  void initState() {
    super.initState();

    pageController = PageController(
      initialPage: ref.read(darsNumProvider)[ref.read(kitabNumProvider)],
    );

    setSourceAndGoToAudioPos();
  }

  setSourceAndGoToAudioPos() async {
    await ref.read(playerProvider).setSource(ref.read(darsAudioPathProvider));
    await goToAudioPosition();
  }

  modifyAudioPositionDars() {
    int kitabNum = ref.read(kitabNumProvider);
    int darsNum = ref.read(previousDarsNumProvider)[ref.read(kitabNumProvider)];
    List<List<int>> originalList = [...ref.read(audioPositionDarsProvider)];

    originalList[kitabNum][darsNum] =
        ref.read(playerProvider).position.inSeconds;
    ref.read(audioPositionDarsProvider.notifier).state = [...originalList];
    setLatestAudioPositionDarsToSP(ref.read(audioPositionDarsProvider));
  }

  goToAudioPosition() async {
    await ref.read(playerProvider).seek(Duration(
        seconds: ref.read(audioPositionDarsProvider)[ref.read(kitabNumProvider)]
            [ref.read(darsNumProvider)[ref.read(kitabNumProvider)]]));
  }

  @override
  void dispose() {
    //ref.read(playerProvider).release();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<List<int>>(
      darsNumProvider,
      (List<int>? previousCount, List<int> newCount) {
        if (ref.read(scrollOrNotProvider) == false) {
          pageController.jumpToPage(newCount[ref.read(kitabNumProvider)]);

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
                onPageChanged: (int page) async => {
                  ref.read(previousDarsNumProvider.notifier).state = [
                    ...ref.read(darsNumProvider)
                  ],

                  modifyAudioPositionDars(),
                  //********************************************
                  ref.read(darsNumProvider.notifier).state = [
                    ...ref.read(darsNumProvider)
                  ]..[ref.read(kitabNumProvider)] = page,

                  setKutubLatestDarsNumToSP(ref.read(darsNumProvider)),
                  //********************************************

                  await ref
                      .read(playerProvider)
                      .setSource(ref.read(darsAudioPathProvider)),

                  //*********************************************
                  await goToAudioPosition(),
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
                      final List<Nass> nassSafha = safha.nass;
                      return SafhaWidget(nass: nassSafha);
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

/*
WidgetSpan(
      child: Align(
        alignment: Alignment.center,
        child: Text.rich(
          textAlign: TextAlign.center,
          TextSpan(
            text: redTitle,
            style: TextStyle(
              color: charihColor,
              fontSize: fontSize03,
              fontFamily: fontText,
            ),
          ),
        ),
      ),
    );

*/
