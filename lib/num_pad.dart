import 'package:el_madradja_assaadia/state_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'reader.dart';

class MyNumPad extends ConsumerWidget {
  MyNumPad({Key? key}) : super(key: key);
  final TextEditingController _myController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.center,
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'أدخل رقم الصفحة :\n',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              TextSpan(
                text: '(رقم بين ال1 و ال55)',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(0),
          child: SizedBox(
            height: 50,
            child: Center(
              child: TextField(
                enabled: false,
                controller: _myController,
                textAlign: TextAlign.center,
                showCursor: false,
                style: const TextStyle(
                  fontSize: 40,
                  color: Color.fromARGB(129, 255, 255, 255),
                ),
                keyboardType: TextInputType.none,
              ),
            ),
          ),
        ),
        NumPad(
          buttonSize: 50,
          buttonColor: const Color.fromRGBO(233, 218, 193, 0.7),
          iconColor: const Color.fromRGBO(84, 186, 185, 0.7),
          controller: _myController,
          delete: () {
            _myController.text =
                _myController.text.substring(0, _myController.text.length - 1);
          },
          onSubmit: () {
            int? page = (_myController.text != "")
                ? int.parse(_myController.text)
                : null;
            if (page != null && page > 0 && page < 56) {
              ref.read(scrollOrNotProvider.notifier).state = false;
              ref.read(darsNumProvider.notifier).state = page - 1;
              ref.read(showPageInfoProvider.notifier).state = false;
              ref
                  .read(playerProvider)
                  .setSource(ref.read(darsAudioPathProvider));
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ReaderWidget(),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}

class NumPad extends StatelessWidget {
  final double buttonSize;
  final Color buttonColor;
  final Color iconColor;
  final TextEditingController controller;
  final Function delete;
  final Function onSubmit;

  const NumPad({
    Key? key,
    this.buttonSize = 50,
    this.buttonColor = const Color.fromARGB(255, 131, 131, 131),
    this.iconColor = const Color.fromARGB(255, 8, 240, 170),
    required this.delete,
    required this.onSubmit,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 30, right: 30),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // implement the number keys (from 0 to 9) with the NumberButton widget
            // the NumberButton widget is defined in the bottom of this file
            children: [
              NumberButton(
                number: 1,
                size: buttonSize,
                color: buttonColor,
                controller: controller,
              ),
              NumberButton(
                number: 2,
                size: buttonSize,
                color: buttonColor,
                controller: controller,
              ),
              NumberButton(
                number: 3,
                size: buttonSize,
                color: buttonColor,
                controller: controller,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NumberButton(
                number: 4,
                size: buttonSize,
                color: buttonColor,
                controller: controller,
              ),
              NumberButton(
                number: 5,
                size: buttonSize,
                color: buttonColor,
                controller: controller,
              ),
              NumberButton(
                number: 6,
                size: buttonSize,
                color: buttonColor,
                controller: controller,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NumberButton(
                number: 7,
                size: buttonSize,
                color: buttonColor,
                controller: controller,
              ),
              NumberButton(
                number: 8,
                size: buttonSize,
                color: buttonColor,
                controller: controller,
              ),
              NumberButton(
                number: 9,
                size: buttonSize,
                color: buttonColor,
                controller: controller,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // this button is used to delete the last number
              IconButton(
                onPressed: () => delete(),
                icon: Icon(
                  Icons.backspace,
                  color: iconColor,
                ),
                iconSize: buttonSize,
              ),
              NumberButton(
                number: 0,
                size: buttonSize,
                color: buttonColor,
                controller: controller,
              ),
              // this button is used to submit the entered value
              IconButton(
                onPressed: () => onSubmit(),
                icon: Icon(
                  Icons.done_rounded,
                  color: iconColor,
                ),
                iconSize: buttonSize,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// define NumberButton widget
// its shape is round
class NumberButton extends StatelessWidget {
  final int number;
  final double size;
  final Color color;
  final TextEditingController controller;

  const NumberButton({
    Key? key,
    required this.number,
    required this.size,
    required this.color,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(3),
      width: size,
      height: size,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: () {
          controller.text += number.toString();
        },
        child: Center(
          child: Text(
            number.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
            ),
          ),
        ),
      ),
    );
  }
}
