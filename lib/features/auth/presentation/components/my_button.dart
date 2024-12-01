import 'package:flutter/material.dart';
import 'package:instagram_clone/gen/fonts.gen.dart';

class MyButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  const MyButton({super.key, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.blue,
          boxShadow: const [
            BoxShadow(color: Colors.blue, blurRadius: 6),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 18,
                fontFamily: FontFamily.oswald),
          ),
        ),
      ),
    );
  }
}
