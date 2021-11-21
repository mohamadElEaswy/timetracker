import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool?> showAlertDialog(BuildContext context,
    {required String title,
    required String? content, String? cancelActionText,
    required String defaultActionString}) async {
  if (!Platform.isIOS) {
    return showDialog(
      barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Text(content!),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(defaultActionString)),
                if(cancelActionText != null)
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(cancelActionText)),
              ],
            ));
  }
  return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
            title: Text(title),
            content: Text(content!),
            actions: [
              CupertinoDialogAction(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(defaultActionString)),
              if(cancelActionText != null)
                CupertinoDialogAction(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(cancelActionText)),
            ],
          ));
}
