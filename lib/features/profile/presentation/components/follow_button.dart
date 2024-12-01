import 'package:flutter/material.dart';
import 'package:instagram_clone/gen/fonts.gen.dart';

class FollowButton extends StatelessWidget {
  final bool isFollowing;
  final String text;
  final void Function() onTap;
  const FollowButton(
      {super.key,
      required this.onTap,
      required this.text,
      required this.isFollowing});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: isFollowing
                ? Theme.of(context).colorScheme.primary
                : Colors.blue,
            borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
                fontFamily: FontFamily.oswald, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
