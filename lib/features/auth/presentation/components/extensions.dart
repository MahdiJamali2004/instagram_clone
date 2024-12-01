import 'package:flutter/material.dart';
import 'package:instagram_clone/gen/fonts.gen.dart';

extension ScaffoldMessengerHelper on BuildContext {
  void showCustomSnackBar(String message, {SnackBarAction? action}) {
    if (action != null) {
      ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(
            content: Text(message),
            action: SnackBarAction(
                label: action.label, onPressed: action.onPressed)),
      );
    } else {
      ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }
  }
}

extension BoxMessage on BuildContext {
  void customAlertDialog(
      {required String title,
      required void Function() onAccept,
      required void Function() onCancel,
      Widget? content}) {
    showDialog(
      context: this,
      builder: (context) {
        return AlertDialog(
          content: content,
          title: Text(
            title,
            style: const TextStyle(fontFamily: FontFamily.oswald),
          ),
          actions: [
            //Accept
            TextButton(
                onPressed: () {
                  onAccept();
                  Navigator.pop(context);
                },
                child: const Text(
                  'Accept',
                  style: TextStyle(fontFamily: FontFamily.oswald),
                )),
            //Cancel
            TextButton(
                onPressed: onCancel,
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontFamily: FontFamily.oswald),
                )),
          ],
        );
      },
    );
  }
}
