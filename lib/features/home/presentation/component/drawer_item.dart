import 'package:flutter/material.dart';
import 'package:instagram_clone/gen/fonts.gen.dart';

class DrawerItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final void Function()? onTap;
  const DrawerItem(
      {super.key, required this.text, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(
        text,
        style: const TextStyle(fontFamily: FontFamily.oswald),
      ),
      leading: Icon(icon),
    );
  }
}
