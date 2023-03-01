import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {

  final String labelText;
  final IconData prefixIcon;
  final bool obscureText;
  final TextEditingController controller;


  const CustomTextField({Key? key,
    required this.prefixIcon,
    required this.labelText,
    required this.obscureText,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(prefixIcon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}
