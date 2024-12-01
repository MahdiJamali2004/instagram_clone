import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String? hint;
  final bool obscureText;
  final TextEditingController controller;
  const MyTextField(
      {super.key,
      this.hint,
      required this.obscureText,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      maxLines: obscureText == true ? 1 : null,
      minLines: 1,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
        focusedBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).colorScheme.secondary),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}
