import 'package:flutter/material.dart';

class CustomSubmitButton extends StatelessWidget {

  final Function() onPressed;
  final String text;

  const CustomSubmitButton({Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: Theme.of(context).disabledColor,
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
