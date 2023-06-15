import 'package:el_madradja_assaadia/state_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TOCWidget extends ConsumerWidget {
  const TOCWidget({Key? key}) : super(key: key);
  static const fontText = "ScheherazadeNew";
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final objets = ref
        .read(myDarssListProvider)
        .value!
        .where((objet) => objet.kitab == 1)
        .toList();
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
                  text: "فهرس القرآن الكريم",
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
              //indent: 50,
              //endIndent: 50,
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
                  itemCount: objets.length,
                  itemBuilder: (BuildContext context, int index) {
                    final objet = objets[index];
                    return GestureDetector(
                      onTap: () => {
                        ref.read(scrollOrNotProvider.notifier).state = false,
                        ref.read(darsIndexProvider.notifier).state =
                            objet.page - 1,
                        ref.read(showPageInfoProvider.notifier).state = false,
                        Navigator.pop(context),
                      },
                      child: Container(
                        color: Colors.transparent,
                        height: 40.0,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "${objet.index}",
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Container(
                                padding: const EdgeInsets.only(
                                  right: 10,
                                ),
                                alignment: Alignment.centerRight,
                                child: Text(objet.name),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  const Flexible(
                                    child: FractionallySizedBox(
                                      heightFactor: 1,
                                      child: Text(
                                        "ص",
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
                                      child: Text("${objet.page}"),
                                    ),
                                  ),
                                ],
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
