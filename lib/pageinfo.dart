import 'package:el_madradja_assaadia/state_data.dart';
import 'package:el_madradja_assaadia/toc.dart';
import 'package:el_madradja_assaadia/utils.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:el_madradja_assaadia/audioplayers.dart';

import 'bookmarks.dart';
import 'main.dart';
import 'num_pad.dart';

const fontTitre = "Lateef";

class MyPageInfo extends ConsumerWidget {
  MyPageInfo({
    Key? key,
  }) : super(key: key);

  Future<void> setBrightness(double brightness) async {
    try {
      await ScreenBrightness().setScreenBrightness(brightness);
    } catch (e) {
      debugPrint(e.toString());
      throw 'Failed to set brightness';
    }
  }

  Future<void> resetBrightness() async {
    try {
      await ScreenBrightness().resetScreenBrightness();
    } catch (e) {
      debugPrint(e.toString());
      throw 'Failed to reset brightness';
    }
  }

  Future<void> _saveTextSize(ref) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('fontSize', ref.read(fontSizeProvider));
  }

  void zoomIn(ref) {
    ref.read(fontSizeProvider.notifier).state = ref.read(fontSizeProvider) + 1;

    _saveTextSize(ref);
  }

  void zoomOut(ref) {
    ref.read(fontSizeProvider.notifier).state = ref.read(fontSizeProvider) - 1;
    _saveTextSize(ref);
  }

  void zoomDefault(ref) {
    ref.read(fontSizeProvider.notifier).state = 15.0;
    _saveTextSize(ref);
  }

  Future<void> _saveBookmark(ref) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('mushaf01_bookmark', ref.read(darsNumProvider));
    ref.read(savedBookmarkProvider.notifier).state = ref.read(darsNumProvider);
    ref.read(showPageInfoProvider.notifier).state = false;
  }

  displaySaveBookmarkDialog(BuildContext context, WidgetRef ref) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Text(
              "حفظ المرجعية؟",
              style: TextStyle(
                fontFamily: fontTitre,
              ),
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 212, 180, 124),
                ),
                child: const Text(
                  'إلغاء',
                  style: TextStyle(
                    fontFamily: fontTitre,
                    fontSize: 14,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(220, 54, 56, 89),
                ),
                child: const Text(
                  'حفظ',
                  style: TextStyle(
                    fontFamily: fontTitre,
                    fontSize: 14,
                  ),
                ),
                onPressed: () {
                  _saveBookmark(ref);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  Future<void> _saveMarksList(WidgetRef ref, marqueInfo) async {
    final prefs = await SharedPreferences.getInstance();

    ref.read(marksProvider.notifier).state =
        (prefs.getStringList('marks') ?? []);
    ref.read(marksProvider.notifier).state.add(
        "${ref.read(darsNumProvider)}/${getDate(DateTime.now())}/$marqueInfo");
    prefs.setStringList('marks', ref.read(marksProvider));
    ref.read(marksInfoProvider.notifier).state = "------";
  }

  String getDate(DateTime date) {
    int a = date.year;
    String m = date.month < 10 ? "0${date.month}" : date.month.toString();
    String j = date.day < 10 ? "0${date.day}" : date.day.toString();
    String h = date.hour < 10 ? "0${date.hour}" : date.hour.toString();
    String mnt = date.minute < 10 ? "0${date.minute}" : date.minute.toString();
    String s = date.second < 10 ? "0${date.second}" : date.second.toString();
    return "$a-$m-$j $h:$mnt:$s";
  }

  final TextEditingController _textFieldController = TextEditingController();
  displayTextInputDialog(BuildContext ctx, WidgetRef ref) {
    _textFieldController.clear();

    ref.read(marksInfoProvider.notifier).state = "------";

    return showDialog(
      context: ctx,
      builder: (context2) {
        return AlertDialog(
          content: TextField(
            autofocus: true,
            style: const TextStyle(
              fontSize: 14,
            ),
            onChanged: (value) {
              ref.read(marksInfoProvider.notifier).state = value;
            },
            controller: _textFieldController,
            decoration: const InputDecoration(
              hintText: "أضف كلمات تذكرك...",
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(220, 54, 56, 89),
                ),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(255, 212, 180, 124),
              ),
              child: const Text(
                'إلغاء',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              onPressed: () {
                ref.read(marksInfoProvider.notifier).state = "------";
                Navigator.pop(context2);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(220, 54, 56, 89),
              ),
              child: const Text(
                'حفظ',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              onPressed: () {
                _saveMarksList(ref, ref.read(marksInfoProvider));
                Navigator.pop(context2);
                showStatus(context2);
              },
            ),
          ],
        );
      },
    );
  }

  showStatus(ctext) {
    return ScaffoldMessenger.of(ctext).showSnackBar(
      const SnackBar(
        content: Text(
          'حفظ',
          textAlign: TextAlign.center,
        ),
        margin: EdgeInsets.only(bottom: 150),
        elevation: 10,
        behavior: SnackBarBehavior.floating,
        duration: Duration(milliseconds: 1000),
        backgroundColor: Color.fromARGB(255, 212, 180, 124),
        shape: CircleBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    modifyCurrentAudioPositionDars() {
      int kitabNum = ref.read(kitabNumProvider);
      int darsNum = ref.read(darsNumProvider)[kitabNum];
      List<List<int>> originalList = [...ref.read(audioPositionDarsProvider)];

      originalList[kitabNum][darsNum] =
          ref.read(playerProvider).position.inSeconds;
      ref.read(audioPositionDarsProvider.notifier).state = [...originalList];
      setLatestAudioPositionDarsToSP(ref.read(audioPositionDarsProvider));
    }

    List<int> darsNumList = ref.watch(darsNumProvider);
    int page = darsNumList[ref.read(kitabNumProvider)];
    return Visibility(
      visible: ref.watch(showPageInfoProvider),
      child: Column(
        children: <Widget>[
          Stack(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.only(left: 10, right: 10),
                height: 44,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(220, 54, 56, 89),
                  border: Border.all(
                    color: const Color.fromARGB(255, 212, 180, 124),
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Column(
                          children: [
                            const Flexible(
                              child: FractionallySizedBox(
                                heightFactor: 1,
                                child: Text(
                                  "الكتاب",
                                  style: TextStyle(
                                    fontFamily: fontTitre,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Flexible(
                              child: FractionallySizedBox(
                                heightFactor: 1,
                                child: Text(
                                  "${ref.watch(kitabNumProvider) + 1}",
                                  style: const TextStyle(
                                    fontFamily: fontTitre,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Column(
                          children: [
                            const Flexible(
                              child: FractionallySizedBox(
                                heightFactor: 1,
                                child: Text(
                                  "الدرس",
                                  style: TextStyle(
                                    fontFamily: fontTitre,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Flexible(
                              child: FractionallySizedBox(
                                heightFactor: 1,
                                child: Text(
                                  "${page + 1}",
                                  style: const TextStyle(
                                    fontFamily: fontTitre,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: [
                            Flexible(
                              child: FractionallySizedBox(
                                heightFactor: 1,
                                child: Text(
                                  "الصفحة",
                                  style: TextStyle(
                                    fontFamily: fontTitre,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Flexible(
                              child: FractionallySizedBox(
                                heightFactor: 1,
                                child: Text(
                                  "X",
                                  style: TextStyle(
                                    fontFamily: fontTitre,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  left: 12,
                  right: 12,
                ),
                child: FutureBuilder<double>(
                  future: ScreenBrightness().current,
                  builder: (context, snapshot) {
                    double currentBrightness = 0;
                    if (snapshot.hasData) {
                      currentBrightness = snapshot.data!;
                    }

                    return StreamBuilder<double>(
                      stream: ScreenBrightness().onCurrentBrightnessChanged,
                      builder: (context, snapshot) {
                        double changedBrightness = currentBrightness;
                        if (snapshot.hasData) {
                          changedBrightness = snapshot.data!;
                        }

                        return SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 40.0,
                            trackShape: CustomTrackShape(),
                            activeTrackColor:
                                const Color.fromARGB(179, 54, 56, 89),
                            inactiveTrackColor: Colors.transparent,
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 0.0,
                              pressedElevation: 0.0,
                            ),
                            thumbColor: Colors.transparent,
                            overlayColor: Colors.transparent,
                            overlayShape: const RoundSliderOverlayShape(
                                overlayRadius: 32.0),
                          ),
                          child: Slider.adaptive(
                            value: changedBrightness,
                            onChanged: (value) {
                              setBrightness(value);
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),

          Container(
            margin: const EdgeInsets.only(
              top: 0,
              left: 10,
              right: 10,
              bottom: 10,
            ),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color.fromARGB(220, 54, 56, 89),
              border: Border.all(
                color: const Color.fromARGB(255, 212, 180, 124),
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: const MyAudioPlayer(),
          ),
          Expanded(
            child: Container(),
          ),

          //------------------
          Container(
            height: 140,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color.fromARGB(220, 54, 56, 89),
            ),
            child: Column(
              children: [
                Flexible(
                  child: FractionallySizedBox(
                    widthFactor: 1,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                          child: FractionallySizedBox(
                            widthFactor: 1,
                            child: Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                      width: 0.5, color: Color(0xFFFFFFFF)),
                                ),
                              ),
                              child: InkWell(
                                onTap: () {
                                  ref.read(playerProvider).pause();
                                  modifyCurrentAudioPositionDars();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const MyApp()),
                                  );
                                }, // button pressed
                                child: const Column(
                                  //mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      //size: 20,
                                      Icons.home_outlined,
                                      color: Color.fromARGB(255, 212, 180, 124),
                                    ), // icon
                                    Text(" الواجهة الرئيسية",
                                        textDirection: TextDirection.rtl,
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: fontTitre,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: FractionallySizedBox(
                            widthFactor: 1,
                            child: Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                      width: 0.5,
                                      color:
                                          Color.fromARGB(255, 212, 180, 124)),
                                  left: BorderSide(
                                      width: 0.5,
                                      color:
                                          Color.fromARGB(255, 212, 180, 124)),
                                  right: BorderSide(
                                      width: 0.5,
                                      color:
                                          Color.fromARGB(255, 212, 180, 124)),
                                ),
                              ),
                              child: InkWell(
                                onTap: () {
                                  displayTextInputDialog(context, ref);
                                },
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.bookmark_add_outlined,
                                      color: Color.fromARGB(255, 212, 180, 124),
                                    ), // icon
                                    Text(
                                      "إضافة علامة",
                                      textDirection: TextDirection.rtl,
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: fontTitre,
                                      ),
                                    ), // text
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: FractionallySizedBox(
                            widthFactor: 1,
                            child: Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                      width: 0.5,
                                      color:
                                          Color.fromARGB(255, 212, 180, 124)),
                                ),
                              ),
                              child: const MyBookmarkBottomSheet(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  child: FractionallySizedBox(
                    widthFactor: 1,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                          child: FractionallySizedBox(
                            widthFactor: 1,
                            child: Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                      width: 0.5,
                                      color:
                                          Color.fromARGB(255, 212, 180, 124)),
                                ),
                              ),
                              child: InkWell(
                                onTap: () {
                                  zoomIn(ref);
                                }, // button pressed
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.zoom_in_outlined,
                                      color: Color.fromARGB(255, 212, 180, 124),
                                    ),
                                    Text(
                                      "تكبير",
                                      textDirection: TextDirection.rtl,
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: fontTitre,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: FractionallySizedBox(
                            widthFactor: 1,
                            child: Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    width: 0.5,
                                    color: Color.fromARGB(255, 212, 180, 124),
                                  ),
                                  right: BorderSide(
                                    width: 0.5,
                                    color: Color.fromARGB(255, 212, 180, 124),
                                  ),
                                ),
                              ),
                              child: InkWell(
                                onTap: () {
                                  zoomDefault(ref);
                                }, // button pressed
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.crop_free_outlined,
                                      color: Color.fromARGB(255, 212, 180, 124),
                                    ),
                                    Text(
                                      "100%",
                                      textDirection: TextDirection.rtl,
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: fontTitre,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: FractionallySizedBox(
                            widthFactor: 1,
                            child: Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                      width: 0.5,
                                      color:
                                          Color.fromARGB(255, 212, 180, 124)),
                                  right: BorderSide(
                                    width: 0.5,
                                    color: Color.fromARGB(255, 212, 180, 124),
                                  ),
                                ),
                              ),
                              child: InkWell(
                                // splash color
                                onTap: () {
                                  zoomOut(ref);
                                }, // button pressed
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.zoom_out_outlined,
                                      color: Color.fromARGB(255, 212, 180, 124),
                                    ),
                                    Text(
                                      "تصغير",
                                      textDirection: TextDirection.rtl,
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: fontTitre,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: FractionallySizedBox(
                            widthFactor: 1,
                            child: Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    width: 0.5,
                                    color: Color.fromARGB(255, 212, 180, 124),
                                  ),
                                  right: BorderSide(
                                      width: 0.5,
                                      color:
                                          Color.fromARGB(255, 212, 180, 124)),
                                ),
                              ),
                              child: const MyTocBottomSheet(),
                            ),
                          ),
                        ),
                        Flexible(
                          child: FractionallySizedBox(
                            widthFactor: 1,
                            child: Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                      width: 0.5,
                                      color:
                                          Color.fromARGB(255, 212, 180, 124)),
                                  right: BorderSide(
                                      width: 0.5,
                                      color:
                                          Color.fromARGB(255, 212, 180, 124)),
                                ),
                              ),
                              child: InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    elevation: 10,
                                    barrierColor: Colors.transparent,
                                    backgroundColor: Colors.transparent,
                                    context: context,
                                    enableDrag: true,
                                    builder: (ctx) => Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      color: Colors.transparent,
                                      alignment: Alignment.center,
                                      child: MyNumPad(),
                                    ),
                                  );
                                },
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.switch_access_shortcut_outlined,
                                      color: Color.fromARGB(255, 212, 180, 124),
                                    ),
                                    Text(
                                      "إذهب إلى",
                                      textDirection: TextDirection.rtl,
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: fontTitre,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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

class MyTocBottomSheet extends StatelessWidget {
  const MyTocBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          enableDrag: true,
          builder: (ctx) => const TOCWidget(),
        );
      },
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.menu_book_outlined,
            color: Color.fromARGB(255, 212, 180, 124),
          ),
          Text(
            "الفهرس",
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.justify,
            style: TextStyle(
              color: Colors.white,
              fontFamily: fontTitre,
            ),
          ),
        ],
      ),
    );
  }
}

class MyBookmarkBottomSheet extends StatelessWidget {
  const MyBookmarkBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          enableDrag: true,
          builder: (ctx) => const BookmarksList(),
        );
      },
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.bookmarks_outlined,
            color: Color.fromARGB(255, 212, 180, 124),
          ),
          Text(
            "العلامات الموجودة",
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.justify,
            style: TextStyle(
              color: Colors.white,
              fontFamily: fontTitre,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomTrackShape extends RectangularSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight;
    final trackLeft = offset.dx;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
