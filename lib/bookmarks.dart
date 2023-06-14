import 'package:el_madradja_assaadia/state_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'reader.dart';

class BookmarksList extends ConsumerStatefulWidget {
  const BookmarksList({Key? key}) : super(key: key);

  @override
  ConsumerState<BookmarksList> createState() => _BookmarksListState();
}

class _BookmarksListState extends ConsumerState<BookmarksList> {
  List<String> _marks = [];

  @override
  void initState() {
    super.initState();
    _loadMarks();
  }

  goToSavedBookmark() {
    ref.read(scrollOrNotProvider.notifier).state = false;
    ref.read(pageIndexProvider.notifier).state =
        ref.read(savedBookmarkProvider);
    ref.read(showPageInfoProvider.notifier).state = false;
  }

  Future<void> _loadMarks() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _marks = (prefs.getStringList('marks') ?? []);
    });
  }

  Future<void> _removeMark(indexMark) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _marks = (prefs.getStringList('marks') ?? []);
      _marks.removeAt(indexMark);
      prefs.setStringList('marks', _marks);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Center(
              child: Container(
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
                    text: "العلامات الموجودة",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),
              ),
            ),
            Expanded(
              child: (_marks.isNotEmpty)
                  ? Container(
                      color: Colors.white,
                      child: NotificationListener<
                              OverscrollIndicatorNotification>(
                          onNotification: (overScroll) {
                            overScroll.disallowIndicator();
                            return false;
                          },
                          child: ListView.separated(
                            padding: const EdgeInsets.all(5),
                            itemCount: _marks.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                leading: const Icon(
                                  Icons.turned_in,
                                  color: Color.fromRGBO(84, 186, 185, 1),
                                ),
                                onTap: () {
                                  ref.read(scrollOrNotProvider.notifier).state =
                                      false;
                                  ref.read(pageIndexProvider.notifier).state =
                                      int.parse(_marks[index].split('/')[0]);
                                  ref
                                      .read(showPageInfoProvider.notifier)
                                      .state = false;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ReaderWidget(),
                                    ),
                                  );
                                },
                                title: Text(
                                  _marks[index].split('/')[2],
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                subtitle: Text(
                                  "صفحة رقم : ${int.parse(_marks[index].split('/')[0]) + 1}\n ${_marks[index].split('/')[1]}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete_forever,
                                    color: Color.fromRGBO(233, 218, 193, 1),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _removeMark(index);
                                    });
                                  },
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider(
                              indent: 50,
                              endIndent: 50,
                              color: Color.fromRGBO(233, 218, 193, 1),
                            ),
                          )),
                    )
                  : Container(
                      padding: const EdgeInsets.only(top: 15),
                      color: Colors.white,
                      width: double.infinity,
                      height: double.infinity,
                      alignment: Alignment.topCenter,
                      child: FractionallySizedBox(
                        widthFactor: 0.8,
                        heightFactor: 0.1,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(233, 218, 193, 0.5),
                            border: Border.all(
                              color: const Color.fromRGBO(234, 193, 114, 1),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          alignment: Alignment.center,
                          child: const Text.rich(
                            TextSpan(
                              text: "لا يوجد أي علامات محفوظة !",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.rtl,
                          ),
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
