import 'package:el_madradja_assaadia/state_data.dart';
import 'package:el_madradja_assaadia/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TOCWidget extends ConsumerWidget {
  const TOCWidget({Key? key}) : super(key: key);
  static const fontText = "ScheherazadeNew";
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    modifyAudioPositionDars() {
      int kitabNum = ref.read(kitabNumProvider);
      int darsNum =
          ref.read(previousDarsNumProvider)[ref.read(kitabNumProvider)];
      List<List<int>> originalList = [...ref.read(audioPositionDarsProvider)];

      originalList[kitabNum][darsNum] =
          ref.read(playerProvider).position.inSeconds;
      ref.read(audioPositionDarsProvider.notifier).state = [...originalList];
      setLatestAudioPositionDarsToSP(ref.read(audioPositionDarsProvider));
    }

    goToAudioPosition() async {
      await ref.read(playerProvider).seek(Duration(
          seconds:
              ref.read(audioPositionDarsProvider)[ref.read(kitabNumProvider)]
                  [ref.read(darsNumProvider)[ref.read(kitabNumProvider)]]));
    }

    getNbrDarssInBook() {
      int nbrDarss = 0;
      switch (ref.read(kitabNumProvider)) {
        case 0:
          nbrDarss = 58;
          break;
        case 1:
          nbrDarss = 12;
          break;
        case 2:
          nbrDarss = 12;
          break;
        case 3:
          nbrDarss = 9;
          break;
        case 4:
          nbrDarss = 1;
          break;
        default:
          nbrDarss = 0;
      }

      return nbrDarss;
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                  text: "فهرس الدروس",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: fontText,
                  ),
                ),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
            ),
            const Divider(
              indent: 50,
              endIndent: 50,
              color: Color.fromRGBO(233, 218, 193, 1),
            ),
            Expanded(
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overScroll) {
                  overScroll.disallowIndicator();
                  return false;
                },
                child: ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount: getNbrDarssInBook(),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () async => {
                        ref.read(scrollOrNotProvider.notifier).state = false,
                        ref.read(previousDarsNumProvider.notifier).state = [
                          ...ref.read(darsNumProvider)
                        ],
                        modifyAudioPositionDars(),
                        ref.read(darsNumProvider.notifier).state = [
                          ...ref.read(darsNumProvider)
                        ]..[ref.read(kitabNumProvider)] = index,
                        setKutubLatestDarsNumToSP(ref.read(darsNumProvider)),
                        ref.read(showPageInfoProvider.notifier).state = false,
                        await ref
                            .read(playerProvider)
                            .setSource(ref.read(darsAudioPathProvider)),
                        await goToAudioPosition(),
                        Navigator.pop(context),
                      },
                      child: Container(
                        color: Colors.transparent,
                        height: 40.0,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  const Flexible(
                                    child: FractionallySizedBox(
                                      heightFactor: 1,
                                      child: Text(
                                        "درس رقم",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: FractionallySizedBox(
                                      heightFactor: 1,
                                      child: Text("${index + 1}"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Container(
                                padding: const EdgeInsets.only(
                                  right: 10,
                                ),
                                alignment: Alignment.centerRight,
                                child: const Text("العنوان :"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(
                    //indent: 50,
                    //endIndent: 50,
                    color: Color.fromRGBO(233, 218, 193, 1),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
