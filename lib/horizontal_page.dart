import 'package:el_madradja_assaadia/state_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class HorizontalPage extends ConsumerWidget {
  const HorizontalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageIndex = ref.read(pageIndexProvider);
    final PageController pageController =
        PageController(initialPage: pageIndex);

    ref.listen<int>(
      pageIndexProvider,
      (int? previousCount, int newCount) {
        if (ref.read(scrollOrNotProvider) == false) {
          pageController.jumpToPage(newCount);
          ref.read(scrollOrNotProvider.notifier).state = true;
        }
      },
    );

    Future<void> saveCurrentPage() async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt('mushaf01_page', ref.read(pageIndexProvider));
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
                  ref.read(pageIndexProvider.notifier).state = page,
                  saveCurrentPage()
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
