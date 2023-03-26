import 'package:flutter/material.dart';

class About2 extends StatelessWidget {
  const About2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
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
                  text: "عن التطبيق 2؟",
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: "ScheherazadeNew",
                  ),
                ),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 50, bottom: 15),
                color: Colors.white,
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.topCenter,
                child: FractionallySizedBox(
                  widthFactor: 0.8,
                  //heightFactor: 0.1,
                  child: Container(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
