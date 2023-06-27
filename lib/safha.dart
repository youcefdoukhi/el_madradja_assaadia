import 'package:el_madradja_assaadia/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SafhaWidget extends ConsumerWidget {
  final List<Nass> nass;
  const SafhaWidget({super.key, required this.nass});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<InlineSpan> textSpans = nass.map((paragraph) {
      return paragraph.type == TypeParagraph.h1
          ? WidgetSpan(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "\n${paragraph.paragraph}\n",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
            )
          : TextSpan(
              text: "\n${paragraph.paragraph}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ));
    }).toList();

    textSpans.add(const TextSpan(children: [
      WidgetSpan(
        child: Align(
          alignment: Alignment.center,
          child: Text(
            "\n⌯⌯⌯۞⌯⌯⌯",
            style: TextStyle(
              color: Color.fromARGB(255, 90, 90, 90),
            ),
          ),
        ),
      ),
    ]));
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.black,
          width: 1.0,
        ),
      ),
      child: RichText(
        //key: const Key("index.toString()"),
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.start,
        text: TextSpan(children: textSpans),
      ),
    );
  }
}
